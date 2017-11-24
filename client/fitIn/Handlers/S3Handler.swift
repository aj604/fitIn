//
//  S3Handler.swift
//  fitIn
//
//  Created by schecko on 11/23/17.
//  Copyright © 2017 group of 5. All rights reserved.
//

import Foundation
import AWSS3

let AMAZON_BASE: String = "https://s3-us-west-2.amazonaws.com/"
let s3Handler = S3Handler();

struct StupidStringObject {
    var valid: Bool;
    let string: String;
}

class S3Handler {
    var s3: AWSS3
    
    init() {
        hackyStartUp();
        
        s3 = AWSS3.default();
    }
    
    func uploadImage(scenario: Scenario) -> AWSTask<StupidStringObject> {
        let request: AWSS3PutObjectRequest = AWSS3PutObjectRequest();
        request.body = scenario.imageData;
        request.bucket = FITIN_IMAGES_BUCKET;
        request.key = scenario.scenarioID;
        request.contentLength = NSNumber(value: scenario.imageData.count)
        
        return s3.putObject(request)
            .continueWith {
                (task: AWSTask<AWSS3PutObjectOutput>) in
                if let error = task.error {
                    print("failed put request to bucket. Error: \(error)")
                    //return AWSTask(error: NSError(domain: "", code: ErrorTypes.RequestFailed.rawValue)) as! AWSTask<StupidStringObject>;
                    return nil
                }
                
                var obj = StupidStringObject(valid: false, string: AMAZON_BASE + FITIN_IMAGES_BUCKET + "/" + scenario.scenarioID);
                if let _ = task.result {
                    obj.valid = true;
                }
                
                return AWSTask(result: obj as AnyObject)

            } as! AWSTask<StupidStringObject>;
    }
}
