//
//  Scenario.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-07.
//  Copyright © 2017 group of 5. All rights reserved.
//

import Foundation
import AWSDynamoDB

class Scenario {

    // Enum for the type of response that the Scenario requires
    // MAY potentially use associated values for storing of answer type
    enum ScenarioType : Int {
        case yesOrNo
        case slider
        case multipleChoice
        
        // Helper func to determine the type of response box our next view will need
        // Could use something like an int as an identifier
        // Accessed via Scenario.getResponseType()
        fileprivate func getType() -> String {
            switch self {
            case .yesOrNo:
                return "yesOrNo"
            case .slider:
                return "slider"
            case .multipleChoice:
                return "multipleChoice"
            }
        }
        
        /*fileprivate func fromType(_ typeString: String) -> responseType {
            switch typeString {
            case ."yesOrNo"
                return
            case .slider:
                return "slider"
            case .multipleChoice:
                return "multipleChoice"
            }
        }*/
    }
    
    
    //MARK: VARIABLES
    
    // metadata
    var scenarioID : String = "0"
    var createdBy: String = "Anonymous"
    var tags = [String]() // List of metadata / Scenario Tags
    
    var questionText: String = ""
    var answerReasoning: String = ""
    var imageLoc : URL
    
    var response: Int = 0 // temporary, replace with UpdateScenario struct
    
    var type : ScenarioType = ScenarioType.yesOrNo
    var initialAnswer: Int = 0// answer set by creator
    var averageAnswer: Double = 0.0
    var standardDeviation : Double = 0.0
    var averageTimeToAnswer: Double = 0.0
    var numberOfAnswers: Int = 0

 //MARK: METHODS
    
    required init() {
        imageLoc = URL(string: "https:i.imgur.com/I8wCreu.jpg")!
        answerReasoning = "Sucks to suck"
    }

    // Need to make this a load function from our DB based upon Scenario ID
    // Will init the imageURL either locally or from URL from db
    init(scenarioID: String, type : ScenarioType) {
        self.scenarioID = scenarioID
        imageLoc = URL(string: "https:i.imgur.com/I8wCreu.jpg")!
        answerReasoning = "Sucks to suck"
    }
    
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
            "numberofAnswers": makeAttrib(self.numberOfAnswers)
        ]
    }
    
    func fromDBDictionary(_ dict: [String : AWSDynamoDBAttributeValue]) -> Void {
        
        /*// metadata
         var scenarioID : String = "0"
         let createdBy: String = "Anonymous"
         var tags = [String]() // List of metadata / Scenario Tags
         
         let questionText: String
         var answerReasoning: String
         var imageLoc : URL
         
         var response: Int // temporary, replace with UpdateScenario struct
         
         var type : ScenarioType
         var initialAnswer: Int // answer set by creator
         var averageAnswer: Double
         var standardDeviation : Double
         var averageTimeToAnswer: Double
         var numberOfAnswers: Int*/
        
        self.scenarioID = dict[SCENARIO_MASTER_TABLE_PRIMARY_KEY]!.s!
        self.createdBy = dict["createdBy"]!.s!
        //self.tags = dict["tags"]!.ss!
        
        self.questionText = dict["questionText"]!.s!
        self.answerReasoning = dict["answerReasoning"]!.s!
        self.imageLoc = URL(string: dict["imageLoc"]!.s!)!
        
        self.type = ScenarioType(rawValue: Int(dict["type"]!.s!)!)!
        self.initialAnswer = Int(dict["initialAnswer"]!.n!)!
        self.averageAnswer = Double(dict["initialAnswer"]!.n!)!
        self.standardDeviation = Double(dict["standardDeviation"]!.n!)!
        self.averageTimeToAnswer = Double(dict["averageTimeToAnswer"]!.n!)!
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
    func getImageData() -> Data { // Get Image Data from URL / Local
        var imageOut = Data()//Data type, to prep image for UIImageView
        do{
            try imageOut = Data(contentsOf: imageLoc) //Primary image location
        } catch {
            do{
                // backup local failedToLoad resource. Should not fail... needs work
                try imageOut = Data(contentsOf: Bundle.main.url(forResource: "failedToLoad", withExtension: ".png")!)
            } catch {
                print("UHOH Cant find our local failed to load image!")
            }
        }
        return imageOut
    }
}
