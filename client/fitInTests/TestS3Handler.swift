//
//  TestS3Handler.swift
//  fitInTests
//
//  Created by schecko on 11/23/17.
//  Copyright © 2017 group of 5. All rights reserved.
//

import XCTest
import AWSS3

@testable import fitIn

class TestS3Handler: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUploadImage() {
        var data = Data(capacity: 1);
        data[0] = 0xA1;
        let scenario = Scenario();
        scenario.scenarioID = "test";
        scenario.imageData = data;
        
        s3Handler
            .uploadImage(scenario: scenario)
            .continueWith(block:
                {
                    (task: AWSTask<StupidStringObject>) -> AWSTask<Void> in
                    
                    XCTAssertTrue(task.result?.valid);
                    XCTAssertTrue(task.result?.string == AMAZON_BASE + FITIN_IMAGES_BUCKET + "/" + scenario.scenarioID )
                    
                    scenario.imageLoc = URL(string: task.result?.string);
                    scenario.getImageData();
                    XCTAssertTrue(scenario.imageData == data);
                    
                }
            )
    }
    
}
