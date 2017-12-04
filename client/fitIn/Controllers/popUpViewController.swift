//
//  popUpViewController.swift
//  fitIn
//
//  Created by Kevin C on 2017-11-03.
//  Copyright © 2017 group of 5. All rights reserved.
//  contributors: Kevin Cheng
//  Known bugs:
//              - 

import UIKit

class popUpViewController: UIViewController {


    
    //button to close pop up
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //outlets
    @IBOutlet weak var closePopUpbutton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerReasoning: UILabel!
    
    var passedReasoning = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //round corners for labels/pop up
        popUpView.layer.cornerRadius = 10;
        popUpView.layer.masksToBounds = true;
        closePopUpbutton.layer.cornerRadius = 3;
        answerLabel.layer.cornerRadius = 3;
        answerLabel.clipsToBounds = true;
        answerReasoning.layer.cornerRadius = 3;
        answerReasoning.clipsToBounds = true;
        answerReasoning.text = "Sorry, you are incorrect.";

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
