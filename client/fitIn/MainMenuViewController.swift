//
//  MainMenuViewController.swift
//  fitIn
//
//  Created by Kevin C on 2017-11-15.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {


    @IBOutlet weak var toScenario: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toScenario.layer.cornerRadius = 3;
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
