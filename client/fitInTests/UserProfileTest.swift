//
//  UserProfileTest.swift
//  fitInTests
//
//  Created by Vlad Polin on 11/3/17.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import XCTest
@testable import fitIn

class UserProfileTest: XCTestCase {
    
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
    
    func testUserProfileEmailAddressSetFail() {
        //this test should fail as email address parameter is not valid
        let boolean = UserProfile.current()?.updateEmailAddress("notAnEmailAddress")
        XCTAssertTrue(boolean == false)
    }
    
    func testUserProfileEmailAddressSetPass() {
        //this test should fail as email address parameter is not valid
        let boolean = UserProfile.current()?.updateEmailAddress("isAnEmailAddress@email.com")
        XCTAssertTrue(boolean == true)
    }
    
    func testUserProfileAgeSetFailTooOld() {
        //this test should fail as age parameter is not valid
        let boolean = UserProfile.current()?.updateUserAge(250)
        XCTAssertTrue(boolean == false)
    }
    
    func testUserProfileAgeSetFailTooYoung() {
        //this test should fail as age parameter is not valid
        let boolean = UserProfile.current()?.updateUserAge(-1)
        XCTAssertTrue(boolean == false)
    }
    
    func testUserProfileAgeSetPass() {
        //this test should fail as age parameter is not valid
        let boolean = UserProfile.current()?.updateUserAge(25)
        XCTAssertTrue(boolean == true)
    }
    
    func testUserProfileUsernameSetFail() {
        //this test should fail as username paramter is not valid
        let boolean = UserProfile.current()?.updateUsername("FAIL")
        XCTAssertTrue(boolean == false)
    }
    
    func testUserProfileUsernameSetFailWithCharacter() {
        //this test should fail as username paramter is not valid
        let boolean = UserProfile.current()?.updateUsername("F@IL")
        XCTAssertTrue(boolean == false)
    }
    
    func testUserProfileUsernameSetFailWithProfanity() {
        //this test should fail as username paramter is not valid
        let boolean = UserProfile.current()?.updateUsername("shit")
        XCTAssertTrue(boolean == false)
    }
    
    func testUserProfileUsernameSetPass() {
        //this test should fail as username paramter is not valid
        let boolean = UserProfile.current()?.updateUsername("UsernamePass")
        XCTAssertTrue(boolean == true)
    }
    
    func testUserProfileGotCorrectAnswer() {
        let oldNumScenariosCorrect = UserProfile.current()?.numScenariosCorrect
        let oldNumScenariosAnswered = UserProfile.current()?.numScenariosAnswered
        UserProfile.current()?.gotCorrect()
        XCTAssertTrue((oldNumScenariosCorrect! + 1) == UserProfile.current()?.numScenariosCorrect)
        XCTAssertTrue((oldNumScenariosAnswered! + 1) == UserProfile.current()?.numScenariosAnswered)
    }
    
    func testUserProfileGotIncorrectAnswer() {
        let oldNumScenariosCorrect = UserProfile.current()?.numScenariosCorrect
        let oldNumScenariosAnswered = UserProfile.current()?.numScenariosAnswered
        UserProfile.current()?.gotIncorrect()
        XCTAssertTrue(oldNumScenariosCorrect! == UserProfile.current()?.numScenariosCorrect)
        XCTAssertTrue((oldNumScenariosAnswered! + 1) == UserProfile.current()?.numScenariosAnswered)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
