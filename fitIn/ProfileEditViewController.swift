//
//  ProfileEditViewController.swift
//  fitIn
//
//  Created by Vlad Polin on 10/26/17.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.navigationItem.title = "Profile Modification"
        //self.view.backgroundColor = UIColor(red: 80/255, green: 78/255, blue: 153/255, alpha: 1.0)
        editYourProfileLabel.textColor = UIColor.white
        editYourProfileLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 28)
        /*userEditProfileSaveChangesButton.backgroundColor = UIColor.white
        userEditProfileSaveChangesButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        userEditProfileSaveChangesButton.layer.borderWidth = 2
        userEditProfileSaveChangesButton.layer.borderColor = UIColor.black.cgColor*/
        userEditProfileSaveChangesButton.backgroundColor = UIColor(patternImage: UIImage(named: "save_changes_default.png")!)
        guard let currentUser = UserProfile.current() else { return }
        if (currentUser.isUserLoggedIn == true) {
            userEditUsernameField.placeholder = currentUser.userName
            userEditAgeField.placeholder = String(currentUser.userAge)
        }
        else {
            userEditUsernameField.placeholder = "Please login to use this feature."
            userEditAgeField.placeholder = "Please login to use this feature."
            userEditUsernameField.isUserInteractionEnabled = false
            userEditAgeField.isUserInteractionEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    @IBOutlet weak var userEditUsernameIcon: UIImageView!
    @IBOutlet weak var userEditAgeIcon: UIImageView!
    @IBOutlet var userEditUsernameField: UITextField!
    @IBOutlet var userEditAgeField: UITextField!
    @IBOutlet var userEditProfileSaveChangesButton: UIButton!
    @IBOutlet var editYourProfileLabel: UILabel!
    
    var inputValidationConditions: [Bool] = [true, true, true, true]
    //this is the array which validates that all inputs across the board have been validated
    //element 0 is for username, element 1 is for email address, element 2 is for age, element 3 will be for password
    
    @IBAction func userEditProfileSaveChanges(_ sender: Any) {
        if (userEditUsernameField.text!.count > 0 && UserProfile.current()?.isUserLoggedIn == true) {
            if (UserProfile.current()?.updateUsername(userEditUsernameField.text!) == true) {
                userEditUsernameField.textColor = UIColor.black
                userEditUsernameIcon.backgroundColor = UIColor(patternImage: UIImage(named: "right.png")!)
                inputValidationConditions[0] = true
            }
            else {
                //userEditProfileSaveChangesButton.setTitleColor(UIColor.red, for: UIControlState.normal)
                userEditUsernameField.textColor = UIColor.red
                //userEditProfileSaveChangesButton.backgroundColor = UIColor(red: 204/255, green: 17/255, blue: 0/255, alpha: 1.0)
                userEditProfileSaveChangesButton.backgroundColor = UIColor(patternImage: UIImage(named: "savechanges_Red.png")!)
                userEditUsernameIcon.backgroundColor = UIColor(patternImage: UIImage(named: "cross.png")!)
                //https://code.tutsplus.com/tutorials/ios-fundamentals-uialertview-and-uialertcontroller--cms-24038
                //https://stackoverflow.com/questions/26956016/cancel-button-in-uialertcontroller-with-uialertcontrollerstyle-actionsheet
                // Initialize Alert View
                let alertController = UIAlertController(title: "Validation Error", message: "Please enter a username longer than 5 characters and without profanity.", preferredStyle: .alert)
                // Add Options to Alert
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                // Show Alert View
                self.present(alertController, animated: true, completion: nil)
                inputValidationConditions[0] = false
            }
        }
        /*if (userEditEmailAddressField.text!.count > 0) {
            if (UserProfile.current()?.updateEmailAddress(userEditEmailAddressField.text!) == true) {
            //userEditEmailAddressField must be more than 5 characters long, and must contain a "@" character
            //input has been validated at this point, but the constraints can be modified in the future
                userEditEmailAddressField.textColor = UIColor.black
                inputValidationConditions[1] = true
            }
            else {
                //input either is not long enough, or does not contain a "@" character
                //userEditProfileSaveChangesButton.setTitleColor(UIColor.red, for: UIControlState.normal)
                userEditEmailAddressField.textColor = UIColor.red
                userEditProfileSaveChangesButton.backgroundColor = UIColor(red: 204/255, green: 17/255, blue: 0/255, alpha: 1.0)
                inputValidationConditions[1] = false
            }
        }*/
        if (userEditAgeField.text!.count > 0 && UserProfile.current()?.isUserLoggedIn == true) {
            //userEditAgeField must only contain numbers and no spaces
            //users must be between the ages of 1-200
            let temp = userEditAgeField.text!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            //https://stackoverflow.com/questions/34354740/how-do-you-confirm-a-string-only-contains-numbers-in-swift
            if (temp == userEditAgeField.text! && UserProfile.current()?.updateUserAge(Int(userEditAgeField.text!)!) == true) {
                //input has been validated to contain #s only and they ARE between 1 and 200, so change colour of buttons and fields and update user's age
                userEditAgeField.textColor = UIColor.black
                userEditAgeIcon.backgroundColor = UIColor(patternImage: UIImage(named: "right.png")!)
                inputValidationConditions[2] = true
            }
            else {
                //input either contains an illegal character or is NOT between 1 and 200, so change colour of butons and fields
                //userEditProfileSaveChangesButton.setTitleColor(UIColor.red, for: UIControlState.normal)
                userEditAgeField.textColor = UIColor.red
                //userEditProfileSaveChangesButton.backgroundColor = UIColor(red: 204/255, green: 17/255, blue: 0/255, alpha: 1.0)
                userEditProfileSaveChangesButton.backgroundColor = UIColor(patternImage: UIImage(named: "savechanges_Red.png")!)
                userEditAgeIcon.backgroundColor = UIColor(patternImage: UIImage(named: "cross.png")!)
                //https://code.tutsplus.com/tutorials/ios-fundamentals-uialertview-and-uialertcontroller--cms-24038
                //https://stackoverflow.com/questions/26956016/cancel-button-in-uialertcontroller-with-uialertcontrollerstyle-actionsheet
                // Initialize Alert View
                let alertController = UIAlertController(title: "Validation Error", message: "Please enter an age between 1 and 200.", preferredStyle: .alert)
                // Add Options to Alert
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                // Show Alert View
                self.present(alertController, animated: true, completion: nil)
                inputValidationConditions[2] = false
            }
        }
        if (inputValidationConditions[0] == true && inputValidationConditions[1] == true && inputValidationConditions[2] == true && UserProfile.current()?.isUserLoggedIn == true) {
            //userEditProfileSaveChangesButton.setTitleColor(UIColor.green, for: UIControlState.normal)
            //userEditProfileSaveChangesButton.backgroundColor = UIColor(red: 0/255, green: 155/255, blue: 77/255, alpha: 1.0)
            userEditProfileSaveChangesButton.backgroundColor = UIColor(patternImage: UIImage(named: "savechanges_green.png")!)
            //https://code.tutsplus.com/tutorials/ios-fundamentals-uialertview-and-uialertcontroller--cms-24038
            //https://stackoverflow.com/questions/26956016/cancel-button-in-uialertcontroller-with-uialertcontrollerstyle-actionsheet
            // Initialize Alert View
            let alertController = UIAlertController(title: "Modification Success", message: "Your changes have been saved correctly.", preferredStyle: .alert)
            // Add Options to Alert
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            // Show Alert View
            self.present(alertController, animated: true, completion: nil)
            dynamoHandler.putUserProfile(UserProfile.current()!)
        }
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
