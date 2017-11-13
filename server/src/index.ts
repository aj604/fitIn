// This is the "main" file used by lambda, lambda will import it and attempt to call the handler function
import * as AWS from "aws-sdk";

AWS.config.update({region: "us-west-2"});
let dynamo = new AWS.DynamoDB();

console.log("Loading function");

// Turns out strings are not Strings.
function stringArrayToDBAttribArray(strings: String[]) : AWS.DynamoDB.StringAttributeValue[] {

    let items : AWS.DynamoDB.StringSetAttributeValue = [];
    return strings.map((value: String, index: Number) : AWS.DynamoDB.StringAttributeValue => 
    {
        return value.toString();
    });
}

function DBAttribArrayToStringArray(strings: AWS.DynamoDB.StringAttributeValue[]) : String[] {

    let items : AWS.DynamoDB.StringSetAttributeValue = [];
    return strings.map((value: String, index: Number) : AWS.DynamoDB.StringAttributeValue => 
    {
        return value.toString();
    });
}

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

    fromDB(item: AWS.DynamoDB.AttributeMap) : void {
        this.scenarioID = item["scenarioID"].S;
        this.createdBy = item["createdBy"].S;
        this.tags = item["tags"].SS;

        this.questionText = item["questionText"].S;
        this.answerReasoning = item["answerReasoning"].S;
        this.imageLoc = item["imageLoc"].S;

        this.type = parseInt(item["type"].N, 10);
        this.initialAnswer = parseInt(item["initialAnswer"].N, 10);
        this.averageAnswer = parseFloat(item["averageAnswer"].N);
        this.standardDeviation = parseFloat(item["standardDeviation"].N);
        this.averageTimeToAnswer = parseFloat(item["averageTimeToAnswer"].N);
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
    scenarioID  : String; // cannot be changed
    updateID    : String; // cannot be changed
    answeredBy  : String;
    userAnswer  : Number;
    timeToAnswer: Number;

    fromDB(item: AWS.DynamoDB.AttributeMap) {
        this.scenarioID = item["scenarioID"].S;
        this.updateID = item["updateID"].S;
        this.answeredBy = item["answeredBy"].S;
        this.userAnswer = parseInt(item["userAnswer"].N, 10);
        this.timeToAnswer = parseInt(item["timeToAnswer"].N, 10);
    }
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
