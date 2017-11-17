// This is the "main" file used by lambda, lambda will import it and attempt to call the handler function
import * as AWS from "aws-sdk";

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


// Turns out strings are not Strings.
function stringArrayToDBAttribArray(strings: String[]) : AWS.DynamoDB.StringAttributeValue[] {

    let items : AWS.DynamoDB.StringSetAttributeValue = [];
    return strings.map((value: String, index: Number) : AWS.DynamoDB.StringAttributeValue => 
    {
        return value.toString();
    });
}

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

class Scenario
{
    scenarioID          : string; // cannot be changed
    createdBy           : string;
    tags                : string[];

    questionText        : string;
    answerReasoning     : string;
    imageLoc            : string;

    type                : Number;
    initialAnswer       : Number;
    averageAnswer       : Number;
    standardDeviation   : Number;
    averageTimeToAnswer : Number;
    numberOfAnswers     : Number;

    fromDB(item: AWS.DynamoDB.AttributeMap) : void {
        this.scenarioID = item["scenarioID"].S;
        this.createdBy = item["createdBy"].S;
        // this.tags = item["tags"].SS;

        this.questionText = item["questionText"].S;
        this.answerReasoning = item["answerReasoning"].S;
        this.imageLoc = item["imageLoc"].S;

        this.type = parseInt(item["type"].N, 10);
        this.initialAnswer = parseInt(item["initialAnswer"].N, 10);
        // this.averageAnswer = parseFloat(item["averageAnswer"].N);
        // this.standardDeviation = parseFloat(item["standardDeviation"].N);
        // this.averageTimeToAnswer = parseFloat(item["averageTimeToAnswer"].N);
        this.numberOfAnswers = parseInt(item["numberOfAnswers"].N, 10);
    }

    toDB() : AWS.DynamoDB.AttributeMap {
        let item : AWS.DynamoDB.AttributeMap = {};

        item["scenarioID"].S = this.scenarioID.toString();
        item["createdBy"].S = this.createdBy.toString();
        item["tags"].SS = stringArrayToDBAttribArray(this.tags)

        item["questionText"].S = this.questionText.toString();
        item["answerReasoning"].S = this.answerReasoning.toString();
        item["imageLoc"].S = this.imageLoc.toString();

        item["type"].N = this.imageLoc.toString();
        item["initialAnswer"].N = this.initialAnswer.toString();
        item["averageAnswer"].N = this.averageAnswer.toString();
        item["standardDeviation"].N = this.standardDeviation.toString();
        item["averageTimeToAnswer"].N = this.averageTimeToAnswer.toString();
        item["numberOfAnswers"].N = this.numberOfAnswers.toString();

        return item;
    }

}

class ScenarioUpdate 
{
    scenarioID  : string; // cannot be changed
    updateID    : string; // cannot be changed
    answeredBy  : string;
    userAnswer  : Number;
    timeToAnswer: Number;

    fromDB(item: AWS.DynamoDB.AttributeMap) {
        this.scenarioID = item["scenarioID"].S;
        this.updateID = item["updateID"].S;
        // this.answeredBy = item["answeredBy"].S;
        // this.userAnswer = parseInt(item["userAnswer"].N, 10);
        // this.timeToAnswer = parseInt(item["timeToAnswer"].N, 10);
    }

    // NOTE: no need to do toDB()
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

        let scenarioUpdates : ScenarioUpdate[] = result.Items.map((value: AWS.DynamoDB.AttributeMap) => {
            let scenarioUpdate : ScenarioUpdate = new ScenarioUpdate;
            scenarioUpdate.fromDB(value);
            return scenarioUpdate;
        });

        console.log(scenarioUpdates);

        // the same scenario may be updated more than once, so make a mapping
        // containing an array of updates. This minimizes the number of requests
        // to the database. the order of the updates does not matter.
        let updatesMap = new Map<string, ScenarioUpdate[]>();

        scenarioUpdates.forEach((value: ScenarioUpdate) => {
            let updates = updatesMap.get(value.scenarioID);
            if(updates) {
                updates.push(value);
                updatesMap.set(value.scenarioID, updates);
            } else {
                updatesMap.set(value.scenarioID, [value]);
            }
        });
        console.log(updatesMap);

        let scenariosMap = new Map<string, Scenario>();

        let task = Promise.resolve();
        updatesMap.forEach((value: ScenarioUpdate[], key: string) =>{
            task = task.then(() =>{

                let theKey : AWS.DynamoDB.Key = {
                    
                } 

                let request: AWS.DynamoDB.GetItemInput = {
                    TableName: "scenarioMaster",
                    Key: { 
                        "scenarioID": { S: key }
                     }
                }         

                return dynamo.getItem(request).promise()
                    .then((item: AWS.DynamoDB.GetItemOutput) => {

                        let scenario = new Scenario();
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
        let scenariosMap : Map<string, Scenario> = scenarios[0];
        let scenarioUpdates : Map<string, ScenarioUpdate[]> = scenarios[1];


        // merge all updates with scenarios

    })
    .then(() => {
        callback(null, "Success");
    })
    .catch((error) => {
        callback(new Error("failure: " + error));
    })


};
