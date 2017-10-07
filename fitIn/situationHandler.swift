//
//  situationHandler.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-07.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import Foundation

struct situationHandler {
    private var user = userProfile()
    private var currentSituation = situation()
    
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
    func loadNextSituation(){
        
    }
}
