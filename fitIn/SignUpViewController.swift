//
//  SignUpViewController.swift
//  fitIn
//
//  Created by Aarish Kapila on 2017-10-30.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var currentUser = userProfile.current()

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
    
    @IBAction func UpdateInformationOnDatabase(_ sender: Any) {
        
        currentUser?.emailAddress = EmailTextField.text!
        currentUser?.userName = UserNameTextField.text!
        currentUser?.userAge = Int(AgeTextField.text!)!
        print(currentUser!.emailAddress)
        print(currentUser!.userAge)
        print(currentUser!.userName)
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
