//
//  DynamoHandler.swift
//  fitIn
//
//  Created by schecko on 10/30/17.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import Foundation
import AWSDynamoDB

class DynamoHandler {
    var paginatedOutput: AWSDynamoDBPaginatedOutput?
    var dynamo: AWSDynamoDBObjectMapper
    
    init() {
        do {
            dynamo = AWSDynamoDBObjectMapper.default();
        } catch {
            print("Fuck")
        
        }
    }
    
    func putItem(scenario : Scenario)  {
        dynamo.save(scenario)
    }
    
}
