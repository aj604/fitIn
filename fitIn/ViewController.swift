//
//  ViewController.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-06.
//  Copyright © 2017 group of 5. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    //Image View, Put Image HERE!
    @IBOutlet weak var imageView2: UIImageView!
    
    //Control Current Situation
    private var situationController = situationHandler()

    //User input
    @IBAction func proSocialPic(_ sender: UIButton) {
        situationController.voteProSocial()
        situationController.loadNextSituation()
    }
    @IBAction func antiSocialPic(_ sender: UIButton) {
        situationController.voteAntiSocial()
        situationController.loadNextSituation()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Try loading image data from first situation
        if let image = UIImage(data: situationController.loadSituationImageData()){
            imageView2.contentMode = .scaleAspectFit
            imageView2.image = image
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

