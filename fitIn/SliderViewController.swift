//
//  SliderViewController.swift
//  fitIn
//
//  Created by Avery Jones on 2017-11-03.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import UIKit

class SliderViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scenarioDescription: UILabel!
    @IBOutlet weak var sliderValue: UISlider!
    
    //Control Current Scenario
    var scenarioController = ScenarioHandler()
    
    //User input
    @IBAction func submit(_ sender: UIButton) {
        scenarioController.voteChoice = Int(sliderValue.value)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "yesNoSegue"{
            let destination = segue.destination as! ScenarioViewController
            destination.scenarioController = scenarioController
        } else if segue.identifier == "multipleChoiceSegue" {
            let destination = segue.destination as! MultipleChoiceViewController
            destination.scenarioController = scenarioController
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

