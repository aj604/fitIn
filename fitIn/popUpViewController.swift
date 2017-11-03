//
//  popUpViewController.swift
//  fitIn
//
//  Created by Kevin C on 2017-11-03.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import UIKit

class popUpViewController: UIViewController {

    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var closePopUpbutton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 10;
        popUpView.layer.masksToBounds = true;
        closePopUpbutton.layer.cornerRadius = 3;
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
