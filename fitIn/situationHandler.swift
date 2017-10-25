//
//  situationHandler.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-07.
//  Copyright © 2017 group of 5. All rights reserved.
//

import Foundation

//This is the situationHandler class, it instantiates the other classes and interprets events

//Controls flow of app
struct situationHandler {
    
    // MARK: VARIABLES
    
    private var user = userProfile(userID: "insertUserID") //User Data, Info stored here
    
    // instantiation of situation, only one situation is loaded at a time
    private var currentSituation = situation(situationID: "insertSituationID", type: situation.responseType.yesOrNo(true)) {
        // This willSet preloads image data for a smooth transition to next situation
        willSet{
            if let buffer = nextSituation?.getImageData() {
                imageData = buffer
            }
        }
        // This didSet assumes that we have segued to our next situation and we are initializing our handler
        didSet {
            // Clear previous input answer and upcoming situation
            voteChoice = nil
            nextSituation = nil
        }
    }

    // preload next situation
    private var nextSituation : situation? {
        didSet {
            if let buffer = nextSituation?.getSituationType() {
                nextSituationType = buffer
            }
        }
    }
    
    // Variable to store the type of the next situation. This will be used to tell the view controller
    // what type of view to load for the incoming expected response
    private var nextSituationType : String?
    
    //Image Data to use for UIImageView
    private var imageData = Data()
    
    // General container for all response types
    // When set, begins segue
    var voteChoice : situation.responseType? {
        // When the controller sets voteChoice it will automatically call the vote function
        // Insert transition methods here
        didSet {
            if voteChoice != nil {
                if vote() == false {
                    print("failedVote")
                }
           }
        }
    }
    
    //MARK: METHODS
    
    // lodge a vote.
    // Pre: voteChoice is set to specific case of responseType with its associatedValue
    // Post: Returns bool? based on right/wrong answer or a nil bug
    mutating func vote() -> Bool{
        if voteChoice == nil {
            print("voteChoice is not set")
            return false
            //Failed Vote
        }
        currentSituation.inputAnswer = voteChoice
        if currentSituation.isRightAnswer()!{
            user.gotCorrect() // Log vote in the user struct
            return true
        }
        user.gotIncorrect() // Log vote in the user struct
        return true // Vote was logged maybe add a return to the user vote
    }
    
    // Func will iterate situation to next in line
    // handles some transition to next state
    // Other transitions calculated in observing properties
    mutating func loadNextSituation(){
        if let upcoming = nextSituation {
            currentSituation = upcoming
        } else {
            // This is the temporary next situation being loaded
            // Will replace with situation from server after that functionality is there
            print("default setting next situation and transitioning")
            nextSituation = situation(situationID: "insertSituationID", type: situation.responseType.yesOrNo(false))
            nextSituation?.setSituationURL(url: "https://i.redd.it/k8w5wgzvm0uz.jpg")
            currentSituation = nextSituation!
        }
    }
    
    // Import situation image data
    mutating func loadSituationImageData() -> Data {
        imageData = currentSituation.getImageData()
        //Currently Returns image data, to keep the var private
        //maybe change?
        return imageData
    }
}
