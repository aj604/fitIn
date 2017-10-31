//
//  ProfileViewController.swift
//  fitIn
//
//  Created by Vlad Polin on 10/25/17.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUser()
    }
    
    func loadUser() {
        guard let currentUser = userProfile.current() else { return }
        //currentUser.userName = "test"
        userNameLabel.text = currentUser.userName
        userEmailAddressLabel.text = currentUser.emailAddress
        userAgeLabel.text = String(currentUser.userAge)
        userLifetimeLabel.text = String(currentUser.userLifetime)
        userNumScenariosCorrectLabel.text = String(currentUser.numScenariosCorrect)
        userNumScenariosAnsweredLabel.text = String(currentUser.numScenariosAnswered)
        userAverageResponseTimeLabel.text = String(currentUser.averageResponseTime)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailAddressLabel: UILabel!
    @IBOutlet weak var userAgeLabel: UILabel!
    @IBOutlet weak var userLifetimeLabel: UILabel!
    @IBOutlet weak var userNumScenariosCorrectLabel: UILabel!
    @IBOutlet weak var userNumScenariosAnsweredLabel: UILabel!
    @IBOutlet weak var userAverageResponseTimeLabel: UILabel!

    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
