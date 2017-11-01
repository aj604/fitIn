//
//  DynamoHandler.swift
//  fitIn
//
//  Created by schecko on 10/30/17.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import Foundation
import AWSDynamoDB

class DynamoHandler {
    var paginatedOutput: AWSDynamoDBPaginatedOutput?
    var dynamo: AWSDynamoDB
    
    init() {
        dynamo = AWSDynamoDB.default();
    }
    
    func setStuff(tableName: String, dict: [String: String]) {
        let put = AWSDynamoDBPutItemInput()
        
        put!.tableName = tableName
        put!.item = [:]
        dict.forEach({(key: String, value: String) in
            let attrib = AWSDynamoDBAttributeValue()
            attrib?.s = value
            put!.item!.merge([key: attrib!], uniquingKeysWith:
                {
                    (a: AWSDynamoDBAttributeValue, b: AWSDynamoDBAttributeValue) in
                    return a;
                })
        })
        dynamo
            .putItem(put!)
            .continueWith {
            (task:AWSTask<AWSDynamoDBPutItemOutput>) -> Any? in
                if let error = task.error {
                    print("The request failed. Error: \(error)")
                    return nil
                }
                print("The put request successsge5gwe5ge5w5we5h")
                // Do something with task.result
                
                return nil
            }
    }
    
    func getStuff() {
        let key = AWSDynamoDBAttributeValue()
        key?.s = "12345"
        
        let get = AWSDynamoDBGetItemInput()
        get?.tableName = SCENARIO_MASTER_TABLE
        get?.key = [
            SCENARIO_MASTER_TABLE_PRIMARY_KEY: key!
        ]
        
        dynamo.getItem(get!).continueWith { (task:AWSTask<AWSDynamoDBGetItemOutput>) -> Any? in
            if let error = task.error {
                print("The request failed. Error: \(error)")
                return nil
            }
            print("The get request successsge5gwe5ge5w5we5h")
            // Do something with task.result
            print(task)
            
            return nil
        }
    }
    
}
