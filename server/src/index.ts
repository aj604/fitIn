//
//  Scenario.swift
//  fitIn
//
//  Created by Scott Checko on 2017-10-07.
//  Copyright © 2017 group of 5. All rights reserved.
//  contributors: Vlad Polin, Scott Checko, Avery Jones, Aarish Kapila, Yanisa Chinitsarayos, Kevin Cheng
//  Known bugs:
//    

// This is the "main" file used by lambda, lambda will import it and attempt to call the handler function
import * as AWS from "aws-sdk";
import * as Scenario from "./scenario";
import * as fs from "fs";

// debug bool so that updates arent deleted after the merge is finished
// should be set to true for normal operation.
const DELETE = false;

// debug bool to output extra logging information,
// should be false for normal operation.
const VERBOSE_LOGS = false;


// This is a check to determine if there is a credentials file in the same
// directory. This is specifically for testing on the macs and for the
// TAs to test out the server locally.
if(fs.existsSync("./creds.json")) {
	console.log("found creds");
	AWS.config.loadFromPath('./creds.json');
}

AWS.config.update({region: "us-west-2"});
let dynamo = new AWS.DynamoDB();

// This enum and switch are used to determine which OS
// this code is running on
enum Platform {
    OTHER,
    WINDOWS,
    MAC,
    LINUX
}
let platform : Platform;
switch(process.platform) {
    case "darwin":
        platform = Platform.MAC
        break;
    case "win32": // works on 64bit as well
        platform = Platform.WINDOWS
        break;
    case "linux": // lambda runtime is an amazon linux image
        platform = Platform.LINUX
        break;
    default:
        platform = Platform.OTHER
        break;
}

// This is a wrapper function for the default console.log
// this function supports two log levels, VERBOSE(true) and NORMAL(false)
function log(verbose: boolean = false, message: String, ...optionalParams: any[]) {
    if(verbose) {
        if(VERBOSE_LOGS) {
            console.log(message, ...optionalParams);
        }
    } else {
        console.log(message, ...optionalParams);
    }
}

// set the throttle rate to something smaller when locally debugging, 
// local debugging only happens in windows or osx machines
const THROTTLE_RATE = (platform === Platform.WINDOWS.valueOf() || platform === Platform.MAC.valueOf()) ?  1 : 1000;

// set the scan limit to something reasonably small, this helps prevent three things:
// 1. The scan operation is very slow compared to other DynamoDB operations, and so this limit spreads out the slowness.
// 2. The scan operation results in spikes of DynamoDB usage, which could cause throttling if set too high.
// 3. Large scan operations are "paged", resulting in more complexity than is worth.
const SCAN_LIMIT = 10;

// This is a "Promisified" version of Node's Timeout function
// The function will sleep for <amount> milliseconds.
function sleep(amount: Number): Promise<void> {
    return new Promise<void>((resolve, reject) => {
        setTimeout(() =>{
            resolve();
        }, amount);
    })
}

// This function converts any NaNs to zeros
// This prevents DynamoDB errors, since it does not support NaN
function noNan(number: number): number {
    if(Number.isNaN(number))
    {
    	log(true, "warning, nan found");
        number = 0.0;
    }
    return number;
}

// This function is the primary purpose of the server, it "merges" a scenario with
// a scenario update by calculating rolling averages and rolling standard deviations 
// along with handling the number of answers increments.
// After this function completes, the ScenarioUpdate can be deleted from the database
function merge(scenario: Scenario.Scenario, update: Scenario.ScenarioUpdate): void {

    // rolling average answer
    scenario.averageAnswer = (scenario.averageAnswer * scenario.numberOfAnswers + update.userAnswer * 1) / (scenario.numberOfAnswers + 1);

    // rolling time to answer
    scenario.averageTimeToAnswer = (scenario.averageTimeToAnswer * scenario.numberOfAnswers + update.timeToAnswer * 1) / (scenario.numberOfAnswers + 1);

    // standard deviation algorithm from:
    // https://en.wikipedia.org/wiki/Algorithms_for_calculating_variance#Online_algorithm
    // under the "online algorithm" section, second set of equations

    //rolling standard deviation
    let oldMean = scenario.mean;
    scenario.mean = scenario.mean + (update.userAnswer - scenario.mean) / (scenario.numberOfAnswers + 1)

    scenario.currentMean = scenario.currentMean + (update.userAnswer - oldMean) * (update.userAnswer - scenario.mean)

    scenario.standardDeviation = Math.sqrt(scenario.currentMean / (scenario.numberOfAnswers + 1));

    // last
    scenario.numberOfAnswers++;

    scenario.averageAnswer = noNan(scenario.averageAnswer);
    scenario.averageTimeToAnswer = noNan(scenario.averageTimeToAnswer);
    scenario.mean = noNan(scenario.mean);
    scenario.currentMean = noNan(scenario.currentMean);
    scenario.standardDeviation = noNan(scenario.standardDeviation);

}

