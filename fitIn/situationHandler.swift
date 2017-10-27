//
//  situationHandler.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-07.
//  Copyright © 2017 group of 5. All rights reserved.
//

import Foundation

//This is the situationHandler class, it instantiates the other classes and interprets
//events
//Controls flow of app
struct situationHandler {
    // MARK: VARIABLES
    
    private var user = userProfile() //User Data, Info stored here
    // instantiation of situation, only one situation is loaded at a time
    //
    // FUTURE: Maybe preload upcoming situation
    private var currentSituation = situation(situationID: "insertSituationID", type: situation.responseType.yesOrNo(true)) {
        // This didSet assumes that we have segued to our next situation and we are initializing our handler
        willSet{
            imageData = (nextSituation?.getImageData())!
        }
        didSet {
            // Clear previous input answer and upcoming situation
            voteChoice = nil
            nextSituation = nil
        }
    }

    // preload next situation
    private var nextSituation : situation? {
        didSet {
            nextSituationType = nextSituation?.getSituationType()
        }
    }
    private var nextSituationType : String?
    
    //Image Data to use for UIImageView
    private var imageData = Data()
    
    // General container for all response types
    // Handles segue
    var voteChoice : situation.responseType? {
        // When the controller sets voteChoice it will automatically call the vote function
        // Insert transition methods here
        didSet {
            if vote() == nil {
                print("failedVote")
            }
        }
    }
  
    
    //MARK: METHODS
    //lodge a vote.
    // Pre: voteChoice is set to specific case of responseType with its associatedValue
    // Post: Returns bool? based on right/wrong answer or a nil bug
    mutating func vote() -> Bool?{
        if voteChoice == nil {
            return nil
        }
        currentSituation.inputAnswer = voteChoice
        if currentSituation.isRightAnswer()!{
            user.gotCorrect()
            return true
        }
        user.gotIncorrect()
        return true
    }
    
    //Func will iterate situation to next in line
    // handles some transition to next state
    // Other transitions calculated in observing properties
    mutating func loadNextSituation(){
        if let upcoming = nextSituation {
            currentSituation = upcoming
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
