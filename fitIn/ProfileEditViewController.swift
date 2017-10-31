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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet var userEditUsernameField: UITextField!
    @IBOutlet var userEditEmailAddressField: UITextField!
    @IBOutlet var userEditAgeField: UITextField!
    
    /*@IBAction func UserEditProfileSaveChanges(_ sender: Any) {
        if (UserEditEmailAddressField.text!.count >= 5) {
            //email addresses must be more than 4 characters long "a.com"
            userProfile.current()?.updateEmailAddress(UserEditEmailAddressField.text!)
        }
        /*if (UserEditUsernameField.text!.count >= 0) {
            userProfile.current()?.updateUsername(UserEditUsernameField.text!)
        }*/
    }*/
    
    @IBAction func userEditProfileSaveChanges(_ sender: Any) {
        if (userEditUsernameField.text!.count > 0) {
            userProfile.current()?.updateUsername(userEditUsernameField.text!)
        }
        if (userEditEmailAddressField.text!.count > 0) {
            userProfile.current()?.updateEmailAddress(userEditEmailAddressField.text!)
        }
        if (userEditAgeField.text!.count > 0) {
            userProfile.current()?.updateUserAge(Int(userEditAgeField.text!)!)
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
