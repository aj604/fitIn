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
    
    @objc var ScenarioID: String?
    @objc var Answer: String?
    
    override init() {
        super.init();
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    //required to let DynamoDB Mapper create instances of this class
    override init(@objc dictionary disctionaryValue: [AnyHashable : Any]!, error: ()) throws {
        // self.ScenarioID = dictionaryValue[SCENARIO_MASTER_TABLE_PRIMARY_KEY]
        super.init()
        //self.ScenarioID = (dictionaryValue[SCENARIO_MASTER_TABLE_PRIMARY_KEY] as? String)!
        print("dictionergarg", dictionaryValue)
        //self.Answer = (dictionaryValue["Answer"] as? Int)!
    }
    
    // this breaks things
    /*override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return ["ScenarioID" : "hashKey1"];
    }*/
    
    /*init(dictionary: Dictionary<String, Any>, error: NSErrorPointer) {
        self.ScenarioID = (dictionary[SCENARIO_MASTER_TABLE_PRIMARY_KEY] as? String)!
        super.init()
    }*/
    
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
            .save(scenario)
            // .save(scenario)
            .continueWith(block:
                { (task:AWSTask<AnyObject>!) -> Any? in
                                        if let error = task.error {
                                            print("putting The request failed. Error: \(error)")
                                        } else {
                                            print("putting success ", (task.result as! ScenarioA).ScenarioID)
                                            // Do something with task.result or perform other operations.
                                            
                                        }
                                        return task.result
            })
    }
    
    func getItem(scenario : String)  {
        print("getting")
        dynamo
            .load(ScenarioA.self, hashKey: scenario, rangeKey: nil)
            .continueWith(block:
                { (task:AWSTask<AnyObject>!) -> Any? in
                     print("success111111")
                    if let error = task.error {
                        print("getting The request failed. Error: \(error)")
                    } else {
                        print("task is ", task)
                        // print("getting success ", (task.result as! ScenarioA).ScenarioID as Any)
                        // print("getting success ", (task.result as! ScenarioA).Answer as Any)
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
    
    func setStuff() {
        let dyn = AWSDynamoDB.default();
    
        
        let put = AWSDynamoDBPutItemInput()
        
        let hashKeyValue = AWSDynamoDBAttributeValue()
        hashKeyValue?.s = "12345"
        
        let attrib = AWSDynamoDBAttributeValue()
        attrib?.s = "73567367"
        
        put?.tableName = SCENARIO_MASTER_TABLE
        put?.item = [
            SCENARIO_MASTER_TABLE_PRIMARY_KEY: hashKeyValue!,
            "Answer": attrib!,
        ];
        
        dyn.putItem(put!).continueWith { (task:AWSTask<AWSDynamoDBPutItemOutput>) -> Any? in
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
        let dyn = AWSDynamoDB.default();
        
        
        let key = AWSDynamoDBAttributeValue()
        key?.s = "12345"
        
        let get = AWSDynamoDBGetItemInput()
        get?.tableName = SCENARIO_MASTER_TABLE
        get?.key = [
            SCENARIO_MASTER_TABLE_PRIMARY_KEY: key!
        ]
        
        dyn.getItem(get!).continueWith { (task:AWSTask<AWSDynamoDBGetItemOutput>) -> Any? in
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
