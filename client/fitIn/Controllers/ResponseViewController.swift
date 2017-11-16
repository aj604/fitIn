//
//  responseViewController.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-25.
//  Copyright © 2017 group of 5. All rights reserved.
//  contributors: Avery Jones
//  Known bugs:
//              - 

import UIKit

class ResponseViewController : UIViewController {

//responseViewController represents the contained controller view within ScenarioViewController
//Contains 3 distinct type of inputs for questions.
    
//Although it appears that there are a bunch of buttons, only the ones pertaining to the input format of the current
// scenario will be visible at any one time.

    //MARK: Button Outlets
    @IBOutlet weak var antiSocialButton: UIButton!
    @IBOutlet weak var proSocialButton: UIButton!
    @IBOutlet weak var sliderBar: UISlider!
    @IBOutlet weak var sliderSubmit: UIButton!
    @IBOutlet weak var multipleChoiceA: UIButton!
    @IBOutlet weak var multipleChoiceB: UIButton!
    @IBOutlet weak var multipleChoiceC: UIButton!
    @IBOutlet weak var multipleChoiceD: UIButton!
    
    // MARK: Members
    var situationType : Scenario.ScenarioType?
    var inputAnswer : Int?
    
    // MARK: Appearence Funcs
    private func enableYesNo() {
        antiSocialButton.isHidden = false
        proSocialButton.isHidden = false
    }
    private func disableYesNo(){
        antiSocialButton.isHidden = true
        proSocialButton.isHidden = true
    }
    private func enableSlider(){
        sliderBar.isHidden = false
        sliderSubmit.isHidden = false
    }
    private func disableSlider() {
        sliderBar.isHidden = true
        sliderSubmit.isHidden = true
    }
    private func enableMultipleChoice(){
        multipleChoiceA.isHidden = false
        multipleChoiceB.isHidden = false
        multipleChoiceC.isHidden = false
        multipleChoiceD.isHidden = false
    }
    private func disableMultipleChoice(){
        multipleChoiceA.isHidden = true
        multipleChoiceB.isHidden = true
        multipleChoiceC.isHidden = true
        multipleChoiceD.isHidden = true
    }
    
    // This function sets the UI for the type of expected input
    private func updateUI() {
        if let unwrap = situationType {
            switch unwrap{
            case .yesOrNo:
                enableYesNo()
                disableSlider()
                disableMultipleChoice()
            case .multipleChoice:
                enableMultipleChoice()
                disableSlider()
                disableYesNo()
            case .slider:
                enableSlider()
                disableYesNo()
                disableMultipleChoice()
            }
        }
    }
    
    // MARK: UI Funcs
    @IBAction func picIsAntiSocial(_ sender: UIButton) {
        inputAnswer = 0
        
    }
    @IBAction func picIsProSocial(_ sender: UIButton) {
        inputAnswer = 1
    }
    @IBAction func multipleChoiceA(_ sender: UIButton) {
        inputAnswer = 0
    }
    @IBAction func multipleChoiceB(_ sender: UIButton) {
        inputAnswer = 1
    }
    @IBAction func multipleChoiceC(_ sender: UIButton) {
        inputAnswer = 2
    }
    @IBAction func multipleChoiceD(_ sender: UIButton) {
        inputAnswer = 3
    }
    @IBAction func submitSlider(_ sender: UIButton) {
        inputAnswer = Int(sliderBar.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
