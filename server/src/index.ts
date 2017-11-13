// This is the "main" file used by lambda, lambda will import it and attempt to call the handler function
import * as AWS from "aws-sdk";

AWS.config.update({region: "us-west-2"});
let dynamo = new AWS.DynamoDB();

console.log("Loading function");

class Scenario
{
    scenarioID          : String; // cannot be changed
    createdBy           : String;
    tags                : String[];

    questionText        : String;
    answerReasoning     : String;
    imageLoc            : String;

    type                : Number;
    initialAnswer       : Number;
    averageAnswer       : Number;
    standardDeviation   : Number;
    averageTimeToAnswer : Number;
    numberOfAnswers     : Number;
}

class ScenarioUpdate 
{
    scenarioID  : String; // cannot be changed
    updateID    : String; // cannot be changed
    answeredBy  : String;
    userAnswer  : Number;
    timeToAnswer: Number;
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


        callback(null, "Success");
    })


};
