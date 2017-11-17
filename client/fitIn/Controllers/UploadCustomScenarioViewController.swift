//
//  UploadCustomScenarioViewController.swift
//  fitIn
//
//  Created by Vlad Polin on 11/14/17.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import UIKit

class UploadCustomScenarioViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var placeholderScenarioImage: UIImageView!
    @IBOutlet weak var placeholderScenarioButton: UIButton!
    @IBOutlet weak var placeholderText: UITextView!
    var placeholderImage = UIImage()
    var hackyLabel = String()
    var hackyBoolean = Bool()
    var uploadCheck = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        placeholderScenarioImage.image = placeholderImage
        placeholderScenarioImage.layer.borderWidth = 5
        placeholderScenarioImage.layer.borderColor = UIColor.black.cgColor
        placeholderScenarioButton.setTitle("Tap here to choose an image!", for: UIControlState.normal)
        placeholderScenarioButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        placeholderText.delegate = self as! UITextViewDelegate
        placeholderText.text = nil
        placeholderText.text = "Tap here to start typing details of the scenario. Make sure you do this after you've chosen an image!"
        placeholderText.backgroundColor = UIColor(red: 226/255, green: 190/255, blue: 136/255, alpha: 1.0)
        placeholderText.layer.borderWidth = 3
        placeholderText.layer.borderColor = UIColor.brown.cgColor
        hackyBoolean = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if placeholderText.isFirstResponder == true {
            placeholderText.text = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func uploadScenarioButton(_ sender: Any) {
        let placeholderScenario = Scenario()
        placeholderScenario.scenarioID = String(arc4random())
        placeholderScenario.questionText = placeholderText.text
        switch hackyLabel {
            case "Running":
            uploadCheck = true
            placeholderScenario.imageLoc = URL(string: "https://wwwimg.skins.net/wysiwyg/mega_menu/sports-cat-Icons-M-Running.jpg")!
            case "Thinking":
            uploadCheck = true
            placeholderScenario.imageLoc = URL(string: "https://i.imgflip.com/1b9y1.jpg?a419112")!
            case "Walking":
            uploadCheck = true
            placeholderScenario.imageLoc = URL(string: "http://www.overcomeimpotence.net/wp-content/uploads/2010/02/walking.jpg")!
            case "Throwing":
            uploadCheck = true
            placeholderScenario.imageLoc = URL(string: "https://wpclipart.com/recreation/playing/throwing_water_balloon.png")!
            case "Looking":
            uploadCheck = true
            placeholderScenario.imageLoc = URL(string: "https://img.clipartxtras.com/5c8f810213e11c0d12b326c1ca74df18_clipart-eyes-looking-down-clipart-pie-cliparts-vectors-eyes-looking-down-clipart_278-258.jpeg")!
            case "Finding":
            uploadCheck = true
            placeholderScenario.imageLoc = URL(string: "http://kickofjoy.com/wp-content/uploads/2014/03/finding-talent.jpg")!
            default:
            uploadCheck = false
        }
        if (hackyBoolean == true && uploadCheck == true && placeholderText.text.count > 0) {
            dynamoHandler.putScenario(placeholderScenario)
            hackyBoolean = false
        }
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
