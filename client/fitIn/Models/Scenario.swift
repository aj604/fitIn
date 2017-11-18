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
    
    var questionText: String = "a"
    var answerReasoning: String = "a"
    var imageLoc : URL
    
    var response: Int = 0 // temporary, replace with UpdateScenario struct
    
    var type : ScenarioType = ScenarioType.yesOrNo
    var initialAnswer: Int = 0 // answer set by creator
    var averageAnswer: Double = 0.0
    var standardDeviation : Double = 0.0
    var averageTimeToAnswer: Double = 0.0
    var numberOfAnswers: Int = 0
    
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
            // "averageAnswer": makeAttrib(averageAnswer), // todo double
            // "standardDeviation": makeAttrib(self.averageTimeToAnswer)
            // "averageTimeToAnswer": makeAttrib(self.averageTimeToAnswer)
            "numberOfAnswers": makeAttrib(self.numberOfAnswers)
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
        // self.standardDeviation = Double(dict["standardDeviation"]!.n!)!
        // self.averageTimeToAnswer = Double(dict["averageTimeToAnswer"]!.n!)!
        self.numberOfAnswers = Int(dict["numberOfAnswers"]!.n!)!
    
    }
    
    func setscenarioID(value: String) {
        self.scenarioID = value
    }
    
    func setScenarioID(value: String) {
        self.scenarioID = value
    }
    
    func _setscenarioID(value: String) {
        self.scenarioID = value
    }
    
    func accessInstanceVariablesDirectly() -> ObjCBool {
        return true
    }
    
    // general answer checking method
    // Pre: Scenario is loaded and inputAnswer != nil
    // Post: Bool? determining if they got the right answer or if inputAnswer wasnt initialized
    func isRightAnswer() -> Bool {
        
        if response == initialAnswer {
            return true
        }
        return false
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
