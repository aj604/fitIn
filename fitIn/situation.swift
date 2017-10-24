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
    enum responseType{
        case yesOrNo(Bool)
        case slider(Double)
        case multipleChoice(Int)
        
        func getBool() -> Bool? {
            switch self{
            case .yesOrNo(let value):
                return value
            default:
                return nil
            }
        }
        func getSlider() -> Double? {
            switch self {
            case .slider(let value):
                return value
            default:
                return nil
            }
        }
        func getMultipleChoice() -> Int? {
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
    // just a random imgur url for initialization, Needs init func
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
    private func isRightAnswer() -> Bool? {
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
