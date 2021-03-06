//
//  MainMenuViewController.swift
//  fitIn
//
//  Created by Kevin C on 2017-11-15.
//  Copyright © 2017 AJ productions. All rights reserved.
//
import UIKit

class MainMenuViewController: UIViewController {
    
    var currentUser = UserProfile.current()
    
    //add outlets for buttons
    @IBOutlet weak var toScenario: UIButton!
    @IBOutlet weak var toLogin: UIButton!
    @IBOutlet weak var toUpload: UIButton!
    @IBOutlet weak var toViewProfile: UIButton!
    @IBOutlet weak var toScenarioHistory: UIButton!
    
    //add segue for viewing profile
    @IBAction func viewProfile(_ sender: Any) {
        if (currentUser!.isUserLoggedIn) {
            self.performSegue(withIdentifier: "MainMenuToViewProfileSegue", sender:self);
        }
        else{
            self.performSegue(withIdentifier:"MainMenuMustLoginPopupSegue", sender:self);
        }
    }
    //add segue for uploading scenarios
    @IBAction func toHistory(_ sender: Any) {
    }
    @IBAction func uploadScenario(_ sender: Any) {
        //add conditional to disable upload if user isnt logged in
        if (currentUser!.isUserLoggedIn) {
            self.performSegue(withIdentifier: "MainMenuToUploadScenarioSegue", sender:self);
        }
        else{
            self.performSegue(withIdentifier:"MainMenuMustLoginPopupSegue", sender:self);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //round buttons
        navigationController?.setNavigationBarHidden(true, animated: true)
        toScenario.layer.cornerRadius = 3
        toLogin.layer.cornerRadius = 3
        toUpload.layer.cornerRadius = 3
        toViewProfile.layer.cornerRadius = 3
        toScenarioHistory.layer.cornerRadius = 3
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "historySegue"{
            let navigationDestination = segue.destination as! UINavigationController
            let destination = navigationDestination.topViewController as? ScenarioTableViewController
            destination?.scenarioController = self.scenarioController
            destination?.user = currentUser!
        }
        if segue.identifier == "scenarioFromMenuSegue" {
            /* INSERT IF STATEMENT HERE TO DECIDE WHICH SCENARIO TO SEGUE TO */
            let destination = segue.destination as? ScenarioViewController
            destination?.scenarioController = self.scenarioController
        }
        if segue.identifier == "MainMenuToViewProfileSegue" {
            let destination = segue.destination as? ProfileViewController
            destination?.scenarioController = scenarioController
        }
        if segue.identifier == "MainMenuToUploadScenarioSegue" {
            let destination = segue.destination as? UploadCustomScenarioViewController
            destination?.scenarioController = scenarioController
        }
        if segue.identifier == "mainMenuToLoginSegue" {
            let destination = segue.destination as? LoginViewController
            destination?.scenarioController = scenarioController
        }
     }*/
}
