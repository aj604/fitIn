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
        let userClass = userProfile.current()
        userProfile.current()?.updateNumScenariosCorrect(3)
        userClass?.updateNumScenariosCorrect(3)
        // Do any additional setup after loading the view.
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
