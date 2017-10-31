//
//  AppDelegate.swift
//  fitIn
//
//  Created by schecko on 10/30/17.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import Foundation

import AWSCognito
import AWSS3
import AWSDynamoDB

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool  {
    print("ergergerge")
    let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2,
                                                            identityPoolId: AWS_IDENTITY_POOL)
    
    let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider: credentialsProvider)
    
    AWSServiceManager.default().defaultServiceConfiguration = configuration
    
    let objectMapperConfiguration = AWSDynamoDBObjectMapperConfiguration()
    
    AWSDynamoDBObjectMapper.register(with: configuration!, objectMapperConfiguration: objectMapperConfiguration, forKey: "USWest2DynamoDBObjectMapper")
    
    return true
}

