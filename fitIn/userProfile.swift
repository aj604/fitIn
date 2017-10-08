//
//  userData.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-07.
//  Copyright © 2017 group of 5. All rights reserved.
//

import Foundation

struct userProfile {
    private var correct : Int = 0
    private var incorrect : Int = 0
    mutating func gotCorrect(){
        correct += 1
    }
    mutating func gotIncorrect(){
        incorrect += 1
    }
}
