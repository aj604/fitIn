//
//  situation.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-07.
//  Copyright © 2017 group of 5. All rights reserved.
//

import Foundation

struct situation {
    
    // Enum for the type of response that the situation requires
    // MAY potentially use associated values for storing of answer type
    enum responseType {
        case yesOrNo(Bool)
        case slider(Double)
        case multipleChoice(Int)
        
        // Helper func to determine the type of response box our next view will need
        // Could use something like an int as an identifier
        // Accessed via situation.getResponseType()
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
        fileprivate func getBool() -> Bool? {
            switch self{
            case .yesOrNo(let value):
                return value
            default:
                return nil
            }
        }
        
        // Unwraps associated Value or returns nil
        fileprivate func getSlider() -> Double? {
            switch self {
            case .slider(let value):
                return value
            default:
                return nil
            }
        }
        
        // Unwraps associated Value or returns nil
        fileprivate func getMultipleChoice() -> Int? {
            switch self {
            case .multipleChoice(let value):
                return value
            default:
                return nil
            }
        }
    }
    
    
    
    
    //MARK: VARIABLES
    var inputAnswer : responseType?
    var situationTags = [String]() // List of metadata / situation Tags
    // just a random imgur url for initialization, has one more URL it will segue to on vote()
    private var imageLoc : URL
    private var response : responseType // Includes both the type of response and the answer
    private var tipsForNextTime : String
    
    
    //MARK: METHODS

    // Need to make this a load function from our DB based upon situation ID
    // Will init the imageURL either locally or from URL from db
    init(situationID: String, type : responseType){
        imageLoc = URL(string: "https:i.imgur.com/I8wCreu.jpg")!
        response = type
        tipsForNextTime = "Sucks to suck"
    }
    
    // general answer checking method
    // Pre: Situation is loaded and inputAnswer != nil
    // Post: Bool? determining if they got the right answer or if inputAnswer wasnt initialized
    func isRightAnswer() -> Bool? {
        if let answer = inputAnswer {
            switch answer {
            case .yesOrNo(let value):
                let expectedResponse = response.getBool()
                if value == expectedResponse {
                    return true
                }
                return false
            case .multipleChoice(let value):
                let expectedResponse = response.getMultipleChoice()
                if value == expectedResponse {
                    return true
                }
                return false
            case .slider(let value):
                let expectedResponse = response.getSlider()
                if value == expectedResponse {
                    return true
                }
                return false
            }
        }
        print("Code should NEVER get here, This means the response type and answer was not initialized for this situation ")
        return nil
    }
    
    // Helper func to set image URL before database urls can be tested
    mutating func setSituationURL(url: String) {
        //really bad practice for force unwrap on a UI Item
        imageLoc = URL(string: url)!
    }
    
    // Returns a string of the response type expected for the current situation
    func getSituationType() -> String {
        return response.getType()
    }
    
    // Returns image data for the situation, Used in situationHandler
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
