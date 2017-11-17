
import * as AWS from "aws-sdk";

// Turns out strings are not Strings.
export function stringArrayToDBAttribArray(strings: String[]) : AWS.DynamoDB.StringAttributeValue[] {

    let items : AWS.DynamoDB.StringSetAttributeValue = [];
    return strings.map((value: String, index: Number) : AWS.DynamoDB.StringAttributeValue => 
    {
        return value.toString();
    });
}

export class Scenario
{
    scenarioID          : string; // cannot be changed
    createdBy           : string;
    tags                : string[];

    questionText        : string;
    answerReasoning     : string;
    imageLoc            : string;

    type                : number;
    initialAnswer       : number;
    averageAnswer       : number;
    averageTimeToAnswer : number;
    numberOfAnswers     : number;

    standardDeviation   : number;
    mean                : number;
    currentMean         : number; // see merge() function for comments on standard deviation


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
        // this.averageTimeToAnswer = parseFloat(item["averageTimeToAnswer"].N);
        this.numberOfAnswers = parseInt(item["numberOfAnswers"].N, 10);

        // this.standardDeviation = parseFloat(item["standardDeviation"].N);
        // this.mean = parseFloat(item["mean"].N);
        // this.currentMean = parseFloat(item["currentMean"].N);
    }

    toDB() : AWS.DynamoDB.AttributeMap {
        let item : AWS.DynamoDB.AttributeMap = {};

        item["scenarioID"] = { S: this.scenarioID };
        item["createdBy"] = { S: this.createdBy };
        item["tags"] = { SS: this.tags };

        item["questionText"] = { S: this.questionText };
        item["answerReasoning"] = { S: this.answerReasoning };
        item["imageLoc"] = { S: this.imageLoc };

        item["type"] = { N: this.type.toString() };
        item["initialAnswer"] = { N: this.initialAnswer.toString() };
        item["averageAnswer"] = { N: this.averageAnswer.toString() };
        item["averageTimeToAnswer"] = { N: this.averageTimeToAnswer.toString() };
        item["numberOfAnswers"] = { N: this.numberOfAnswers.toString() };

        item["standardDeviation"] = { N: this.standardDeviation.toString() };
        item["mean"] = { N: this.mean.toString() };
        item["currentMean"] = { N: this.currentMean.toString() };

        return item;
    }

}

export class ScenarioUpdate 
{
    scenarioID  : string; // cannot be changed
    updateID    : string; // cannot be changed
    answeredBy  : string;
    userAnswer  : number;
    timeToAnswer: number;

    fromDB(item: AWS.DynamoDB.AttributeMap) {
        this.scenarioID = item["scenarioID"].S;
        this.updateID = item["updateID"].S;
        // this.answeredBy = item["answeredBy"].S;
        // this.userAnswer = parseInt(item["userAnswer"].N, 10);
        // this.timeToAnswer = parseInt(item["timeToAnswer"].N, 10);
    }

    // NOTE: no need to do toDB()
}