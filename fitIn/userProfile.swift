//
//  userData.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-07.
//  Copyright © 2017 group of 5. All rights reserved.
//

import Foundation

class userProfileClass {
    //Variables:
    var userName: String
    var emailAddress: String
    var userAge: Int
    var userLifetime: Int //the time for which the user has spent on our application, it is measured in seconds
    var numScenariosAnswered: Int
    var numScenariosCorrect: Int
    var averageResponseTime: Int //the average response time of a user, it is measured in milliseconds
    var favorites = [Int64]() //the array of long ints, each of which represent the id for a scenario
    
    //Methods:
    init() {
        userName = "Test userName"
        emailAddress = "Test emailAddress"
        userAge = 0
        userLifetime = 0
        numScenariosAnswered = 0
        numScenariosCorrect = 0
        averageResponseTime = 0
        favorites = []
        //self.getUser()
    }
    func getUser() {
        //once the user has logged in the application will need to call this function as we cannot ...
        //... immediately access the database without setting placeholder values for the variables
        
        //this function will call the database and then update the variables
        return //but is currently not doing anything for the time being
    }
    func updateNumScenariosAnswered (intParameter: Int) {
        numScenariosAnswered = intParameter
    }
    func updateNumScenariosCorrect (intParameter: Int) {
        numScenariosCorrect = intParameter
    }
    func updateAverageResponseTime (intParameter: Int) {
        averageResponseTime = intParameter
    }
    func updateFavorites (intArrayParameter: Int64) {
        favorites[favorites.count] = intArrayParameter
        //sets the last element of the favorites array to the id of the "favourited" scenario
    }
    func updateEmailAddress (stringParameter: String) {
        emailAddress = stringParameter
    }
    func updateUserAge (intParameter: Int) {
        userAge = intParameter
    }
    func updateUserLifetime (intParameter: Int) {
        userLifetime = intParameter
    }
}

struct userProfile {
    //MARK: VARIABLES
    private var correct : Int
    private var incorrect : Int
    
    
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
