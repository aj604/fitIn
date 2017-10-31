//
//  DynamoHandler.swift
//  fitIn
//
//  Created by schecko on 10/30/17.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import Foundation
import AWSDynamoDB

class ScenarioA : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var scenarioID: Int = 0;
    
    override init!() {
        super.init();
    }
    
    required init!(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return ["scenarioID" : "hashKey1"];
    }
    
    static func dynamoDBTableName() -> String {
        return SCENARIO_MASTER_TABLE
    }
    
    static func hashKeyAttribute() -> String {
        return SCENARIO_MASTER_TABLE_PRIMARY_KEY
    }
    
/*/class func rangeKeyAttribute() -> String {
        return SCENARIO_MASTER_TABLE_PRIMARY_KEY
    }*/

}




class DynamoHandler {
    var paginatedOutput: AWSDynamoDBPaginatedOutput?
    var dynamo: AWSDynamoDBObjectMapper
    
    init() {
            dynamo = AWSDynamoDBObjectMapper.default();
    }
    
    func putItem(scenario : ScenarioA)  {
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
    
    func getItem(scenario : ScenarioA)  {
        dynamo
            .load(ScenarioA.self, hashKey: "", rangeKey: nil)
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
    
    func scan(scenario : ScenarioA)  {
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 20
        
        dynamo.scan(ScenarioA.self, expression: scanExpression)
            .continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
                
                print("hello")
            if let error = task.error {
                print("The request failed. Error: \(error)")
            } else if let paginatedOutput = task.result {
                print("successs")

                    print(paginatedOutput.items)

                for book in paginatedOutput.items as! [ScenarioA] {
                    // Do something with book.
                    print("scenario ", book)
                }
            }
            
            return ()
            
        })
    }
    
}
