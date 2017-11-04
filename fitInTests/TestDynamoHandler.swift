//
//  TestDynamoHandler.swift
//  fitInTests
//
//  Created by schecko on 11/3/17.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import XCTest
import AWSDynamoDB

@testable import fitIn

var initDBFirstTime = false

class TestDynamoHandler: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        if(initDBFirstTime) {
            
            var task: AWSTask = AWSTask(result: nil) as AWSTask<AnyObject>
            
            for index in 1...Scenario.MAX_ANSWER_VALUE {
                
                let scenario = Scenario(scenarioID: String(arc4random()), type: .multipleChoice)
                scenario.initialAnswer = index
                
                task = task.continueWith(block:
                    { (task) -> AWSTask<AnyObject> in
                        return dynamoHandler.putScenario(scenario) as! AWSTask<AnyObject>
                    })
            }
            
            task.waitUntilFinished();
            initDBFirstTime = false;
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetPutScenario() {
        let id = String(arc4random())
        
        let exampleScenario = Scenario(scenarioID: id, type: Scenario.ScenarioType.yesOrNo)
        
        dynamoHandler
            .putScenario(exampleScenario)
            .continueWith(block:
                { (task) -> AWSTask<Scenario> in
                    return dynamoHandler.getScenario(id)
                })
            .continueWith(block:
                { (task) -> Void in
                    XCTAssertTrue(id == (task.result! as! Scenario).scenarioID)
                })
            .waitUntilFinished();
    }
    
    func testGetPutUserProfile() {
        let id = String(arc4random())
        
        let exampleUserProfile = UserProfile()
        exampleUserProfile.emailAddress = id
        
        dynamoHandler
            .putUserProfile(exampleUserProfile)
            .continueWith(block:
                { (task) -> AWSTask<UserProfile> in
                    return dynamoHandler.getUserProfile(id)
            })
            .continueWith(block:
                { (task) -> Void in
                    XCTAssertTrue(id == (task.result! as! UserProfile).emailAddress)
            })
            .waitUntilFinished();
    }
    
    func testGetRandomScenario() {
        dynamoHandler
            .getRandomScenario()
            .continueWith(block:
            { (task) -> Void in
                    XCTAssertTrue(task.result != nil)
            })
            .waitUntilFinished();
    }
    
    
}
