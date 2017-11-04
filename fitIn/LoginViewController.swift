//
//  LoginViewController.swift
//  fitIn
//
//  Created by Aarish Kapila on 2017-10-26.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //Variables
    var currentuser = UserProfile.current()
    //var password: String = ""
    
    //Outlets
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordFromLoginScreen: UITextField!
    
    
    //Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //UserLabel.text = String(describing: userProfile.current()?.userAge)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Action Outlets
    
    @IBAction func Login(_ sender: UIButton) {
        
        let email = EmailTextField.text!
        let password = PasswordFromLoginScreen.text!
        guard let currentUser = UserProfile.current() else { return }
        
        dynamoHandler
            .getUserProfile(email)
            .continueWith(block:
                { (task) -> Void in
                    if(task.result == nil)
                    {
                        currentUser.isUserLoggedIn = false
                        print("user does not exist in database")
                        return
                    }
                    else if (task.result != nil && task.result!.passwordToken == password)
                    {
                        currentUser.isUserLoggedIn = true
                        print("user has successfully logged in")
                        currentUser.emailAddress = task.result!.emailAddress
                        currentUser.userName = task.result!.userName
                        currentUser.userAge = task.result!.userAge
                        currentUser.userLifetime = task.result!.userLifetime
                        currentUser.numScenariosAnswered = task.result!.numScenariosAnswered
                        currentUser.numScenariosCorrect = task.result!.numScenariosCorrect
                        currentUser.averageResponseTime = task.result!.averageResponseTime
                        return
                    }
                    else
                    {
                        currentUser.isUserLoggedIn = false
                        print("user has failed to login")
                        return
                    }
            })
        //
        //The issue is that you cannot call modifications to text fields from the dynamo handler tasks, since they do not use the main thread
        //but by the time the dynamo task finishes the main thread attempts to evaluated the below statement and is not able to set
        //currently logging in and signing up works, but we have no UI to show this
        //
        /*if (didFinish == true && currentUser.isUserLoggedIn == false) {
            self.EmailTextField.textColor = UIColor.red
            self.PasswordFromLoginScreen.textColor = UIColor.red
        }*/
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
