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

let scenarioController = ScenarioHandler()
//This is the ScenarioHandler class, it instantiates the other classes and interprets events
//Controls flow of app
class ScenarioHandler {
    
    // MARK: VARIABLES
    
    private var user = UserProfile() //User Data, Info stored here
    
    var currentScenario: Int = 0;
    static let NUM_SCENARIOS = 5;
    var scenarios = [Scenario]();
    var tasks = [AWSTask<Scenario>]();
    var userStartedViewingTime = NSDate().timeIntervalSince1970
    
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
    
    var scenarioHistory = [Scenario]()
    
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
        
        // add to the scenario history
        scenarioHistory.append(scenarios[currentScenario])

        // create a ScenarioUpdate object
        let scenarioUpdate = ScenarioUpdate(
            scenarioID: scenarios[currentScenario].scenarioID,
            userAnswer: voteChoice!,
            // unfortunately timeIntervalSince1970 returns seconds.
            timeToAnswer: Int(NSDate().timeIntervalSince1970 - self.userStartedViewingTime) * 1000
        );
        
        // get a new date starting point for the next scenario
        self.userStartedViewingTime = NSDate().timeIntervalSince1970;
        
        // update user with new average time to answer
        user.updateAverageResponseTime(intParameter: scenarioUpdate.timeToAnswer)
        
        _ = dynamoHandler.putScenarioUpdate(scenarioUpdate);
        
        // determine correctness of the answer
        // update the user accordingly
        if scenarios[currentScenario].isRightAnswer(userAnswer: voteChoice!) {
            user.gotCorrect();
            print("user is correct")
            return true;
        } else {
            user.gotIncorrect();
            print("user is incorrect")
            return true;
        }

    }
    
    // Func will iterate Scenario to next in line
    // handles some transition to next state
    // Other transitions calculated in observing properties
    func loadNextScenario() {
        
        scenarios[currentScenario].seen = true;
        
        // kick off new tasks
        for (index, scenario) in scenarios.enumerated() {
            // add a new task if the corresponding scenario has been seen by the viewer
            if(scenario.seen || tasks[index].isFaulted) {
                tasks[index] = dynamoHandler
                    .getRandomScenario()
                    .continueOnSuccessWith(block:
                        {
                            (task:AWSTask<Scenario>) -> AWSTask<Scenario> in
                            if let error = task.error {
                                print("failed put request to user. Error: \(error)")
                                return AWSTask(error: NSError(domain: "", code: ErrorTypes.RequestFailed.rawValue))
                            }
                            
                            self.scenarios[index] = task.result!;
                            
                            return AWSTask(result: task.result!);
                    }) as! AWSTask<Scenario>;
            }
        }
        
        // find a new currentScenario
        var found = false;
        for (index, scenario) in scenarios.enumerated() {
            if !scenario.seen && scenario.questionText != "broken" {
                currentScenario = index;
                found = true;
                break;
            }
        }
        
        // wait if we must
        if !found {
            for (index, task) in tasks.enumerated() {
                if !task.isCompleted && !task.isFaulted && scenarios[index].seen == true {
                    task.waitUntilFinished();
                    if (task.result!.seen) {
                        continue;
                    }
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
