//
//  ProfileViewController.swift
//  fitIn
//
//  Created by Vlad Polin on 10/25/17.
//  Copyright © 2017 group of 5. All rights reserved.
//  contributors: Vlad Polin
//  Known bugs:
//              - 

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(red: 80/255, green: 78/255, blue: 153/255, alpha: 1.0)
        /*userEditProfileButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        userEditProfileButton.layer.cornerRadius = 5
        userEditProfileButton.layer.borderWidth = 1
        userEditProfileButton.layer.borderColor = UIColor.white.cgColor*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.navigationItem.title = "Profile Information"
        loadUser()
    }
    
    func segueToLogin() -> Void{
        performSegue(withIdentifier: "forceLoginSegue", sender: self)
        //temporary "solution" to segue into login screen when user is not logged in
    }
    
    func loadUser() {
        guard let currentUser = UserProfile.current() else { return }
        //currentUser.userName = "test"
        if (currentUser.isUserLoggedIn == false) {
            //https://code.tutsplus.com/tutorials/ios-fundamentals-uialertview-and-uialertcontroller--cms-24038
            //https://stackoverflow.com/questions/26956016/cancel-button-in-uialertcontroller-with-uialertcontrollerstyleactionsheet
            // Initialize Alert View
            let alertController = UIAlertController(title: "Validation Error", message: "Please login or sign up with an account.", preferredStyle: .alert)
            // Add Options to Alert
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
                self.segueToLogin()
            }))
            // Show Alert View
            self.present(alertController, animated: true, completion: nil)
        }
        if (currentUser.isUserLoggedIn == true)
        {
            dynamoHandler
            .getUserProfile(currentUser.emailAddress)
            .continueWith(block:
            { (task) -> Void in
                print("sucessfully finished user get with: ", currentUser.emailAddress)
                if(currentUser.emailAddress == task.result?.emailAddress)
                {
                    print("user matches")
                    currentUser.emailAddress = task.result!.emailAddress
                    currentUser.userName = task.result!.userName
                    currentUser.userAge = task.result!.userAge
                    currentUser.userLifetime = task.result!.userLifetime
                    currentUser.numScenariosAnswered = task.result!.numScenariosAnswered
                    currentUser.numScenariosCorrect = task.result!.numScenariosCorrect
                    currentUser.averageResponseTime = task.result!.averageResponseTime
                }
            })
        }
        userNameLabel.text = currentUser.userName
        userEmailAddressLabel.text = currentUser.emailAddress
        userAgeLabel.text = String(currentUser.userAge)
        userLifetimeLabel.text = String(currentUser.userLifetime)
        userNumScenariosCorrectLabel.text = String(currentUser.numScenariosCorrect)
        userNumScenariosAnsweredLabel.text = String(currentUser.numScenariosAnswered)
        userAverageResponseTimeLabel.text = String(currentUser.averageResponseTime)
        userProfilesLabel.textColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var userProfilesLabel: UILabel!
    @IBOutlet var userEditProfileButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailAddressLabel: UILabel!
    @IBOutlet weak var userAgeLabel: UILabel!
    @IBOutlet weak var userLifetimeLabel: UILabel!
    @IBOutlet weak var userNumScenariosCorrectLabel: UILabel!
    @IBOutlet weak var userNumScenariosAnsweredLabel: UILabel!
    @IBOutlet weak var userAverageResponseTimeLabel: UILabel!
    
    
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "forceLoginSegue" {
            let destination = segue.destination as? LoginViewController
            destination?.scenarioController = scenarioController
        }
        if segue.identifier == "profileEditSegue" {
            let navigationDestination = segue.destination as? UINavigationController
            let destination = navigationDestination?.topViewController as? ProfileEditViewController
            destination?.scenarioController = scenarioController
        }
    }*/
    

}
