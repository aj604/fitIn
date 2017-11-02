//
//  userData.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-07.
//  Modified by Vladislav Polin on 2017-10-25 onwards.
//  Copyright © 2017 group of 5. All rights reserved.
//

import Foundation

class userProfile {
    //Variables:
    private static var currentUser: userProfile? = userProfile() //put this right above the variables
    var userName: String
    var emailAddress: String
    var userAge: Int
    var userLifetime: Int //the time for which the user has spent on our application, it is measured in seconds
    var numScenariosAnswered: Int
    var numScenariosCorrect: Int
    var averageResponseTime: Int //the average response time of a user, it is measured in milliseconds
    var favorites = [Int64]() //the array of long ints, each of which represent the id for a scenario
    var isUserLoggedIn: Bool
    
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
        isUserLoggedIn = false
        //self.getUser()
    }
    func getUser() {
        //once the user has logged in the application will need to call this function as we cannot ...
        //... immediately access the database without setting placeholder values for the variables
        
        //this function will call the database and then update the variables
        return //but is currently not doing anything for the time being
    }
    func updateNumScenariosAnswered (_ intParameter: Int) {
        numScenariosAnswered = intParameter
    }
    func updateNumScenariosCorrect (_ intParameter: Int) {
        numScenariosCorrect = intParameter
    }
    func updateAverageResponseTime (_ intParameter: Int) {
        averageResponseTime = intParameter
    }
    func updateFavorites (_ intArrayParameter: Int64) {
        favorites[favorites.count] = intArrayParameter
        //sets the last element of the favorites array to the id of the "favourited" scenario
    }
    func updateEmailAddress (_ stringParameter: String) {
        emailAddress = stringParameter
    }
    func updateUserAge (_ intParameter: Int) {
        userAge = intParameter
    }
    func updateUserLifetime (_ intParameter: Int) {
        userLifetime = intParameter
    }
    
    func gotCorrect () {
        updateNumScenariosAnswered(self.numScenariosAnswered+1)
        updateNumScenariosCorrect(self.numScenariosCorrect+1)
    }
    func gotIncorrect() {
        updateNumScenariosAnswered(self.numScenariosAnswered+1)
    }
    func updateAverageResponseTime (intParameter: Int) {
        //pass in the averageResponseTime for which you want to add to the user's statistics
        //https://en.wikipedia.org/wiki/Moving_average
        averageResponseTime = (intParameter + self.numScenariosAnswered*self.averageResponseTime)/(self.numScenariosAnswered + 1)
    }
    func updateDatabase () {
        //this function will update the database with whatever is locally stored
        //but for now it is temporarily doing nothing
        return
    }
    class func current() -> userProfile? { //put this under the methods
          return currentUser
    }
}



/*struct userProfile {
    //MARK: VARIABLES
    private var correct : Int {
        didSet {
            print("User got an answer correct! \nuser now has \(correct) correct answers\n")
        }
    }
    private var incorrect : Int{
        didSet {
            print("User got an answer wrong :( \nuser now has \(incorrect) incorrect answers\n")
        }
    }
    
    
    //MARK: METHODS
    init(){
        correct = 0
        incorrect = 0
    }
    
    mutating func gotCorrect(){
        correct += 1
    }
    mutating func gotIncorrect(){
        incorrect += 1
    }
}*/
