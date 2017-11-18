//
//  ScenarioHandler.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-07.
//  Copyright © 2017 group of 5. All rights reserved.
//  contributors: Vlad Polin, Scott Checko, Avery Jones, Aarish Kapila, Yanisa Chinitsarayos, Kevin Cheng
//  Known bugs:
//            

import Foundation
import AWSDynamoDB

//This is the ScenarioHandler class, it instantiates the other classes and interprets events

//Controls flow of app
class ScenarioHandler {
    
    // MARK: VARIABLES
    
    private var user = UserProfile() //User Data, Info stored here
    
    var getNextScenarioTask = dynamoHandler.getRandomScenario()
    
    var currentScenario: Int = 0;
    static let NUM_SCENARIOS = 5;
    var scenarios = [Scenario]();
    var tasks = [AWSTask<Scenario>]();
    
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
    
    init() {
        
        self.scenarios = Array(repeating: Scenario(seen: true), count: ScenarioHandler.NUM_SCENARIOS)
        self.tasks = Array(repeating: AWSTask(), count: ScenarioHandler.NUM_SCENARIOS);
        
        for (index, _) in tasks.enumerated() {
            tasks[index] = dynamoHandler
                .getRandomScenario()
                .continueOnSuccessWith(block:
                    {
                        (task:AWSTask<Scenario>) -> AWSTask<Scenario> in
                        if let error = task.error {
                            print("failed put request to user. Error: \(error)")
                            return AWSTask(error: NSError(domain: "", code: ErrorTypes.RequestFailed.rawValue))
                        }
                        print("successful get request to scenario, in init")
                        
                        task.result!.seen = false;
                        self.scenarios[index] = task.result!;
                        
                        return AWSTask(result: task.result!);
                }) as! AWSTask<Scenario>;
        }
    }
    
    // lodge a vote.
    // Pre: voteChoice is set to specific case of responseType with its associatedValue
    // Post: Returns bool? based on right/wrong answer or a nil bug
    func vote() -> Bool {
        if voteChoice == nil {
            print("voteChoice is not set")
            return false
            //Failed Vote
        }
        
        scenarios[currentScenario].response = voteChoice!
        if scenarios[currentScenario].isRightAnswer() {
            user.gotCorrect() // Log vote in the user struct
            return true
        }
        user.gotIncorrect() // Log vote in the user struct
        return true // Vote was logged maybe add a return to the user vote
    }
    
    // Func will iterate Scenario to next in line
    // handles some transition to next state
    // Other transitions calculated in observing properties
    func loadNextScenario() {
        
        // kick off new tasks
        for (index, scenario) in scenarios.enumerated() {
            // add a new task if the corresponding scenario has been seen by the viewer
            if(scenario.seen) {
                tasks[index] = dynamoHandler
                    .getRandomScenario()
                    .continueOnSuccessWith(block:
                        {
                            (task:AWSTask<Scenario>) -> AWSTask<Scenario> in
                            if let error = task.error {
                                print("failed put request to user. Error: \(error)")
                                return AWSTask(error: NSError(domain: "", code: ErrorTypes.RequestFailed.rawValue))
                            }
                            print("successful get request to scenario, in getnext");
                            
                            task.result!.seen = false;
                            self.scenarios[index] = task.result!;
                            
                            return AWSTask(result: task.result!);
                    }) as! AWSTask<Scenario>;
            }
        }
        
        // find a new currentScenario
        var found = false;
        for (index, scenario) in scenarios.enumerated() {
            if !scenario.seen {
                currentScenario = index;
                found = true;
                break;
            }
        }
        
        if !found {
            for (index, task) in tasks.enumerated() {
                if !task.isCompleted && scenarios[index].seen == true {
                    task.waitUntilFinished();
                    currentScenario = index;
                    break;
                }
            }
        }
        
        
    }
    
    // Import Scenario image data
    func loadScenarioImageData() -> Data {
        //Currently Returns image data, to keep the var private
        //maybe change?
        return scenarios[currentScenario].imageData
    }
    
    //return scenario answer reasoning
    func returnReasoning() -> String {
        return scenarios[currentScenario].answerReasoning
    }
    
}
