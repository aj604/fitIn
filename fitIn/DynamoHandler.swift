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
    
    func setObj<T: Any>(tableName: String, obj: T) {
        let put = AWSDynamoDBPutItemInput()
        
        put!.tableName = tableName
        put!.item = [:]
        
        let mirror = Mirror(reflecting: obj)
        print(mirror)
        for case let (label, value) in mirror.children {
            print("member ", label!)
            let attrib = AWSDynamoDBAttributeValue()
            
            let t = "\(type(of: value))"
            
            // this is kind of evil....
            var validType = true;
            switch t {
                case "String":
                    attrib!.s = value as! String
                /*case "Int":
                    attrib!.n = String(value)*/
                
                // todo more if we need them
                
                // todo figure out how we want to deal with optionals :(
                default:
                    print("unsupported type in object", t)
                    validType = false;
                }
            if(validType) {
                print("valid")
                    put!.item!.merge([label!: attrib!], uniquingKeysWith:
                    {
                        (a: AWSDynamoDBAttributeValue, b: AWSDynamoDBAttributeValue) in
                        return a;
                })
            }
        }

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
    
    func setScenario(obj: T) {
        let put = AWSDynamoDBPutItemInput()
        
        put!.tableName = tableName
        put!.item = [:]
        
        let mirror = Mirror(reflecting: obj)
        print(mirror)
        for case let (label, value) in mirror.children {
            print("member ", label!)
            let attrib = AWSDynamoDBAttributeValue()
            
            let t = "\(type(of: value))"
            
            // this is kind of evil....
            var validType = true;
            switch t {
            case "String":
                attrib!.s = value as! String
                /*case "Int":
                 attrib!.n = String(value)*/
                
                // todo more if we need them
                
            // todo figure out how we want to deal with optionals :(
            default:
                print("unsupported type in object", t)
                validType = false;
            }
            if(validType) {
                print("valid")
                put!.item!.merge([label!: attrib!], uniquingKeysWith:
                    {
                        (a: AWSDynamoDBAttributeValue, b: AWSDynamoDBAttributeValue) in
                        return a;
                })
            }
        }
        
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
    
    
    // todo use this?
    /*func getObj<T: Databaseable>(tableName: String, obj: T) -> AWSTask<T> {
        let key = AWSDynamoDBAttributeValue()
        key?.s = "12345"
        
        let get = AWSDynamoDBGetItemInput()
        get?.tableName = SCENARIO_MASTER_TABLE
        get?.key = [
            SCENARIO_MASTER_TABLE_PRIMARY_KEY: key!
        ]
        
        var result = T();
        
        return dynamo.getItem(get!).continueWith { (task:AWSTask<AWSDynamoDBGetItemOutput>) -> Any? in
            if let error = task.error {
                print("The request failed. Error: \(error)")
                return nil
            }
            print("The get request successsge5gwe5ge5w5we5h")
            // Do something with task.result
            print("item ", task.result?.item)
            print("scenariosrth", obj as! T)
            
            // ***************************************************
            // TODO figure out how to dynamically assign task to a
            // class
            // ***************************************************
            
            /*let mirror = Mirror(reflecting: obj)
            print(mirror)
            for case let (label, value) in mirror.children {
                print("member ", label!)
                
                // let objectType = "\(type(of: value))"
                // let dataBaseType = "\(type(of: task.item[label]))"

                (obj as! T).setValue(value, forKey: label!)
            }*/
            
            for item in task.result!.item! {
            
                let objectType = "\(type(of: result[item.key]))"
                switch objectType {
                case "String":
                    result[item.key] = item.value.s
                case "Int":
                    result[item.key] = item.value.n
                default:
                    print("unsupported type: ", objectType)
                    result[item.key] = item.value
                }
            }
            
            print(result)
            
            return result
        } as! AWSTask<T>
    }*/
    
    func getScenario(id: String) -> AWSTask<Scenario> {
        let key = AWSDynamoDBAttributeValue()
        key?.s = id
        
        let get = AWSDynamoDBGetItemInput()
        get?.tableName = SCENARIO_MASTER_TABLE
        get?.key = [
            SCENARIO_MASTER_TABLE_PRIMARY_KEY: key!
        ]
        
        return dynamo.getItem(get!)
            .continueWith { (task:AWSTask<AWSDynamoDBGetItemOutput>) -> AWSTask<Scenario> in
                if let error = task.error {
                    print("The request failed. Error: \(error)")
                    return AWSTask(result: nil)
                }
                
                let result = Scenario();
                let item = task.result!.item!
                
                // **************************************************
                // ADD MORE ASSIGNMENT HERE
                
                result.scenarioID = item[SCENARIO_MASTER_TABLE_PRIMARY_KEY]!.s!
                
                // **************************************************
                
                return AWSTask(result: result)
            
            } as! AWSTask<Scenario>
    }
    
    /*func getUser(id: String) -> AWSTask<UserProfile> {
        let key = AWSDynamoDBAttributeValue()
        key!.s = id
        
        let get = AWSDynamoDBGetItemInput()
        get!.tableName = USER_PROFILES_TABLE
        get!.key = [
            USER_PROFILES_TABLE_PRIMARY_KEY: key!
        ]
        
        return dynamo.getItem(get!)
            .continueWith { (task:AWSTask<AWSDynamoDBGetItemOutput>) -> AWSTask<UserProfile> in
                if let error = task.error {
                    print("The request failed. Error: \(error)")
                    return AWSTask(result: nil)
                }
                
                let result = UserProfile();
                
                print("user task done,", task)
                
                let item = task.result!.item
                
                // **************************************************
                // ADD MORE ASSIGNMENT HERE
                
                result.emailAddress = item?[USER_PROFILES_TABLE_PRIMARY_KEY]!.s!
                
                // **************************************************

                return AWSTask(result: result)
                
            } as! AWSTask<UserProfile>
    }*/

    
}
