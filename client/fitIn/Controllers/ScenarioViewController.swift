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

class ScenarioViewController: UIViewController {
    
    
    //Image View, Put Image HERE!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var questionDescription: UILabel!
    let DISABLE_TIME = 0.8; //seconds
    //User input
    @IBAction func proSocialPic(_ sender: UIButton) {
        sender.isEnabled = false;
        Timer.scheduledTimer(withTimeInterval: DISABLE_TIME, repeats: false, block: {
            (timer: Timer) -> Void in
            sender.isEnabled = true;
        })
        
        scenarioController.voteChoice = Scenario.ANSWER_YES
        scenarioController.loadNextScenario()
        updateUI()
    }
    @IBAction func antiSocialPic(_ sender: UIButton) {
        sender.isEnabled = false;
        Timer.scheduledTimer(withTimeInterval: DISABLE_TIME, repeats: false, block: {
            (timer: Timer) -> Void in
            sender.isEnabled = true;
        })
        scenarioController.voteChoice = Scenario.ANSWER_NO
        scenarioController.loadNextScenario()
        updateUI()
    }
    
    // Update the UI to represent the change in Scenario
    // Once different response views are set they can be set here
    func updateUI() {
        if let image = UIImage(data: scenarioController.loadScenarioImageData()){
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            questionDescription.text! = scenarioController.scenarios[scenarioController.currentScenario].questionText
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateUI()
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
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "prosocial" || segue.identifier == "antisocial" {
                let popView = segue.destination as! popUpViewController
                popView.passedReasoning = scenarioController.returnReasoning()
        }
        if segue.identifier == "sliderSegue" {
            let destination = segue.destination as? SliderViewController
            destination?.scenarioController = scenarioController
        }
        if segue.identifier == "multipleChoiceSegue" {
            let destination = segue.destination as? MultipleChoiceViewController
            destination?.scenarioController = scenarioController
        }
        if segue.identifier == "mainMenuSegue" {
            let destination = segue.destination as? MainMenuViewController
            destination?.scenarioController = scenarioController
        }
    }*/
}

