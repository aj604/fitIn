//
//  ViewController.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-06.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var situationController = situationHandler()

    @IBAction func proSocialPic(_ sender: UIButton) {
        situationController.voteProSocial()
        situationController.loadNextSituation()
    }
    
    @IBAction func antiSocialPic(_ sender: UIButton) {
        situationController.voteAntiSocial()
        situationController.loadNextSituation()
    }


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

