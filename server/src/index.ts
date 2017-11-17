// This is the "main" file used by lambda, lambda will import it and attempt to call the handler function
import * as AWS from "aws-sdk";
import * as Scenario from "./scenario";

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

// might not be needed
/*function DBAttribArrayToStringArray(strings: AWS.DynamoDB.StringAttributeValue[]) : String[] {

    let items : AWS.DynamoDB.StringSetAttributeValue = [];
    return strings.map((value: String, index: Number) : AWS.DynamoDB.StringAttributeValue => 
    {
        return value.toString();
    });
}*/

function sleep(amount: Number): Promise<void> {

    return new Promise<void>((resolve, reject) => {
        setTimeout(() =>{
            resolve();
        }, amount);
    })
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

    scenario.variance = scenario.currentMean / (scenario.numberOfAnswers + 1);

    // last
    scenario.numberOfAnswers++;

}

exports.handler = (event, context, callback) => {
    console.log("Received event:", JSON.stringify(event, null, 2));

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
        console.log(result);
        console.log("done");

        let scenarioUpdates : Scenario.ScenarioUpdate[] = result.Items.map((value: AWS.DynamoDB.AttributeMap) => {
            let scenarioUpdate : Scenario.ScenarioUpdate = new Scenario.ScenarioUpdate;
            scenarioUpdate.fromDB(value);
            return scenarioUpdate;
        });

        console.log(scenarioUpdates);

        // the same scenario may be updated more than once, so make a mapping
        // containing an array of updates. This minimizes the number of requests
        // to the database. the order of the updates does not matter.
        let updatesMap = new Map<string, Scenario.ScenarioUpdate[]>();

        scenarioUpdates.forEach((value: Scenario.ScenarioUpdate) => {
            let updates = updatesMap.get(value.scenarioID);
            if(updates) {
                updates.push(value);
                updatesMap.set(value.scenarioID, updates);
            } else {
                updatesMap.set(value.scenarioID, [value]);
            }
        });
        console.log(updatesMap);

        let scenariosMap = new Map<string, Scenario.Scenario>();

        // grab the scenarios associated with all of the scenarioUpdates
        let task = Promise.resolve();
        updatesMap.forEach((value: Scenario.ScenarioUpdate[], key: string) =>{
            task = task.then(() =>{

                let request: AWS.DynamoDB.GetItemInput = {
                    TableName: "scenarioMaster",
                    Key: { 
                        "scenarioID": { S: key }
                     }
                }         

                return dynamo.getItem(request).promise()
                    .then((item: AWS.DynamoDB.GetItemOutput) => {

                        let scenario = new Scenario.Scenario();
                        scenario.fromDB(item.Item);
                        scenariosMap.set(scenario.scenarioID, scenario);

                        return sleep(THROTTLE_RATE);
                    })
                    .catch((error) => {
                        console.log("get of scenarioID failed, there is a good chance the scenario does not exist")
                        console.log("error " + error);
                    });
            })
        })

        return task
            .then(() => {
                return Promise.resolve([scenariosMap, scenarioUpdates]);
            });
    })
    .then((scenarios: [any]) => {
        let scenariosMap : Map<string, Scenario.Scenario> = scenarios[0];
        let scenarioUpdates : Map<string, Scenario.ScenarioUpdate[]> = scenarios[1];


        // merge all updates with scenarios

    })
    .then(() => {
        callback(null, "Success");
    })
    .catch((error) => {
        callback(new Error("failure: " + error));
    })


};