// This is equivelent to a C++ "main" function for an AWS Lambda function
// ie. this is the "entrypoint"
// When calling this function, Lambda provides 3 objects:
// event:
//      An AWS Event, relevent for some other AWS integrations, unused.
// context:
//      A bunch of information about the lambda, unused.
// callback:
//      A function that, when called, indicates the end of the lambda, used.
//      The first parameter of this function is an error object, which we can
//      pass to AWS if there was an error, passing null here indicates success.
//      The second parameter is a message
exports.handler = (event, context, callback) => {
    // console.log("Received event:", JSON.stringify(event, null, 2));

    // Overall functionality of the server:
    // 1: scan items from the updates table
    // 2: from the updates, figure out which scenarioIDs need to be updated from the master table
    // 3: get the scenarios to be updated
    // 4: merge the update(s) with the scenario
    // 5: put the scenario back into master
    // 6: delete the updates that were consumed from the updates table

    // This code is designed to run once, and only once per invocation.
    // This is due to the AWS Lambda architecture. AWS handles the timing of invocation
    // as configured by us. Therefore, this server is NOT designed as a background process
    // that runs indefinately (It could be converted to run indefinately though, assuming something
    // else other than lambda is hosting it).


    let scanArgs: AWS.DynamoDB.ScanInput = {
        TableName: "scenarioUpdate",
        ConsistentRead: false,
        Limit: SCAN_LIMIT
    }

    // perform a scan on the updates table
    dynamo.scan(scanArgs).promise()
    .then((result: AWS.DynamoDB.ScanOutput) => {
        // scan complete, deal with the ressults of the scan.

        log(false, "successfully scanned " + result.Count + " updates");
        log(true, "scan results: \n", result.Items, "\n\n");

        // create an array of ScenarioUpdates from the database objects
        let scenarioUpdates : Scenario.ScenarioUpdate[] = result.Items.map((value: AWS.DynamoDB.AttributeMap) => {
            let scenarioUpdate : Scenario.ScenarioUpdate = new Scenario.ScenarioUpdate;
            scenarioUpdate.fromDB(value);
            return scenarioUpdate;
        });

        // the same scenario may be updated more than once, so make a mapping
        // containing an array of updates. This minimizes the number of requests
        // to the database. the order of the updates does not matter.
        let updatesMap = new Map<string, Array<Scenario.ScenarioUpdate>>();

        scenarioUpdates.forEach((value: Scenario.ScenarioUpdate) => {
            let updates = updatesMap.get(value.scenarioID);
            if(updates) {
                updates.push(value);
                updatesMap.set(value.scenarioID, updates);
            } else {
                updatesMap.set(value.scenarioID, [value]);
            }
        });

        log(false, "successfully generated a map of size: ", updatesMap.size)
        log(true, "successfully generated a map of updates:\n", updatesMap, " \n\n ")

        let scenariosMap = new Map<string, Scenario.Scenario>();

        // grab the scenarios associated with all of the scenarioUpdates
        let task = Promise.resolve();
        updatesMap.forEach((value: Scenario.ScenarioUpdate[], key: string) => {
            // "task = task.then" is a way of generating a very long chain of
            // tasks that all complete one after another, not in parallel.
            // this allows me to apply throttling on the requests to avoid spikes of
            // usage.
            task = task.then(() => {
                let request: AWS.DynamoDB.GetItemInput = {
                    TableName: "scenarioMaster",
                    Key: { 
                        "scenarioID": { S: key }
                     }
                }         

                return dynamo.getItem(request).promise()
                    .then((item: AWS.DynamoDB.GetItemOutput) => {
                        log(false, "successfully retrieved scenario: ", item.Item.scenarioID.S)
						log(true, "successfully retrieved scenario: \n", item.Item, "\n\n")
                        if(!item.Item)
                        {
                            // scenario does not exist
                            // -> probably becausethe update was made manually in the AWS Console
                            return sleep(THROTTLE_RATE);
                        }

                        let scenario = new Scenario.Scenario();
                        scenario.fromDB(item.Item);
                        scenariosMap.set(scenario.scenarioID, scenario);

                        return sleep(THROTTLE_RATE);
                    })
                    .catch((error) => {
                        log(false, "failed to get scenario: ", key, " there is a good chance the scenario does not exist")
                        log(false, "error " + error);
                    });
            });
        });

        
        return task
            .then(() => {
                // at this point, all get requests to the scenario table are completed.
                log(false, "successfully retrieved ", scenariosMap.size, " scenarios");
                log(true, "successfully generated a map of scenarios: \n", scenariosMap, " \n\n ");

                log(false, "successfully obtained all updates and scenarios");
                return Promise.resolve({scen: scenariosMap, updates: updatesMap});
            });
    })
    .then((scenarios: any) => {
        let scenariosMap : Map<string, Scenario.Scenario> = scenarios.scen;
        let updatesMap : Map<string, Scenario.ScenarioUpdate[]> = scenarios.updates;


        // merge all updates with scenarios
        // iterate over scenarios instead of updates incase a scenario did not exist for a set of updates
        scenariosMap.forEach((scenario: Scenario.Scenario, key: string) => {
            updatesMap.get(key).forEach((update: Scenario.ScenarioUpdate, index: number) => {
                merge(scenario, update);
            });
        });

        log(false, "successfully merged all scenarios and updates");
        log(true, "merge results: ", scenariosMap, " \n\n ");

        // all of the merges are complete, now do two things:
        // 1. delete all of the updates
        // 2. put the newly updates scenarios
        let puts = Promise.resolve();
        let deletes = Promise.resolve();

        // perform the puts, with throttling.
        scenariosMap.forEach((scenario: Scenario.Scenario, key: string) => 
        {
            puts = puts.then(() => 
            {
                let request: AWS.DynamoDB.PutItemInput = 
                {
                    TableName: "scenarioMaster",
                    Item: scenario.toDB()
                }    

                log(false, "performing put on scenario: ", key);
                log(true, "item to put \n", request.Item, " \n\n ");  

                return dynamo.putItem(request).promise()
                    .then(() =>{
                        return sleep(THROTTLE_RATE);
                    })
            });
        });

        // perform the deletes, with throttling.
        updatesMap.forEach((updates: Scenario.ScenarioUpdate[], key: String) =>
        {
            updates.forEach((update: Scenario.ScenarioUpdate, index: number) => 
            {
                if(DELETE)
                {
                    deletes = deletes.then(() => 
                    {
                        let request: AWS.DynamoDB.DeleteItemInput = 
                        {
                            TableName: "scenarioUpdate",
                            Key: { 
                                "scenarioID": { S: key as string },
                                "updateID": { S: update.updateID as string }
                            }
                        }      
                        log(false, "performing delete on update: ", update.updateID);
                        return dynamo.deleteItem(request).promise()
                            .then(() => 
                            {
                                return sleep(THROTTLE_RATE);
                            });
                    });
                }
            });
        });


        return Promise.all
        (
            [
                puts,
                deletes
            ]
        )

    })
    .then(() => {
        // all tasks are finished
        log(false, "Successfully performed all tasks");
        callback(null, "Successfully performed all tasks");
    })
    .catch((error) => {
        // server errored somewhere.
        log(false, "exiting with failure: " + error);
        callback(new Error("failure: " + error));
    })


};
