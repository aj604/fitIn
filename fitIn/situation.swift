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
        func getNumber() -> Double? {
            switch self {
            case .slider(let value):
                return value
            case .multipleChoice(let value):
                return Double(value)
            default:
                return nil
            }
        }
        
    }
    var inputAnswer : responseType?
    
    //MARK: VARIABLES
    var situationTags = [String]() // List of metadata / situation Tags
    // just a random imgur url for initialization, Needs init func
    private var imageLoc : URL
    //private var rightAnswer : Bool
    private var response : responseType

    //MARK: METHODS
    init(situationID: String, type : responseType){
        // Insert
        imageLoc = URL(string: "https:i.imgur.com/I8wCreu.jpg")!
        response = type
    }
    
    func isProSocial() -> Bool? {
        return response.getBool()
    }
    func isRightAnswer() -> Bool {
        if let answer = inputAnswer {
        switch answer {
        case .yesOrNo(let value):
            let expectedResponse = response.getBool()
            if value == expectedResponse {
                return true
            }
            return false
        case .multipleChoice(let value):
            let expectedResponse = Int(response.getNumber()!)
            if value == expectedResponse {
                return true
            }
            return false
        case .slider(let value):
            let expectedResponse = response.getNumber()
            if value == expectedResponse {
                return true
            }
            return false
    }

    func getImageData() -> Data { // Get Image Data from URL
        var imageOut = Data()//Data type, to prep image for UIImageView
        do{
            try imageOut = Data(contentsOf: imageLoc) //Primary image location
        } catch {
            do{
                // backup local failedToLoad resource. Should not fail... needs work
                try imageOut = Data(contentsOf: Bundle.main.url(forResource: "failedToLoad", withExtension: ".png")!)
            } catch {
            
            }
        }
        return imageOut
    }
}
