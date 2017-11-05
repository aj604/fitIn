//
//  SignUpViewController.swift
//  fitIn
//
//  Created by Aarish Kapila on 2017-10-30.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import UIKit
import AWSDynamoDB

class SignUpViewController: UIViewController {
    
    var currentUser = UserProfile.current()

    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var AgeTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ConfirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AddUserButton(_ sender: Any) {
      /*
        currentUser?.emailAddress = EmailTextField.text!
        currentUser?.userName = UserNameTextField.text!
        currentUser?.userAge = Int(AgeTextField.text!)!
        print(currentUser!.emailAddress)
        print(currentUser!.userAge)
        print(currentUser!.userName)
        
        
        */

        let email = EmailTextField.text!
        let password = PasswordTextField.text!
        let temp = AgeTextField.text!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        //https://stackoverflow.com/questions/34354740/how-do-you-confirm-a-string-only-contains-numbers-in-swift
        if (temp == AgeTextField.text!) {
            //this returns a boolean so use this when displaying UI to validate input
            UserProfile.current()?.updateUserAge(Int(AgeTextField.text!)!)
        }
        else
        {
            //5 years old is the arbitrary default age
            UserProfile.current()?.userAge = 5
        }
        
        // TODO
        // add encryption to password

        UserProfile.current()!.emailAddress = email
        UserProfile.current()!.passwordToken = password
        //UserProfile.current()!.userAge = age
        
        dynamoHandler
            .getUserProfile(email)
            .continueWith(block:
                { (task) -> AWSTask<UserProfile> in
                    if(task.result == nil)
                    {
                        // user does not exist
                        return dynamoHandler.putUserProfile(UserProfile.current()!)
                    } else
                    {
                        print("user exists, try again")
                        return AWSTask(error: NSError(domain: "", code: ErrorTypes.Exists.rawValue))
                    }
                })
            .continueWith(block:
                { (task) -> Void in
                    if(task.error == nil) {
                        print("success, new user")
                    } else {
                        print("failed to put")
                    }
                })
        
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
