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

var userIsCorrect = false;

class ScenarioHandler {
    
    // MARK: VARIABLES
    
    private var user = UserProfile() //User Data, Info stored here
    
    var currentScenario: Int = 0;
    static let NUM_SCENARIOS = 5;
    var scenarios = [Scenario]();
    var tasks = [AWSTask<Scenario>]();
    var taskKickOffTime = [Date]();
    var taskMaximumLength = 2000.0; // milliseconds
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
        self.taskKickOffTime = Array(repeating: Date(), count: ScenarioHandler.NUM_SCENARIOS);
        
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
            taskKickOffTime[index] = Date();
            
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
            user.gotCorrect() // Log vote in the user struct
            userIsCorrect = true;
            print("user is correct")
            return true
        }
        user.gotIncorrect() // Log vote in the user struct
        userIsCorrect = false;
        print("user is incorrect")
        return true // Vote was logged maybe add a return to the user vote

    }
    
    // Func will iterate Scenario to next in line
    // handles some transition to next state
    // Other transitions calculated in observing properties
    func loadNextScenario() {
        
        self.scenarios[currentScenario].seen = true;
        
        var sc: String = "scenarios [ ";
        for (index, scenario) in scenarios.enumerated() {
            sc.append(scenario.scenarioID);
            sc.append(" seen:");
            sc.append(String(scenario.seen));
            sc.append(" valid:");
            sc.append(String(scenario.valid));
            sc.append(", ");
        }
        sc.append("]");
        print(sc);
        // find a new currentScenario
        for (index, scenario) in scenarios.enumerated() {
            if scenario.valid && !scenario.seen && scenario.questionText != "broken" {
                currentScenario = index;
                break;
            }
        }
        
        // kick off new tasks
        for (index, scenario) in scenarios.enumerated() {
            // add a new task if the corresponding scenario has been seen by the viewer
            if (index == currentScenario)
            {
                continue;
            }
            
            if( (scenario.seen)
                || (!scenario.valid && Date().timeIntervalSince(taskKickOffTime[index]) > taskMaximumLength )
                || tasks[index].isFaulted) {
                
                print("requesting new scenario in place of ", scenario.scenarioID);
                scenarios[index] = Scenario();
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
                
                Timer.scheduledTimer(withTimeInterval: taskMaximumLength / 1000, repeats: false, block: {
                    (timer: Timer) -> Void in
                    if(!scenario.valid) {
                        print("scenario failed to load");
                    }
                })
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
