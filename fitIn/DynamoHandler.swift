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
    
    func putScenario(_ scenario: Scenario) -> AWSTask<Scenario>{
        let put = AWSDynamoDBPutItemInput()
        
        put!.tableName = SCENARIO_MASTER_TABLE
        put!.item = [
            SCENARIO_MASTER_TABLE_PRIMARY_KEY: makeAttrib(scenario.scenarioID)
        ]
        
        return dynamo
            .putItem(put!)
            .continueWith {
                (task:AWSTask<AWSDynamoDBPutItemOutput>) -> AWSTask<Scenario>? in
                if let error = task.error {
                    print("failed put request to user. Error: \(error)")
                    return nil
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
        put!.item = [
            USER_PROFILES_TABLE_PRIMARY_KEY: makeAttrib(userProfile.emailAddress)
        ]
        
        return dynamo
            .putItem(put!)
            .continueWith {
                (task:AWSTask<AWSDynamoDBPutItemOutput>) -> AWSTask<UserProfile>? in
                if let error = task.error {
                    print("failed put request to user profile. Error: \(error)")
                    return nil
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
        get!.consistentRead = true
        
        return dynamo
            .getItem(get!)
            .continueWith { (task:AWSTask<AWSDynamoDBGetItemOutput>) -> AWSTask<Scenario> in
                if let error = task.error {
                    print("failed get request to scenario. Error: \(error)")
                    return AWSTask(result: nil)
                }
                
                print("successful get request to scenario", task)
                
                let result = Scenario();
                let item = task.result!.item!
                
                // **************************************************
                // ADD MORE ASSIGNMENT HERE
                
                result.scenarioID = item[SCENARIO_MASTER_TABLE_PRIMARY_KEY]!.s!
                
                // **************************************************
                
                return AWSTask(result: result)
            
            } as! AWSTask<Scenario>
    }
    
    func getUserProfile(_ id: String) -> AWSTask<UserProfile> {
        
        let get = AWSDynamoDBGetItemInput()
        
        get!.tableName = USER_PROFILES_TABLE
        get!.key = [
            USER_PROFILES_TABLE_PRIMARY_KEY: makeAttrib(id)
        ]
        
        get!.consistentRead = true
        get!.
        
        return dynamo
            .getItem(get!)
            .continueWith { (task:AWSTask<AWSDynamoDBGetItemOutput>) -> AWSTask<UserProfile> in
                if let error = task.error {
                    print("failed get request to user profile. Error: \(error)")
                    return AWSTask(result: nil)
                }
                
                let result = UserProfile();
                
                print("successful get to user profile,", task)
                
                let item = task.result!.item
                
                // **************************************************
                // ADD MORE ASSIGNMENT HERE
                
                result.emailAddress = (item?[USER_PROFILES_TABLE_PRIMARY_KEY]?.s)!
                
                // **************************************************

                return AWSTask(result: result)
                
            } as! AWSTask<UserProfile>
    }

    
}
