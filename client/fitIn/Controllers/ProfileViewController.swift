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
                    //gets the current user with the email address as a key, and populates appropriate entries of the userProfile object
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
        //and then assigns the entries to the appropriate labels that are displayed to the user
        userNameLabel.text = currentUser.userName
        userEmailAddressLabel.text = currentUser.emailAddress
        userAgeLabel.text = String(currentUser.userAge)
        userLifetimeLabel.text = String(currentUser.userLifetime)
        userNumScenariosCorrectLabel.text = String(currentUser.numScenariosCorrect)
        userNumScenariosAnsweredLabel.text = String(currentUser.numScenariosAnswered)
        userAverageResponseTimeLabel.text = String(currentUser.averageResponseTime)
        userProfilesLabel.textColor = UIColor.white
        
        //this gets the image data from the userProfile's imageLoc parameter, and then tries to upload it to the profilepicture
        currentUser.getImageData()
        if let image = UIImage(data: currentUser.imageData) {
            //image has successfully been grabbed
            print("image loaded")
            ProfilePic.contentMode = .scaleAspectFit
            ProfilePic.image = image
        }
        else {
            //something went wrong (perhaps a faulty URL)
            print("hmm something went wrong buffering the initial image")
        }
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
    @IBOutlet weak var ProfilePic: UIImageView!
    
}
