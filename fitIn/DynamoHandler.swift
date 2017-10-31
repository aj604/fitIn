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
    
    var ScenarioID: String = "0";
    
    override init!() {
        super.init();
    }
    
    required init!(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    static func dynamoDBTableName() -> String {
                print("using1")
        return SCENARIO_MASTER_TABLE
    }
    
    static func hashKeyAttribute() -> String {
                print("using2")
        return SCENARIO_MASTER_TABLE_PRIMARY_KEY
    }
    
    // DO NOT UNCOMMENT UNLESS WE ADD A RANGE KEY
    /*static func rangeKeyAttribute() -> String {
                print("using3")
         return SCENARIO_MASTER_TABLE_PRIMARY_KEY
    }*/

}




class DynamoHandler {
    var paginatedOutput: AWSDynamoDBPaginatedOutput?
    var dynamo: AWSDynamoDBObjectMapper
    
    init() {
        dynamo = AWSDynamoDBObjectMapper(forKey: "USWest2DynamoDBObjectMapper")
    }
    
    func putItem(scenario : ScenarioA)  {
        print("putting")
        dynamo
            // .save(scenario as AWSDynamoDBObjectModel & AWSDynamoDBModeling)
            .save(scenario)
            .continueWith(block:
                { (task:AWSTask<AnyObject>!) -> Any? in
                                        if let error = task.error {
                                            print("putting The request failed. Error: \(error)")
                                        } else {
                                            print("putting success ", task.result)
                                            // Do something with task.result or perform other operations.
                                            
                                        }
                                        return task.result
            })
    }
    
    func getItem(scenario : ScenarioA)  {
        print("getting")
        dynamo
            .load(ScenarioA.self, hashKey: scenario.ScenarioID, rangeKey: nil)
            .continueWith(block:
                { (task:AWSTask<AnyObject>!) -> Any? in
                     print("success111111")
                    if let error = task.error {
                        print("getting The request failed. Error: \(error)")
                    } else {
                        print("getting success ", task.result)
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
                
                print("hellosrtgrtg")
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
