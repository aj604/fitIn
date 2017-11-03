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
        self.view.backgroundColor = UIColor(red: 80/255, green: 78/255, blue: 153/255, alpha: 1.0)
        /*userEditProfileButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        userEditProfileButton.layer.cornerRadius = 5
        userEditProfileButton.layer.borderWidth = 1
        userEditProfileButton.layer.borderColor = UIColor.white.cgColor*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //dynamoHandler.putUserProfile(UserProfile.current()!)
        loadUser()
    }
    
    func loadUser() {
        guard let currentUser = UserProfile.current() else { return }
        dynamoHandler
            .getUserProfile(currentUser.emailAddress)
            .continueWith(block:
                { (task) -> Void in
                    print("sucessfully finished user get with: ", task.result!.emailAddress)
                    if(currentUser.emailAddress == task.result!.emailAddress)
                    {
                        print("user matches")
                    }
            })
 
        //currentUser.userName = "test"
        userNameLabel.text = currentUser.userName
        userEmailAddressLabel.text = currentUser.emailAddress
        userAgeLabel.text = String(currentUser.userAge)
        userLifetimeLabel.text = String(currentUser.userLifetime)
        userNumScenariosCorrectLabel.text = String(currentUser.numScenariosCorrect)
        userNumScenariosAnsweredLabel.text = String(currentUser.numScenariosAnswered)
        userAverageResponseTimeLabel.text = String(currentUser.averageResponseTime)
        userProfilesLabel.textColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var userProfilesLabel: UILabel!
    @IBOutlet var userEditProfileButton: UIButton!
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
