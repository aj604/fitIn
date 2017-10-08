//
//  situation.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-07.
//  Copyright © 2017 group of 5. All rights reserved.
//

import Foundation

struct situation {

    //MARK: VARIABLES
    var situationTags = [String]() // List of metadata / situation Tags
    // just a random imgur url for initialization, Needs init func
    private var imageLoc : URL
    private var rightAnswer : Bool

    //MARK: METHODS
    init(situationID: String){
        imageLoc = URL(string: "https:i.imgur.com/I8wCreu.jpg")!
        rightAnswer = false
    }
    
    func isProSocial() -> Bool {
        return rightAnswer
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
