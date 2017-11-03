//
//  userData.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-07.
//  Modified by Vladislav Polin on 2017-10-25 onwards.
//  Copyright © 2017 group of 5. All rights reserved.
//

import Foundation
import AWSDynamoDB

class UserProfile {
    //Variables:
    private static var currentUser: UserProfile? = UserProfile()
    var emailAddress: String
    var userName: String
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
        isUserLoggedIn = true
        //self.getUser()
    }
    
    func toDBDictionary() -> [String : AWSDynamoDBAttributeValue] {
        
        return [
            USER_PROFILES_TABLE_PRIMARY_KEY: makeAttrib(self.emailAddress),
            "userName": makeAttrib(self.userName),
            
            "userAge": makeAttrib(self.userAge),
            "userLifetime": makeAttrib(self.userLifetime),
            "numScenariosAnswered": makeAttrib(self.numScenariosAnswered),
            "numScenariosCorrect": makeAttrib(self.numScenariosCorrect),
            "averageResponseTime": makeAttrib(self.averageResponseTime),
            // "favorites": makeAttrib(self.favorites), // todo array of ints
            // "isUserLoggedIn": makeAttrib(self.isUserLoggedIn), todo bools
        ]
    }
    
    func fromDBDictionary(_ dict: [String : AWSDynamoDBAttributeValue]) -> Void {
        
        self.emailAddress = dict[USER_PROFILES_TABLE_PRIMARY_KEY]!.s!
        self.userName = dict["userName"]!.s!

        self.userAge = Int(dict["userAge"]!.n!)!
        self.userLifetime = Int(dict["userLifetime"]!.n!)!
        self.numScenariosAnswered = Int(dict["numScenariosAnswered"]!.n!)!
        self.numScenariosCorrect = Int(dict["numScenariosCorrect"]!.n!)!
        self.averageResponseTime = Int(dict["averageResponseTime"]!.n!)!
        // self.favorites = Int(dict["userAge"]!.n!)!
        // self.isUserLoggedIn = Int(dict["userAge"]!.n!)!
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
    func updateEmailAddress (_ stringParameter: String) -> Bool {
        if (stringParameter.count > 5 && stringParameter.range(of:"@") != nil) {
            //userEditEmailAddressField must be more than 5 characters long, and must contain a "@" character
            //input has been validated at this point, but the constraints can be modified in the future
            emailAddress = stringParameter
            return true
        }
        return false
    }
    func updateUserAge (_ intParameter: Int) -> Bool {
        //userEditAgeField must only contain numbers and no spaces
        //users must be between the ages of 1-200
        if (intParameter >= 1 && intParameter <= 200) {
            userAge = intParameter
            return true
        }
        return false
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
    func updateUsername (_ stringParameter: String) -> Bool {
        //userEditUsernameField must be more than 5 characters long and must not contain profanity, detailed in listofSwearWords array
        //unfortunately it does not distinguish case insensitive usernames, but I will leave this for now as username format needs to be discussed
        if (stringParameter.count > 5 && (containsSwearWord(text: stringParameter, swearWords: listOfSwearWords) == false)) {
            userName = stringParameter
            return true
        }
        return false
    }
    
    func containsSwearWord(text: String, swearWords: [String]) -> Bool {
        return swearWords
            .reduce(false) { $0 || text.contains($1.lowercased()) }
    }
    //https://stackoverflow.com/questions/38185917/swift-how-to-censor-filter-text-entered-for-swear-words-etc
    let listOfSwearWords = ["fuck", "shit", "crap", "bitch", "cunt", "slut"]
    //feel free to add any that I may have missed @ groupmates :)
    
    class func current() -> UserProfile? {
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
