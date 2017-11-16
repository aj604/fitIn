//
//  MustLoginPopupViewController.swift
//  fitIn
//
//  Created by Kevin C on 2017-11-15.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import UIKit

class MustLoginPopupViewController: UIViewController {

    //add labels for texts and buttons
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var mainText: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        //round buttons and view and text
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 10;
        popUpView.layer.masksToBounds = true;
        mainText.layer.cornerRadius = 3;
        closeButton.layer.cornerRadius=20;

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
