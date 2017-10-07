//
//  situation.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-07.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import Foundation

struct situation {
    
    var situationTags = [String]()
    private var imageLoc = URL(string: "https:i.imgur.com/I8wCreu.jpg")!
    private var isPositive = false
    
    func isProSocial() -> Bool {
        return isPositive
    }
}
