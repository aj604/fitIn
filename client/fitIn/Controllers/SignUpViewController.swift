//
//  SignUpViewController.swift
//  fitIn
//
//  Created by Aarish Kapila on 2017-10-30.
//  Copyright © 2017 group of 5. All rights reserved.
//  contributors: Vlad Polin, Scott Checko, Avery Jones, Aarish Kapila, Yanisa Chinitsarayos, Kevin Cheng
//  Known bugs:
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
    @IBOutlet var CreateNewUserVariable: UIButton!
    
    var inputValidationConditions: [Bool] = [true, true, true, true, true, true]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 80/255, green: 78/255, blue: 153/255, alpha: 1.0)
        CreateNewUserVariable.backgroundColor = UIColor.white
        CreateNewUserVariable.setTitleColor(UIColor.black, for: UIControlState.normal)
        CreateNewUserVariable.layer.borderWidth = 2
        CreateNewUserVariable.layer.borderColor = UIColor.black.cgColor
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func CreateNewUserFunction(_ sender: Any) {
        
        if (UserNameTextField.text!.count > 0)
        {
            if ((currentUser?.updateUsername(UserNameTextField.text!) == true))
            {
                UserNameTextField.textColor = UIColor.black
                inputValidationConditions[0] = true
            }
            else
            {
                UserNameTextField.textColor = UIColor.red
                CreateNewUserVariable.backgroundColor = UIColor(red: 204/255, green: 17/255, blue: 0/255, alpha: 1.0)
                
                inputValidationConditions[0] = false
            }
        }
        
        
        if (AgeTextField.text!.count > 0)
        {
            let temp = AgeTextField.text!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            
            if (temp == AgeTextField.text! && currentUser?.updateUserAge(Int(AgeTextField.text!)!) == true)
            {
                AgeTextField.textColor = UIColor.black
                inputValidationConditions[1] = true
            }
            else
            {
                AgeTextField.textColor = UIColor.red
                CreateNewUserVariable.backgroundColor = UIColor(red: 204/255, green: 17/255, blue: 0/255, alpha: 1.0)
                inputValidationConditions[1] = false
            }
        }
        
        if (EmailTextField.text!.count > 0)
        {
            if (currentUser?.updateEmailAddress(EmailTextField.text!) == true)
            {
                //userEditEmailAddressField must be more than 5 characters long, and must contain a "@" character
                //input has been validated at this point, but the constraints can be modified in the future
                EmailTextField.textColor = UIColor.black
                inputValidationConditions[2] = true
            }
            else
            {
                //input either is not long enough, or does not contain a "@" character
                //userEditProfileSaveChangesButton.setTitleColor(UIColor.red, for: UIControlState.normal)
                EmailTextField.textColor = UIColor.red
                CreateNewUserVariable.backgroundColor = UIColor(red: 204/255, green: 17/255, blue: 0/255, alpha: 1.0)
                inputValidationConditions[2] = false
            }
        }
        
        if (PasswordTextField.text!.count > 0 && ConfirmPasswordTextField.text!.count > 0  )
        {
            if (PasswordTextField.text!.count > 3 && ConfirmPasswordTextField.text!.count > 3 && PasswordTextField.text! == ConfirmPasswordTextField.text!)
            {
                currentUser?.passwordToken = PasswordTextField.text!
                PasswordTextField.textColor = UIColor.black
                ConfirmPasswordTextField.textColor = UIColor.black
                inputValidationConditions[3] = true
                
            }
            else
            {
                PasswordTextField.textColor = UIColor.red
                ConfirmPasswordTextField.textColor = UIColor.red
                CreateNewUserVariable.backgroundColor = UIColor(red: 204/255, green: 17/255, blue: 0/255, alpha: 1.0)
                inputValidationConditions[3] = false
            }
            
        }
        
        if (inputValidationConditions[0] == true && inputValidationConditions[1] == true && inputValidationConditions[2] == true && inputValidationConditions[3] == true && inputValidationConditions[4] == true && inputValidationConditions[5] == true) {
            //userEditProfileSaveChangesButton.setTitleColor(UIColor.green, for: UIControlState.normal)
            CreateNewUserVariable.backgroundColor = UIColor(red: 0/255, green: 155/255, blue: 77/255, alpha: 1.0)
            _ = dynamoHandler.putUserProfile(currentUser!)
            currentUser?.isUserLoggedIn = true
            
        }
        
        let email = EmailTextField.text!
        //var password = PasswordTextField.text!
        
        // TODO
        // add encryption to password
        
        currentUser?.emailAddress = email
        // currentUser?.passwordToken = password
        
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
                        //let alertController = UIAlertController(title: "FitIn", message: "user exists, try again", preferredStyle: UIAlertControllerStyle.alert)
                        //alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        //self.present(alertController, animated: true, completion: nil)
                        //AlertMessages("user exists, try again")
                        //dispatch_async(dispatch_get_main_queue(), {
                        
                        
                        //});
                        print("user exists, try again")
                        return AWSTask(error: NSError(domain: "", code: ErrorTypes.Exists.rawValue))
                    }
            })
            .continueWith(block:
                { (task) -> Void in
                    if(task.error == nil) {
                        //let alertController = UIAlertController(title: "FitIn", message: "success, new user", preferredStyle: UIAlertControllerStyle.alert)
                        //alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        //self.present(alertController, animated: true, completion: nil)
                        //AlertMessages("success, new user")
                        
                        print("success, new user")
                    } else {
                        //let alertController = UIAlertController(title: "FitIn", message: "failed to put", preferredStyle: UIAlertControllerStyle.alert)
                        //alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        //self.present(alertController, animated: true, completion: nil)
                        // AlertMessages("failed to put")
                        print("failed to put")
                    }
            })
        
        func AlertMessages (_ stringParameter: String)
        {
            let alertController = UIAlertController(title: "FitIn", message: stringParameter, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
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
