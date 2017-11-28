//
//  Scenario.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-07.
//  Copyright © 2017 group of 5. All rights reserved.
//  contributors: Vlad Polin, Scott Checko, Avery Jones, Aarish Kapila, Yanisa Chinitsarayos, Kevin Cheng
//  Known bugs:
//              -

import Foundation
import AWSDynamoDB


// This class represents a Scenario that the user would see in their typical
// interaction with our app.
class Scenario {
    
    // Enum for the type of response that the Scenario requires
    // MAY potentially use associated values for storing of answer type
    enum ScenarioType : Int {
        case yesOrNo
        case slider
        case multipleChoice
    }
    
    static let MAX_ANSWER_VALUE     = 10
    static let MIN_ANSWER_VALUE     = 0
    static let ANSWER_YES           = 10
    static let ANSWER_NO            = 0
    static let ANSWER_A             = 0 / 3
    static let ANSWER_B             = MAX_ANSWER_VALUE / 3
    static let ANSWER_C             = MAX_ANSWER_VALUE * 2 / 3
    static let ANSWER_D             = MAX_ANSWER_VALUE
    
    
    //MARK: VARIABLES
    
    // metadata
    var scenarioID : String = "0"
    var createdBy: String = "Anonymous"
    var tags = [String]() // List of metadata / Scenario Tags
    
    var questionText: String = "broken"
    var answerReasoning: String = "a"
    var imageLoc : URL
    
    var type : ScenarioType = ScenarioType.yesOrNo
    var initialAnswer: Int = 0 // answer set by creator
    var averageAnswer: Double = 0.0
    var averageTimeToAnswer: Double = 0.0
    var numberOfAnswers: Int = 0
    
    var standardDeviation : Double = 0.0
    var mean : Double = 0.0
    var currentMean : Double = 0.0
    
    var imageData = Data()
    
    // has the scenario been seen by the viewer?
    var seen = false;
    
    //MARK: METHODS
    
    // default init
    required init() {
        imageLoc = URL(string: "https:i.imgur.com/I8wCreu.jpg")!
        answerReasoning = String(arc4random())
        initialAnswer = Int(arc4random()) % Scenario.MAX_ANSWER_VALUE
    }
    
    // Need to make this a load function from our DB based upon Scenario ID
    // Will init the imageURL either locally or from URL from db
    init(scenarioID: String, type : ScenarioType) {
        self.scenarioID = scenarioID
        imageLoc = URL(string: "https:i.imgur.com/I8wCreu.jpg")!
        answerReasoning = String(arc4random())
    }
    
    init(seen: Bool) {
        self.seen = seen;
        imageLoc = URL(string: "https:i.imgur.com/I8wCreu.jpg")!
        answerReasoning = String(arc4random())
        initialAnswer = Int(arc4random()) % Scenario.MAX_ANSWER_VALUE
    }
    
    // Creates and returns a DynamoDB compatible dictionary representing this class.
    func toDBDictionary() -> [String : AWSDynamoDBAttributeValue] {
        
        return [
            SCENARIO_MASTER_TABLE_PRIMARY_KEY: makeAttrib(self.scenarioID),
            "createdBy": makeAttrib(self.createdBy),
            // "tags": makeAttrib(<#T##value: Int##Int#>), // todo array of strings
            
            "questionText": makeAttrib(self.questionText),
            "answerReasoning": makeAttrib(self.answerReasoning),
            "imageLoc": makeAttrib(self.imageLoc.absoluteString),
            
            "type": makeAttrib(self.type.rawValue),
            "initialAnswer": makeAttrib(self.initialAnswer),
            "averageAnswer": makeAttrib(averageAnswer),
            "averageTimeToAnswer": makeAttrib(self.averageTimeToAnswer),
            "numberOfAnswers": makeAttrib(self.numberOfAnswers),
            
            "standardDeviation": makeAttrib(self.standardDeviation),
            "mean": makeAttrib(self.mean),
            "currentMean": makeAttrib(self.currentMean)
        ]
    }
    
