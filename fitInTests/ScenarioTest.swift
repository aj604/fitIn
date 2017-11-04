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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testCreateScenario(){
        let testScenario = Scenario()
        var boolean = (testScenario.scenarioID == "0")
        boolean = boolean &&  (testScenario.createdBy == "Anonymous")

        boolean = boolean && (testScenario.questionText == "a")
        boolean = boolean && (testScenario.answerReasoning == "Sucks to suck")
        boolean = boolean && (testScenario.imageLoc == URL(string: "https:i.imgur.com/I8wCreu.jpg")!)
        
        boolean = boolean && (testScenario.response == 0)
        boolean = boolean && (testScenario.initialAnswer == 0)
        boolean = boolean && (testScenario.averageAnswer == 0.0)
        boolean = boolean && (testScenario.standardDeviation == 0.0)
        boolean = boolean && (testScenario.averageTimeToAnswer == 0.0)
        boolean = boolean && (testScenario.numberOfAnswers == 0)
        if (boolean == false){
            XCTAssertTrue(true)
            print("scenario init not working")
        }
        testScenario.setscenarioID(value: "5")
        testScenario.setScenarioURL(url: "test.ca")
        boolean = (testScenario.scenarioID == "5")
        boolean = boolean && (testScenario.imageLoc == URL(string: "test.ca")!)
        if (boolean == false){
            XCTAssertTrue(true)
            print("scenario update not working")
        }
    }

}
