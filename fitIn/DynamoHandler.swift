//
//  DynamoHandler.swift
//  fitIn
//
//  Created by schecko on 10/30/17.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import Foundation
import AWSDynamoDB

let dynamoHandler = DynamoHandler();

enum ErrorTypes : Int {
    case RequestFailed
    case Empty
    case Exists
}

func makeAttrib(_ value: Int) -> AWSDynamoDBAttributeValue {
    let attrib = AWSDynamoDBAttributeValue();
    attrib!.n = String(value)
    return attrib!
}

func makeAttrib(_ value: String) -> AWSDynamoDBAttributeValue {
    let attrib = AWSDynamoDBAttributeValue();
    attrib!.s = value
    return attrib!
}

class DynamoHandler {
    var paginatedOutput: AWSDynamoDBPaginatedOutput?
    var dynamo: AWSDynamoDB
    
    init() {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2,
                                                                identityPoolId: AWS_IDENTITY_POOL)
        
        let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        dynamo = AWSDynamoDB.default();
    }
    
    func putScenario(_ scenario: Scenario) -> AWSTask<Scenario>{
        let put = AWSDynamoDBPutItemInput()
        
        put!.tableName = SCENARIO_MASTER_TABLE
        put!.item = scenario.toDBDictionary()
        
        return dynamo
            .putItem(put!)
            .continueWith {
                (task:AWSTask<AWSDynamoDBPutItemOutput>) -> AWSTask<Scenario> in
                if let error = task.error {
                    print("failed put request to user. Error: \(error)")
                    return AWSTask(error: NSError(domain: "", code: ErrorTypes.RequestFailed.rawValue))
                }
                print("successful put request to scenario")
                // Do something with task.result
                
                // todo actual return value
                return AWSTask(result: Scenario())
        } as! AWSTask<Scenario>
    }
    
    
    func putUserProfile(_ userProfile: UserProfile) -> AWSTask<UserProfile>{
        let put = AWSDynamoDBPutItemInput()
        
        put!.tableName = USER_PROFILES_TABLE
        put!.item = userProfile.toDBDictionary()
        
        return dynamo
            .putItem(put!)
            .continueWith {
                (task:AWSTask<AWSDynamoDBPutItemOutput>) -> AWSTask<UserProfile> in
                if let error = task.error {
                    print("failed put request to user profile. Error: \(error)")
                    return AWSTask(error: NSError(domain: "", code: ErrorTypes.RequestFailed.rawValue))
                }
                print("successful put request to user")
                // Do something with task.result
                
                // todo return return of put
                return AWSTask(result: UserProfile())
        } as! AWSTask<UserProfile>
    }
    
    func getScenario(_ id: String) -> AWSTask<Scenario> {
        
        let get = AWSDynamoDBGetItemInput()
        get?.tableName = SCENARIO_MASTER_TABLE
        get?.key = [
            SCENARIO_MASTER_TABLE_PRIMARY_KEY: makeAttrib(id)
        ]
        
        return dynamo
            .getItem(get!)
            .continueWith { (task:AWSTask<AWSDynamoDBGetItemOutput>) -> AWSTask<Scenario> in
                if let error = task.error {
                    print("failed get request to scenario. Error: \(error)")
                    return AWSTask(error: NSError(domain: "", code: ErrorTypes.RequestFailed.rawValue))
                }
                
                if(task.result!.item == nil) {
                    // no object found.
                    return AWSTask(error: NSError(domain: "", code: ErrorTypes.Empty.rawValue))
                }
                
                print("successful get request to scenario", task)
                
                let result = Scenario();
                let item = task.result!.item!
                
                result.fromDBDictionary(item)
                
                return AWSTask(result: result)
            
            } as! AWSTask<Scenario>
    }
    
    func getRandomScenario() -> AWSTask<Scenario> {
        
        let query = AWSDynamoDBQueryInput()
        query!.tableName = SCENARIO_MASTER_TABLE
        query!.limit = 1
        query!.indexName = "initialAnswer-scenarioID-index"
        query!.keyConditionExpression = "#index = :indexValue AND #primaryKey >= :primaryKeyValue"
        query!.expressionAttributeNames = [
            "#index": "initialAnswer",
            "#primaryKey": "scenarioID"
        ]
        query!.expressionAttributeValues = [
            ":indexValue": makeAttrib(Int(arc4random() % 10)),
            ":primaryKeyValue": makeAttrib(String(arc4random()))
        ]
        
        return dynamo
            .query(query!)
            .continueWith { (task:AWSTask<AWSDynamoDBQueryOutput>) -> AWSTask<Scenario> in
                if let error = task.error {
                    print("failed get request to scenario. Error: \(error)")
                    return AWSTask(error: NSError(domain: "", code: ErrorTypes.RequestFailed.rawValue))
                }
                
                if(task.result!.items == nil || Int(truncating: task.result!.count!) <= 0) {
                    // no object found.
                    
                    query!.keyConditionExpression = "#index = :indexValue AND #primaryKey < :primaryKeyValue"
                    
                    return self
                        .dynamo
                        .query(query!)
                        .continueWith { (task:AWSTask<AWSDynamoDBQueryOutput>) -> AWSTask<Scenario> in
                            print("successful get request to scenario", task)
                            
                            let result = Scenario();
                            let items = task.result!.items!
                            
                            if(Int(truncating: task.result!.count!) > 0)
                            {
                                result.fromDBDictionary(items[0])
                            }
                            
                            return AWSTask(result: result)
                        } as! AWSTask<Scenario>;
                }
                
                print("successful get request to scenario", task)
                
                let result = Scenario();
                let items = task.result!.items!
                result.fromDBDictionary(items[0])
                return AWSTask(result: result)
        } as! AWSTask<Scenario>
    }
    
    func getUserProfile(_ id: String) -> AWSTask<UserProfile> {
        
        let get = AWSDynamoDBGetItemInput()
        
        get!.tableName = USER_PROFILES_TABLE
        get!.key = [
            USER_PROFILES_TABLE_PRIMARY_KEY: makeAttrib(id)
        ]
        
        return dynamo
            .getItem(get!)
            .continueWith { (task:AWSTask<AWSDynamoDBGetItemOutput>) -> AWSTask<AnyObject> in
                
                print("get task is ", task)
                
                if let error = task.error {
                    print("failed get request to user profile. Error: \(error)")
                    let task = AWSTask(error: NSError(domain: "", code: ErrorTypes.RequestFailed.rawValue)) as AWSTask<AnyObject>
                    return task
                }
                
                if(task.result!.item == nil) {
                    // no object found.
                    let task = AWSTask(error: NSError(domain: "", code: ErrorTypes.Empty.rawValue)) as AWSTask<AnyObject>
                    return task
                }
                
                let result = UserProfile();
                
                print("successful get to user profile,", task)
                
                let item = task.result!.item!
                
                result.fromDBDictionary(item)

                return AWSTask(result: result)
                
            } as! AWSTask<UserProfile>
    }

    
}
