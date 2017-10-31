//
//  LoginViewController.swift
//  fitIn
//
//  Created by Aarish Kapila on 2017-10-26.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UserLabel.text = String(describing: userProfile.current()?.userAge)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          //loadUser()
    }
    
    
    func loadUser() {
                //guard let currentUser = userProfile.current() else { return }
                //currentUser.userName = "test"
               //UserLabel.text = currentUser.userName
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
