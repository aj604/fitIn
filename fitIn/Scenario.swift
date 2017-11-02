//
//  Scenario.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-07.
//  Copyright © 2017 group of 5. All rights reserved.
//

import Foundation

class Scenario {

    // Enum for the type of response that the Scenario requires
    // MAY potentially use associated values for storing of answer type
    enum responseType {
        case yesOrNo(Int)
        case slider(Int)
        case multipleChoice(Int)
        
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
        // Unwraps associated Value or returns nil
        fileprivate func getValue() -> Int {
            switch self{
            case .yesOrNo(let value):
                return value
            case .multipleChoice(let value):
                return value
            case .slider(let value):
                return value
            }
        }
    }
    
    
    //MARK: VARIABLES
    var scenarioID: String = "0"
    var inputAnswer : responseType?
    var scenarioTags = [String]() // List of metadata / Scenario Tags
    // just a random imgur url for initialization, has one more URL it will segue to on vote()
    private var imageLoc : URL
    private var response : responseType // Includes both the type of response and the answer
    private var tipsForNextTime : String
    
    /* Future Members
     let scenarioID: Int
     let createdBy: String
     let questionText: String
     var timeToAnswer = [Int]() //this is in milliseconds
     var averageAnswer: Double
     var standardDeviation : Double
     var averageTimeToAnswer: Double
     var numberOfAnswers: Int
*/
 //MARK: METHODS
    
    required init() {
        imageLoc = URL(string: "https:i.imgur.com/I8wCreu.jpg")!
        response = responseType.yesOrNo(0)
        tipsForNextTime = "Sucks to suck"
    }

    // Need to make this a load function from our DB based upon Scenario ID
    // Will init the imageURL either locally or from URL from db
    init(scenarioID: String, type : responseType) {
        self.scenarioID = scenarioID
        imageLoc = URL(string: "https:i.imgur.com/I8wCreu.jpg")!
        response = type
        tipsForNextTime = "Sucks to suck"
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
    func isRightAnswer() -> Bool? {
        if let answer = inputAnswer {
            if response.getValue() == answer.getValue() {
                return true
            }
            return false
        }
        print("Code should never get here, This means answer was not set properly")
        return nil
        
    }
    
    // Helper func to set image URL before database urls can be tested
    func setScenarioURL(url: String) {
        //really bad practice for force unwrap on a UI Item
        imageLoc = URL(string: url)!
    }
    
    // Returns a string of the response type expected for the current Scenario
    func getScenarioType() -> String {
        return response.getType()
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
