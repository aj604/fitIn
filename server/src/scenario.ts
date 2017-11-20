//
//  Scenario.swift
//  fitIn
//
//  Created by Scott Checko on 2017-10-07.
//  Copyright © 2017 group of 5. All rights reserved.
//  contributors: Vlad Polin, Scott Checko, Avery Jones, Aarish Kapila, Yanisa Chinitsarayos, Kevin Cheng
//  Known bugs:
//    

import * as AWS from "aws-sdk";

// this is a mirror class of the client Scenerio Class, it represents a Scenario.
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

    constructor() {
        this.scenarioID = "a";
        this.createdBy = "a";
        // this.tags = item["tags"].SS;

        this.questionText = "a";
        this.answerReasoning = "a";
        this.imageLoc = "a";

        this.type = 0;
        this.initialAnswer = 0;
        this.averageAnswer  = 0;
        this.averageTimeToAnswer = 0;
        this.numberOfAnswers  = 0;
    
        this.standardDeviation = 0;
        this.mean = 0;
        this.currentMean = 0;
    }

    // This function converts an AWS DynamoDB dictionary to a usable format
    // ie, it initializes a Scenario instance.
    fromDB(item: AWS.DynamoDB.AttributeMap) : void {
        this.scenarioID = item["scenarioID"].S;
        try { this.createdBy = item["createdBy"].S;                                 } catch(e){this.createdBy = "a"}
        // this.tags = item["tags"].SS;

        try { this.questionText = item["questionText"].S;                           } catch(e){this.questionText = "a"}
        try { this.answerReasoning = item["answerReasoning"].S;                     } catch(e){this.answerReasoning = "a"}
        try { this.imageLoc = item["imageLoc"].S;                                   } catch(e){this.imageLoc = "a"}

        try { this.type = parseInt(item["type"].N, 10);                             } catch(e){this.type = 0}
        try { this.initialAnswer = parseInt(item["initialAnswer"].N, 10);           } catch(e){this.initialAnswer = 0}
        try { this.averageAnswer = parseFloat(item["averageAnswer"].N);             } catch(e){this.averageAnswer = 0}
        try { this.averageTimeToAnswer = parseFloat(item["averageTimeToAnswer"].N); } catch(e){this.averageTimeToAnswer = 0}
        try { this.numberOfAnswers = parseInt(item["numberOfAnswers"].N, 10);       } catch(e){this.numberOfAnswers = 0}

        try { this.standardDeviation = parseFloat(item["standardDeviation"].N);     } catch(e){this.standardDeviation = 0}
        try { this.mean = parseFloat(item["mean"].N);                               } catch(e){this.mean = 0}
        try { this.currentMean = parseFloat(item["currentMean"].N);                 } catch(e){this.currentMean = 0}
    }

    // This function creates an AWSDynamoDB dictionary from a Scenario Instance
    toDB() : AWS.DynamoDB.AttributeMap {
        let item : AWS.DynamoDB.AttributeMap = {};

        item["scenarioID"] = { S: this.scenarioID };
        try { item["createdBy"] = { S: this.createdBy };                                } catch(e){}
        // item["tags"] = { SS: this.tags };

        try { item["questionText"] = { S: this.questionText };                          } catch(e){}
        try { item["answerReasoning"] = { S: this.answerReasoning };                    } catch(e){}
        try { item["imageLoc"] = { S: this.imageLoc };                                  } catch(e){}

        try { item["type"] = { N: this.type.toString() };                               } catch(e){}
        try { item["initialAnswer"] = { N: this.initialAnswer.toString() };             } catch(e){}
        try { item["averageAnswer"] = { N: this.averageAnswer.toString() };             } catch(e){}
        try { item["averageTimeToAnswer"] = { N: this.averageTimeToAnswer.toString() }; } catch(e){}
        try { item["numberOfAnswers"] = { N: this.numberOfAnswers.toString() };         } catch(e){}

        try { item["standardDeviation"] = { N: this.standardDeviation.toString() };     } catch(e){}
        try { item["mean"] = { N: this.mean.toString() };                               } catch(e){}
        try { item["currentMean"] = { N: this.currentMean.toString() };                 } catch(e){}

        return item;
    }

}

// This class represents an update to a scenario
// as such, it is a very trimmed down scenario containing
// enough information to update a real scenario with its contents.
export class ScenarioUpdate 
{
    scenarioID  : string; // cannot be changed
    updateID    : string; // cannot be changed
    answeredBy  : string;
    userAnswer  : number;
    timeToAnswer: number;

    // This function converts an AWS DynamoDB dictionary to a usable format
    // ie, it initializes a ScenarioUpdate instance.
    fromDB(item: AWS.DynamoDB.AttributeMap) {
        this.scenarioID = item["scenarioID"].S;
        this.updateID = item["updateID"].S;
        try { this.answeredBy = item["answeredBy"].S;                   } catch(e){}
        try { this.userAnswer = parseInt(item["userAnswer"].N, 10);     } catch(e){}
        try { this.timeToAnswer = parseInt(item["timeToAnswer"].N, 10); } catch(e){}
    }

    // NOTE: no need to do toDB()
    // A ScenarioUpdate is only ever created by the client,
    // and because of this the server will only ever delete 
    // the ScenarioUpdate after it is used.
}