//
//  File.swift
//  fitIn
//
//  Created by schecko on 10/25/17.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import Foundation

import AWSCognito
import AWSS3
import AWSDynamoDB


func testing() {
    let pool = Bundle.main.path(forResource: "AWS_IDENTITY_POOL", ofType:"plist")

    let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USWest2, identityPoolId: pool!)
    let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialProvider)
    AWSServiceManager.default().defaultServiceConfiguration = configuration
}

