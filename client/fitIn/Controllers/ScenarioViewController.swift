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
import Speech

class ScenarioViewController: UIViewController {
    
    
    //Image View, Put Image HERE!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var questionDescription: UILabel!
    @IBOutlet weak var voiceButton: UIButton!
    
    //setup variables for speech recog
    /*let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?*/
    
    //Control Current Scenario
    //var scenarioController = ScenarioHandler()
    
    // Eventually this will be access point for subView
    //fileprivate var responseController : responseViewController
    
    
    //User input
    @IBAction func proSocialPic(_ sender: UIButton) {
        scenarioController.voteChoice = Scenario.ANSWER_YES
        scenarioController.loadNextScenario()
        updateUI()
    }
    @IBAction func antiSocialPic(_ sender: UIButton) {
        scenarioController.voteChoice = Scenario.ANSWER_NO
        scenarioController.loadNextScenario()
        updateUI()
    }
    @IBAction func startRecord(_ sender: UIButton) {
        voiceButton.backgroundColor = UIColor.green;
    }
    @IBAction func stopRecord(_ sender: UIButton) {
        voiceButton.backgroundColor = UIColor.white;
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

