// This is the "main" file used by lambda, lambda will import it and attempt to call the handler function
import * as AWS from "aws-sdk";
import * as Scenario from "./scenario";

// debug bool so that updates arent deleted after the merge is finished
// should be set to true for normal operation.
let DELETE = true;

AWS.config.update({region: "us-west-2"});
let dynamo = new AWS.DynamoDB();

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

// set the throttle rate to something smaller when locally debugging, 
// local debugging only happens in windows or osx machines
const THROTTLE_RATE = (platform === Platform.WINDOWS.valueOf() || platform === Platform.MAC.valueOf()) ?  1 : 1000;

function sleep(amount: Number): Promise<void> {

    return new Promise<void>((resolve, reject) => {
        setTimeout(() =>{
            resolve();
        }, amount);
    })
}

function noNan(number: number): number {
    if(Number.isNaN(number) || number != number)
    {
        number = 0.0;
    }
    return number;
}

function merge(scenario: Scenario.Scenario, update: Scenario.ScenarioUpdate): void {

    // for standard deviation later
    let oldAverage: number = scenario.averageAnswer;

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

exports.handler = (event, context, callback) => {
    // console.log("Received event:", JSON.stringify(event, null, 2));

    // 1: scan items from the updates table
    // 2: from the updates, figure out which scenarioIDs need to be updated from the master table
    // 3: get the scenarios to be updated
    // 4: merge the update(s) with the scenario
    // 5: put the scenario back into master
    // 6: delete the updates that were consumed from the updates table


    let scanArgs: AWS.DynamoDB.ScanInput = {
        TableName: "scenarioUpdate",
        ReturnConsumedCapacity: "TOTAL",
        ConsistentRead: false
    }

    dynamo.scan(scanArgs).promise()
    .then((result: AWS.DynamoDB.ScanOutput) => {

        console.log("successfully scanned " + result.Count + " updates");
        console.log("scan results: \n", result.Items, "\n\n");

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

        console.log("successfully generated a map of updates:\n", updatesMap, " \n\n ")

        let scenariosMap = new Map<string, Scenario.Scenario>();

        // grab the scenarios associated with all of the scenarioUpdates
        let task = Promise.resolve();
        updatesMap.forEach((value: Scenario.ScenarioUpdate[], key: string) => {
            task = task.then(() => {

                let request: AWS.DynamoDB.GetItemInput = {
                    TableName: "scenarioMaster",
                    Key: { 
                        "scenarioID": { S: key }
                     }
                }         

                return dynamo.getItem(request).promise()
                    .then((item: AWS.DynamoDB.GetItemOutput) => {

                        if(!item.Item)
                        {
                            // scenario does not exist
                            // -> probably because it was made manually in the AWS Console
                            return sleep(THROTTLE_RATE);
                        }

                        console.log("successfully retrieved scenario: \n", item.Item, "\n\n")
                        let scenario = new Scenario.Scenario();
                        scenario.fromDB(item.Item);
                        scenariosMap.set(scenario.scenarioID, scenario);

                        return sleep(THROTTLE_RATE);
                    })
                    .catch((error) => {
                        console.log("failed to get scenario: ", key, " there is a good chance the scenario does not exist")
                        console.log("error " + error);
                    });
            })
        })

        return task
            .then(() => {
                console.log("successfully retrieved ", scenariosMap.size, " scenarios");
                console.log("successfully generated a map of scenarios: \n", scenariosMap, " \n\n ");

                console.log("successfully obtained all updates and scenarios");
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

        console.log("successfully merged all scenarios and updates");
        console.log("merge results: ", scenariosMap, " \n\n ");
        let puts = Promise.resolve();
        let deletes = Promise.resolve();

        scenariosMap.forEach((scenario: Scenario.Scenario, key: string) => 
        {
            puts = puts.then(() => 
            {
                let request: AWS.DynamoDB.PutItemInput = 
                {
                    TableName: "scenarioMaster",
                    Item: scenario.toDB()
                }    

                console.log("item to put \n", request.Item, " \n\n ");  

                return dynamo.putItem(request).promise()
                    .then(() =>{
                        return sleep(THROTTLE_RATE);
                    })
            });
        });

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
        console.log("Successfully performed all tasks");
        callback(null, "Successfully performed all tasks");
    })
    .catch((error) => {
        console.log("failure: " + error);
        callback(new Error("failure: " + error));
    })


};
