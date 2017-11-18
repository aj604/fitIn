//
//  DynamoHandler.swift
//  fitIn
//
//  Created by schecko on 10/30/17.
//  Copyright © 2017 group of 5. All rights reserved.
//  contributors: Scott Checko
//  Known bugs:
//              - PUT requests return the default constructor objects of Scenario and UserProfile
//                instead of the put response.

import Foundation
import AWSDynamoDB

// This is the global DynamoHandler object, which is intended to be a singleton
let dynamoHandler = DynamoHandler();

// Some special error types returned by functions in DynamoHandler
enum ErrorTypes : Int {
    case RequestFailed
    case Empty
    case Exists
}

// Helper function to make and return an AWSDynamoDBAttributeValue (int overload)
// without this, the code ends up looking quite discontinuous and hard to read
func makeAttrib(_ value: Int) -> AWSDynamoDBAttributeValue {
    let attrib = AWSDynamoDBAttributeValue();
    attrib!.n = String(value)
    return attrib!
}

// Helper function to make and return an AWSDynamoDBAttributeValue (string overload)
// without this, the code ends up looking quite discontinuous and hard to read
func makeAttrib(_ value: String) -> AWSDynamoDBAttributeValue {
    let attrib = AWSDynamoDBAttributeValue();
    attrib!.s = value
    return attrib!
}

// This object wraps direct AWSDynamoDB function calls,
// and specializes them for our use case for ease of use.
class DynamoHandler {
    var paginatedOutput: AWSDynamoDBPaginatedOutput?
    var dynamo: AWSDynamoDB
    
    // Default and only constructor, sets up some global (hidden by AWS) AWS resources
    // and initializes the dynamo member variable.
    init() {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2,
                                                                identityPoolId: AWS_IDENTITY_POOL)
        
        let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        dynamo = AWSDynamoDB.default();
    }
    
    // Asyncronously PUTs to AWS DynamoDB, after converting the scenario to a dictionary
    // This function returns an AWSTask, which contains the result of the PUT once the 
    // PUT completes.
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
    
    // Asyncronously PUTs to AWS DynamoDB, after converting the UserProfile to a dictionary
    // This function returns an AWSTask, which contains the result of the PUT once the 
    // PUT completes.
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
    
    // Asyncronously GETs to AWS DynamoDB, requesting a Scenario uniquely identified by a scenarioID
    // This function returns an AWSTask, which contains the result of the GET once the 
    // GET completes.
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

    // Asyncronously GETs to AWS DynamoDB, requesting a UserProfile uniquely identified by a emailAddress
    // This function returns an AWSTask, which contains the result of the GET once the 
    // GET completes.
    
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
                            // print("successful get request to scenario")
                            
                            let result = Scenario();
                            let items = task.result!.items!
                            
                            if(Int(truncating: task.result!.count!) > 0)
                            {
                                result.fromDBDictionary(items[0])
                                result.getImageData()
                                result.seen = false;
                            } else {
                                result.seen = true;
                            }
                            return AWSTask(result: result)
                        } as! AWSTask<Scenario>;
                }
                
                // print("successful get request to scenario")
                
                let result = Scenario();
                let items = task.result!.items!
                result.fromDBDictionary(items[0])
                result.getImageData()
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
