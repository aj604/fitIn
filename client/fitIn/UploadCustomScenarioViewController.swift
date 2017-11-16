//
//  UploadCustomScenarioViewController.swift
//  fitIn
//
//  Created by Vlad Polin on 11/14/17.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import UIKit

class UploadCustomScenarioViewController: UIViewController {

    @IBOutlet weak var placeholderScenarioImage: UIImageView!
    @IBOutlet weak var placeholderScenarioButton: UIButton!
    var placeholderImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //placeholderScenarioButton.backgroundImage(for: UIControlState.normal) = placeholderImage
        //placeholderScenarioButton.imageView?.image = placeholderImage
        //placeholderScenarioButton.setImage(placeholderImage, for: UIControlState.normal)
        placeholderScenarioImage.image = placeholderImage
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
