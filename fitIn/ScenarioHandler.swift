//
//  ScenarioHandler.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-07.
//  Copyright © 2017 group of 5. All rights reserved.
//

import Foundation

//This is the ScenarioHandler class, it instantiates the other classes and interprets events

//Controls flow of app
struct ScenarioHandler {
    
    // MARK: VARIABLES
    
    private var user = UserProfile() //User Data, Info stored here
    
    // instantiation of Scenario, only one Scenario is loaded at a time
    private var currentScenario = Scenario(scenarioID: "insertSituationID", type: Scenario.ScenarioType.yesOrNo) {
        // This willSet preloads image data for a smooth transition to next Scenario
        willSet{
            if let buffer = nextScenario?.getImageData() {
                imageData = buffer
            }
        }
        
        // This didSet assumes that we have segued to our next Scenario and we are initializing our handler
        didSet {
            // Clear previous input answer and upcoming Scenario
            voteChoice = nil
            nextScenario = nil
        }
    }

    // preload next Scenario
    private var nextScenario : Scenario? {
        didSet {
            if let buffer = nextScenario?.type {
                nextScenarioType = buffer
            }
        }
    }
    
    // Variable to store the type of the next Scenario. This will be used to tell the view controller
    // what type of view to load for the incoming expected response
    private var nextScenarioType : Scenario.ScenarioType?
    
    //Image Data to use for UIImageView
    private var imageData = Data()
    
    // General container for all response types
    // When set, begins segue
    var voteChoice : Int? {
        // When the controller sets voteChoice it will automatically call the vote function
        // Insert transition methods here
        didSet {
            if(voteChoice != nil) {
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
    mutating func vote() -> Bool {
        if voteChoice == nil {
            print("voteChoice is not set")
            return false
            //Failed Vote
        }
        
        currentScenario.response = voteChoice!
        if currentScenario.isRightAnswer() {
            user.gotCorrect() // Log vote in the user struct
            return true
        }
        user.gotIncorrect() // Log vote in the user struct
        return true // Vote was logged maybe add a return to the user vote
    }
    
    // Func will iterate Scenario to next in line
    // handles some transition to next state
    // Other transitions calculated in observing properties
    mutating func loadNextScenario(){
        if let upcoming = nextScenario {
            currentScenario = upcoming
        } else {
            // This is the temporary next Scenario being loaded
            // Will replace with Scenario from server after that functionality is there
            print("default setting next Scenario and transitioning")
            nextScenario = Scenario(scenarioID: "insertSituationID", type: Scenario.ScenarioType.yesOrNo)
            nextScenario?.setScenarioURL(url: "https://i.redd.it/k8w5wgzvm0uz.jpg")
            currentScenario = nextScenario!
        }
    }
    
    // Import Scenario image data
    mutating func loadScenarioImageData() -> Data {
        imageData = currentScenario.getImageData()
        //Currently Returns image data, to keep the var private
        //maybe change?
        return imageData
    }
    
    //return scenario answer reasoning
    func returnReasoning() -> String {
        return currentScenario.answerReasoning
    }
    
}
