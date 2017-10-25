//
//  userData.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-07.
//  Copyright © 2017 group of 5. All rights reserved.
//

import Foundation

struct userProfile {
    //MARK: VARIABLES
    private var correct : Int {
        didSet {
            print("User got an answer correct! \n user now has \(correct) correct answers")
        }
    }
    private var incorrect : Int{
        didSet {
            print("User got an answer wrong :( \n user now has \(incorrect) correct answers")
        }
    }
    
    
    //MARK: METHODS
    init(userID: String){
        correct = 0
        incorrect = 0
    }
    
    mutating func gotCorrect(){
        correct += 1
    }
    mutating func gotIncorrect(){
        incorrect += 1
    }
}
