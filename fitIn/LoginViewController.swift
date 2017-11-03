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
    var password: String = ""
    
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
        
        currentuser!.emailAddress = EmailTextField.text!
        password = PasswordFromLoginScreen.text!
        
        print(currentuser!.emailAddress, password)
        
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
