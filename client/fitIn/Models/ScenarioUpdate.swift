//
//  ScenarioUpdate.swift
//  fitIn
//
//  Created by schecko on 11/17/17.
//  Copyright © 2017 group of 5. All rights reserved.
//

import Foundation
import AWSDynamoDB

class ScenarioUpdate {
    
    var scenarioID : String
    var updateID : String
    var answeredBy : String
    var userAnswer : Int
    var timeToAnswer: Int // in milliseconds
    
    
    required init() {
        scenarioID = String(arc4random());
        updateID = String(arc4random());
        if let email = UserProfile.current()?.emailAddress {
            answeredBy = email;
        } else {
            answeredBy = "Anonymous";
        }
        userAnswer = 0;
        timeToAnswer = 0;
    }
    
    // Creates and returns a DynamoDB compatible dictionary representing this class.
    func toDBDictionary() -> [String : AWSDynamoDBAttributeValue] {
        
        return [
            SCENARIO_MASTER_TABLE_PRIMARY_KEY: makeAttrib(self.scenarioID),
            "updateID": makeAttrib(self.updateID),
            
            "userAnswer": makeAttrib(self.userAnswer),
            "timeToAnswer": makeAttrib(self.timeToAnswer)
        ]
    }
}
