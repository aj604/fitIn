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
import AWSCore

func testing()  {
    print("aergerg4rg")
    let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2,
                                                            identityPoolId: AWS_IDENTITY_POOL)

    let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider: credentialsProvider)
    
    AWSServiceManager.default().defaultServiceConfiguration = configuration
    
    let objectMapperConfiguration = AWSDynamoDBObjectMapperConfiguration()
    objectMapperConfiguration.saveBehavior = .clobber
    AWSDynamoDBObjectMapper.register(with: configuration!, objectMapperConfiguration: objectMapperConfiguration, forKey: "USWest2DynamoDBObjectMapper")

}
