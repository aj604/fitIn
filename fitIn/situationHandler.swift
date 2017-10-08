//
//  situationHandler.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-07.
//  Copyright © 2017 group of 5. All rights reserved.
//

import Foundation

//This is the situationHandler class, it instantiates the other classes and interprets
//events
//Controls flow of app
struct situationHandler {
    
    private var user = userProfile() //User Data, Info stored here
    
    // instantiation of situation, only one situation is loaded at a time
    //
    // FUTURE: Maybe preload upcoming situation
    private var currentSituation = situation()
    
    //Image Data to use for UIImageView
    private var imageData = Data()
    
    
    
    //lodge a vote. May be too deep of proSocial calls
    mutating func voteProSocial() {
        if currentSituation.isProSocial(){
            user.gotCorrect()
        }
        user.gotIncorrect()
    }
    mutating func voteAntiSocial() {
        if !currentSituation.isProSocial(){
            user.gotCorrect()
        }
        user.gotIncorrect()
    }
    
    
    
    //Func will iterate situation to next in line
    // handles complete transition to next state
    func loadNextSituation(){
        
    }
    
    // Import situation image data
    mutating func loadSituationImageData() -> Data {
        imageData = currentSituation.getImageData()
        //Currently Returns image data, to keep the var private
        //maybe change?
        return imageData
    }
}
