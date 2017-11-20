//
//  MultipleChoiceViewController.swift
//  fitIn
//
//  Created by Avery Jones on 2017-11-03.
//  Copyright © 2017 group of 5. All rights reserved.
//  contributors: Scott Checko, Avery Jones
//  Known bugs:
//              - 

import UIKit

class MultipleChoiceViewController: UIViewController {
    
    //Control Current Scenario
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scenarioDescription: UILabel!
    
    
    // Use these outlets to set the button text
    @IBOutlet weak var optionA: UIButton!
    @IBOutlet weak var optionB: UIButton!
    @IBOutlet weak var optionC: UIButton!
    @IBOutlet weak var optionD: UIButton!
    
    @IBAction func choiceA(_ sender: UIButton) {
        scenarioController.voteChoice = 0
        scenarioController.loadNextScenario()
        updateUI()
    }
    @IBAction func choiceB(_ sender: UIButton) {
        scenarioController.voteChoice = 1
        scenarioController.loadNextScenario()
        updateUI()
    }
    @IBAction func choiceC(_ sender: UIButton) {
        scenarioController.voteChoice = 2
        scenarioController.loadNextScenario()
        updateUI()
    }
    @IBAction func choiceD(_ sender: UIButton) {
        scenarioController.voteChoice = 3
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
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "yesOrNoSegue" {
            let destination = segue.destination as? ScenarioViewController
            //destination?.scenarioController = scenarioController
        }
        if segue.identifier == "sliderSegue" {
            let destination = segue.destination as? SliderViewController
            //destination?.scenarioController = scenarioController
        }
    }*/
}
