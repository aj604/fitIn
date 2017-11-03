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
        
        self.view.backgroundColor = UIColor(red: 80/255, green: 78/255, blue: 153/255, alpha: 1.0)
        editYourProfileLabel.textColor = UIColor.white
        editYourProfileLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 28)
        userEditProfileSaveChangesButton.backgroundColor = UIColor.white
        userEditProfileSaveChangesButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        userEditProfileSaveChangesButton.layer.borderWidth = 2
        userEditProfileSaveChangesButton.layer.borderColor = UIColor.black.cgColor
        guard let currentUser = UserProfile.current() else { return }
        userEditUsernameField.placeholder = currentUser.userName
        userEditEmailAddressField.placeholder = currentUser.emailAddress
        userEditAgeField.placeholder = String(currentUser.userAge)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var userEditUsernameField: UITextField!
    @IBOutlet var userEditEmailAddressField: UITextField!
    @IBOutlet var userEditAgeField: UITextField!
    @IBOutlet var userEditProfileSaveChangesButton: UIButton!
    @IBOutlet var editYourProfileLabel: UILabel!
    
    var inputValidationConditions: [Bool] = [true, true, true, true]
    //this is the array which validates that all inputs across the board have been validated
    //element 0 is for username, element 1 is for email address, element 2 is for age, element 3 will be for password
    
    func containsSwearWord(text: String, swearWords: [String]) -> Bool {
        return swearWords
            .reduce(false) { $0 || text.contains($1.lowercased()) }
    }
    //https://stackoverflow.com/questions/38185917/swift-how-to-censor-filter-text-entered-for-swear-words-etc
    let listOfSwearWords = ["fuck", "shit", "crap", "bitch", "cunt", "slut"]
    //feel free to add any that I may have missed @ groupmates :)
    
    @IBAction func userEditProfileSaveChanges(_ sender: Any) {
        if (userEditUsernameField.text!.count > 0) {
            //userEditUsernameField must be more than 5 characters long and must not contain profanity, detailed in listofSwearWords array
            //unfortunately it does not distinguish case insensitive usernames, but I will leave this for now as username format needs to be discussed
            //https://stackoverflow.com/questions/38185917/swift-how-to-censor-filter-text-entered-for-swear-words-etc
            if (userEditUsernameField.text!.count > 5 && (containsSwearWord(text: userEditUsernameField.text!, swearWords: listOfSwearWords) == false)) {
                UserProfile.current()?.updateUsername(userEditUsernameField.text!)
                userEditUsernameField.textColor = UIColor.black
                inputValidationConditions[0] = true
            }
            else {
                //userEditProfileSaveChangesButton.setTitleColor(UIColor.red, for: UIControlState.normal)
                userEditUsernameField.textColor = UIColor.red
                userEditProfileSaveChangesButton.backgroundColor = UIColor(red: 204/255, green: 17/255, blue: 0/255, alpha: 1.0)
                
                inputValidationConditions[0] = false
            }
        }
        if (userEditEmailAddressField.text!.count > 0) {
            if (userEditEmailAddressField.text!.count > 5 && userEditEmailAddressField.text!.range(of:"@") != nil) {
            //userEditEmailAddressField must be more than 5 characters long, and must contain a "@" character
            //input has been validated at this point, but the constraints can be modified in the future
                UserProfile.current()?.updateEmailAddress(userEditEmailAddressField.text!)
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
        }
        if (userEditAgeField.text!.count > 0) {
            //userEditAgeField must only contain numbers and no spaces
            //users must be between the ages of 1-200
            let temp = userEditAgeField.text!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            //https://stackoverflow.com/questions/34354740/how-do-you-confirm-a-string-only-contains-numbers-in-swift
            if (temp == userEditAgeField.text! && (Int(userEditAgeField.text!)! >= 1 && Int(userEditAgeField.text!)! <= 200)) {
                //input has been validated to contain #s only and they ARE between 1 and 200, so change colour of buttons and fields and update user's age
                UserProfile.current()?.updateUserAge(Int(userEditAgeField.text!)!)
                userEditAgeField.textColor = UIColor.black
                inputValidationConditions[2] = true
            }
            else {
                //input either contains an illegal character or is NOT between 1 and 200, so change colour of butons and fields
                //userEditProfileSaveChangesButton.setTitleColor(UIColor.red, for: UIControlState.normal)
                userEditAgeField.textColor = UIColor.red
                userEditProfileSaveChangesButton.backgroundColor = UIColor(red: 204/255, green: 17/255, blue: 0/255, alpha: 1.0)
                inputValidationConditions[2] = false
            }
        }
        if (inputValidationConditions[0] == true && inputValidationConditions[1] == true && inputValidationConditions[2] == true) {
            //userEditProfileSaveChangesButton.setTitleColor(UIColor.green, for: UIControlState.normal)
            userEditProfileSaveChangesButton.backgroundColor = UIColor(red: 0/255, green: 155/255, blue: 77/255, alpha: 1.0)
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
