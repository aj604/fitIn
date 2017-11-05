//
//  ScenarioTest.swift
//  fitInTests
//
//  Created by Kevin C on 2017-11-03.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import XCTest
@testable import fitIn

class ScenarioTest: XCTestCase {
    //create a scenario we will fudge with
    let testScenario = Scenario()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    

    func testCreateScenario(){
        //make sure scenario fields are all right types
        let stringType = type(of:"blah")
        let urlType = type(of: URL(string: "blah.com")!)
        let tempInt:Int = 3
        let tempDouble: Double = 3.3
        let intType = type(of:tempInt)
        let doubleType = type(of: tempDouble)
        
        
        var boolean = (type(of: testScenario.scenarioID) == stringType)
        boolean = boolean &&  (type(of: testScenario.createdBy) == stringType)
        boolean = boolean && (type(of: testScenario.questionText) == stringType)
        boolean = boolean && (type(of: testScenario.answerReasoning) == stringType)
        boolean = boolean && (type(of: testScenario.imageLoc) == urlType)
        boolean = boolean && (type(of:testScenario.response) == intType)
        boolean = boolean && (type(of:testScenario.initialAnswer) == intType)
        boolean = boolean && (type(of:testScenario.averageAnswer) == doubleType)
        boolean = boolean && (type(of:testScenario.standardDeviation) == doubleType)
        boolean = boolean && (type(of:testScenario.averageTimeToAnswer) == doubleType)
        boolean = boolean && (type(of:testScenario.numberOfAnswers) == intType)
        //this test should pass as it is checking for all the types
        XCTAssertTrue(boolean == true)
    }
    
    func testUploadToDB(){
        let returnedDictionary = testScenario.toDBDictionary();
        let attribType = type(of: returnedDictionary[SCENARIO_MASTER_TABLE_PRIMARY_KEY])
        
        var boolean = (type(of: returnedDictionary[SCENARIO_MASTER_TABLE_PRIMARY_KEY]) == attribType)
        boolean = boolean &&  (type(of: returnedDictionary["createdBy"]) == attribType)
        boolean = boolean && (type(of: returnedDictionary["questionText"]) == attribType)
        boolean = boolean && (type(of: returnedDictionary["answerReasoning"]) == attribType)
        boolean = boolean && (type(of: returnedDictionary["imageLoc"]) == attribType)
        boolean = boolean && (type(of:returnedDictionary["type"]) == attribType)
        boolean = boolean && (type(of:returnedDictionary["initialAnswer"]) == attribType)
        boolean = boolean && (type(of:returnedDictionary["numberOfAnswers"]) == attribType)
        //this test should pass as it is checking for all the types
        XCTAssertTrue(boolean == true)
    }
    func testRetrieveFromDB(){
        //make sure scenario fields are all right types
        let returned1Dictionary = testScenario.toDBDictionary()
        testScenario.fromDBDictionary(returned1Dictionary)
        
        let stringType = type(of:"blah")
        let urlType = type(of: URL(string: "blah.com")!)
        let tempInt:Int = 3
        //let tempDouble: Double = 3.3
        let intType = type(of:tempInt)
        //let doubleType = type(of: tempDouble)
        
        var boolean = (type(of: testScenario.scenarioID) == stringType)
        boolean = boolean &&  (type(of: testScenario.createdBy) == stringType)
        boolean = boolean && (type(of: testScenario.questionText) == stringType)
        boolean = boolean && (type(of: testScenario.answerReasoning) == stringType)
        boolean = boolean && (type(of: testScenario.imageLoc) == urlType)
        boolean = boolean && (type(of:testScenario.response) == intType)
        boolean = boolean && (type(of:testScenario.initialAnswer) == intType)
        //boolean = boolean && (type(of:testScenario.averageAnswer) == doubleType)
        //boolean = boolean && (type(of:testScenario.standardDeviation) == doubleType)
        //boolean = boolean && (type(of:testScenario.averageTimeToAnswer) == doubleType)
        boolean = boolean && (type(of:testScenario.numberOfAnswers) == intType)
        //this test should pass as it is checking for all the types
        XCTAssertTrue(boolean == true)
    }


}
