//
//  DynamoHandler.swift
//  fitIn
//
//  Created by schecko on 10/30/17.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import Foundation
import AWSDynamoDB

class Scenario2 : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var scenarioID: Int
    
    override init() {
        self.scenarioID = 0;
        super.init();
    }
    
    required init(coder: NSCoder) {
        self.scenarioID = 0;
        super.init(coder: coder);
    }
    
    static func dynamoDBTableName() -> String {
        return SCENARIO_MASTER_TABLE
    }
    
    static func hashKeyAttribute() -> String {
        return SCENARIO_MASTER_TABLE_PRIMARY_KEY
    }

}

class DynamoHandler {
    var paginatedOutput: AWSDynamoDBPaginatedOutput?
    var dynamo: AWSDynamoDBObjectMapper
    
    init() {
        do {
            dynamo = AWSDynamoDBObjectMapper.default();
        } catch {
            print("Fuck")
        
        }
    }
    
    func putItem(scenario : Scenario2)  {
        dynamo
            .save(scenario as AWSDynamoDBObjectModel & AWSDynamoDBModeling)
            .continueWith(block:
                { (task:AWSTask<AnyObject>!) -> Any? in
                                        if let error = task.error {
                                            print("The request failed. Error: \(error)")
                                        } else {
                                            print("success")
                                            // Do something with task.result or perform other operations.
                                            
                                        }
                                        return task.result
            })
    }
    
}