    // Creates a Scenario from a DynamoDB dictionary
    func fromDBDictionary(_ dict: [String : AWSDynamoDBAttributeValue]) -> Void {
        
        self.scenarioID = dict[SCENARIO_MASTER_TABLE_PRIMARY_KEY]!.s!
        self.createdBy = dict["createdBy"]!.s!
        //self.tags = dict["tags"]!.ss!
        
        self.questionText = dict["questionText"]!.s!
        self.answerReasoning = dict["answerReasoning"]!.s!
        self.imageLoc = URL(string: dict["imageLoc"]!.s!)!
        
        self.type = ScenarioType(rawValue: Int(dict["type"]!.n!)!)!
        self.initialAnswer = Int(dict["initialAnswer"]!.n!)!
        // self.averageAnswer = Double(dict["initialAnswer"]!.n!)!
        // self.averageTimeToAnswer = Double(dict["averageTimeToAnswer"]!.n!)!
        self.numberOfAnswers = Int(dict["numberOfAnswers"]!.n!)!
        
        // self.standardDeviation = Double(dict["standardDeviation"]!.n!)!
        // self.mean = Double(dict["mean"]!.n!)!
        // self.currentMean = Double(dict["currentMean"]!.n!)!
        
    }
    
    // general answer checking method
    // Pre: Scenario is loaded and inputAnswer != nil
    // Post: Bool? determining if they got the right answer or if inputAnswer wasnt initialized
    func isRightAnswer(userAnswer: Int) -> Bool {
        let MIN_ANSWERS = 10;

        if(self.numberOfAnswers > MIN_ANSWERS)
        {
            // print("answer is ",self.averageAnswer)
            switch(self.type) {
            case .slider:
                if(userAnswer <= Int(self.averageAnswer + self.mean) && userAnswer >= Int(self.averageAnswer - self.mean)) {
                    // user answer is within the correct answer range
                    return true;
                } else {
                    // user is not correct
                    return false;
                }
            case .yesOrNo:
                // round the average value to either 0 or MAX_ANSWER_VALUE with integer math.
                let roundedAverageAnswer = ((Int(self.averageAnswer) + Scenario.MAX_ANSWER_VALUE / 2) / Scenario.MAX_ANSWER_VALUE) * Scenario.MAX_ANSWER_VALUE;
                // print("rounded", roundedAverageAnswer);
                // print("user", userAnswer);
                if (userAnswer == roundedAverageAnswer) {
                    return true;
                } else {
                    return false;
                }
            case .multipleChoice:
                print("multi choice unsupported")
            }

        } else
        {
            // print("answer is ", self.initialAnswer)
            // basic comparison for a small number of answers
            // this lets the standard deviation ramp up a little
            // before depending on it.
            switch(self.type) {
            case .slider:
                let SLIDER_GRACE = Scenario.MAX_ANSWER_VALUE / 4;
                if(userAnswer <= Int(self.initialAnswer + SLIDER_GRACE) && userAnswer >= Int(self.initialAnswer - SLIDER_GRACE)) {
                    // user answer is within the correct answer range
                    return true;
                } else {
                    // user is not correct
                    return false;
                }
            case .yesOrNo:
                // round the average value to either 0 or MAX_ANSWER_VALUE with integer math.
                let roundedAverageAnswer = ((Int(self.initialAnswer) + Scenario.MAX_ANSWER_VALUE / 2) / Scenario.MAX_ANSWER_VALUE) * Scenario.MAX_ANSWER_VALUE;
                // print("rounded", roundedAverageAnswer);
                // print("user", userAnswer);
                if (userAnswer == roundedAverageAnswer) {
                    return true;
                } else {
                    return false;
                }
            case .multipleChoice:
                print("multi choice unsupported")
            }
        }
        return false;
    }
    
    // Helper func to set image URL before database urls can be tested
    func setScenarioURL(url: String) {
        //really bad practice for force unwrap on a UI Item
        imageLoc = URL(string: url)!
    }
    
    // Returns image data for the Scenario, Used in situationHandler
    func getImageData() -> Void { // Get Image Data from URL / Local
        var imageOut = Data()//Data type, to prep image for UIImageView
        do{
            try? imageOut = Data(contentsOf: imageLoc) //Primary image location
            /*} catch {
             do{
             // backup local failedToLoad resource. Should not fail... needs work
             print("Uhoh shouldnt get here")
             try? imageOut = Data(contentsOf: Bundle.main.url(forResource: "failedToLoad", withExtension: ".png")!)
             } catch {
             print("UHOH Cant find our local failed to load image!")
             }*/
        }
        self.imageData = imageOut
    }
}
