//
//  ScenarioViewController.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-06.
//  Copyright © 2017 group of 5. All rights reserved.
//  contributors: Vlad Polin, Scott Checko, Avery Jones, Aarish Kapila, Yanisa Chinitsarayos, Kevin Cheng
//  Known bugs:
//  

import UIKit

class testScenarioViewController: UIViewController {
    
    
    //Image View, Put Image HERE!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scenarioName: UILabel!
    //Control Current Scenario
    private var scenarioController = ScenarioHandler()
    
    // Eventually this will be access point for subView
    fileprivate var responseController : ResponseViewController!
    @IBOutlet weak var responseControllerhmm: UIView!
    
    //User input
    @IBAction func proSocialPic(_ sender: UIButton) {
        scenarioController.voteChoice = 1
        scenarioController.loadNextScenario()
        updateUI()
    }
    @IBAction func antiSocialPic(_ sender: UIButton) {
        scenarioController.voteChoice = 0
        scenarioController.loadNextScenario()
        updateUI()
    }
    
    // Update the UI to represent the change in Scenario
    // Once different response views are set they can be set here
    func updateUI() {
        if let image = UIImage(data: scenarioController.loadScenarioImageData()){
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Try loading image data from first Scenario
        if let image = UIImage(data: scenarioController.loadScenarioImageData()){
            print("image loaded")
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
        } else {
            print("hmm something went wrong buffering the initial image")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


