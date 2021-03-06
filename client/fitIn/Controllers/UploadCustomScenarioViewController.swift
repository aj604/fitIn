//
//  UploadCustomScenarioViewController.swift
//  fitIn
//
//  Created by Vlad Polin on 11/14/17.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import UIKit
import AWSS3
import Speech

class UploadCustomScenarioViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SFSpeechRecognizerDelegate {

    //set up variables for speeech rocognition
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    @IBOutlet weak var speechButton: UIButton!
    
    
    let placeholderScenario = Scenario()
    @IBOutlet weak var placeholderScenarioImage: UIImageView!
    @IBOutlet weak var placeholderScenarioButton: UIButton!
    @IBOutlet weak var placeholderText: UITextView!
    @IBOutlet weak var placeholderCloseButton: UIButton!
    @IBOutlet weak var placeholderSwitchOutput: UISwitch!
    
    var placeholderImage = UIImage()
    var hackyLabel = String()
    var hackyBoolean = Bool()
    var uploadCheck = Bool()
    var textFieldPlaceholderText = "Tap here to start typing details of the scenario. Make sure you do this after you've chosen an image!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Mostly UI elements are loaded here
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        placeholderScenarioImage.image = placeholderImage
        placeholderScenarioImage.layer.borderWidth = 5
        placeholderScenarioImage.layer.borderColor = UIColor.black.cgColor
        placeholderScenarioButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        placeholderText.delegate = self as UITextViewDelegate
        placeholderText.text = nil
        placeholderText.text = textFieldPlaceholderText
        placeholderText.backgroundColor = UIColor(red: 226/255, green: 190/255, blue: 136/255, alpha: 1.0)
        placeholderText.layer.borderWidth = 3
        placeholderText.layer.borderColor = UIColor.brown.cgColor
        hackyBoolean = true
        placeholderScenario.initialAnswer = 10
        navigationController?.setNavigationBarHidden(true, animated: true)
        if (hackyLabel == "Running" || hackyLabel == "Thinking" || hackyLabel == "Walking" || hackyLabel == "Throwing" || hackyLabel == "Looking" || hackyLabel == "Finding")
        {
            placeholderScenarioButton.setTitle("", for: UIControlState.normal)
        }
        else
        {
            placeholderScenarioButton.setTitle("Tap here to choose an image!", for: UIControlState.normal)
        }
        placeholderScenarioButton.frame = CGRect(origin: CGPoint(x: 45,y :108), size: CGSize(width: 318, height: 253))
        placeholderScenarioImage.frame = CGRect(origin: CGPoint(x: 45,y :108), size: CGSize(width: 318, height: 253))
        placeholderText.frame = CGRect(origin: CGPoint(x: 45,y :380), size: CGSize(width: 318, height: 150))
        placeholderSwitchOutput.frame = CGRect(origin: CGPoint(x: 320,y :565), size: CGSize(width: 318, height: 150))
        
        //set up speech recognition; ask for permission if user did not allow
        speechButton.isEnabled = false
        speechRecognizer?.delegate = self  //3
        SFSpeechRecognizer.requestAuthorization{ (authStatus) in
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            OperationQueue.main.addOperation() {
                self.speechButton.isEnabled = isButtonEnabled;
            }
            
        }
        
    }
    
    //functions for recording and stopping recordings of speech
    @IBAction func startRecord(_ sender: UIButton) {
        startRecording()
    }
    @IBAction func stopRecord(_ sender: UIButton?) {
        if audioEngine.isRunning{
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionRequest?.endAudio()
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //make sure that text being edited does not show the placeholder
        if placeholderText.isFirstResponder == true {
            placeholderText.text = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        //once user taps outside of field keyboard should be closed
    }

    @IBAction func uploadScenarioButton(_ sender: Any) {
        //let placeholderScenario = Scenario()
        placeholderScenario.scenarioID = String(arc4random())
        placeholderScenario.questionText = placeholderText.text
        ////////////////////////////////////////////////////////////////////////////////////////////////////
        //All images used are referenced using the following URLs and are used for educational purposes only
        //All images are used to demonstrated a proof of concept and may not be included in later prototypes
        ////////////////////////////////////////////////////////////////////////////////////////////////////
        switch hackyLabel {
            case "Running":
                uploadCheck = true
                placeholderScenario.imageLoc = URL(string: "https://www.shape.com/sites/shape.com/files/u896/man-running-stroller-emoji.jpg")!
                placeholderScenarioButton.setTitle("", for: UIControlState.normal)
            case "Thinking":
                uploadCheck = true
                placeholderScenario.imageLoc = URL(string: "https://t4.ftcdn.net/jpg/01/44/15/39/240_F_144153997_Pv0RGuMGsfi3tYHBULKLrq5w7Cz0sax8.jpg")!
                placeholderScenarioButton.setTitle("", for: UIControlState.normal)
            case "Walking":
                uploadCheck = true
                placeholderScenario.imageLoc = URL(string: "http://www.stencilease.com/gif/CC0079.jpg")!
                placeholderScenarioButton.setTitle("", for: UIControlState.normal)
            case "Throwing":
                uploadCheck = true
                placeholderScenario.imageLoc = URL(string: "https://cdn.patchcdn.com/users/321386/2015/04/T800x600/20150455311d2d0c7a4.png")!
                placeholderScenarioButton.setTitle("", for: UIControlState.normal)
            case "Looking":
                uploadCheck = true
                placeholderScenario.imageLoc = URL(string: "https://img.clipartxtras.com/5c8f810213e11c0d12b326c1ca74df18_clipart-eyes-looking-down-clipart-pie-cliparts-vectors-eyes-looking-down-clipart_278-258.jpeg")!
                placeholderScenarioButton.setTitle("", for: UIControlState.normal)
            case "Finding":
                uploadCheck = true
                placeholderScenario.imageLoc = URL(string: "http://kickofjoy.com/wp-content/uploads/2014/03/finding-talent.jpg")!
                placeholderScenarioButton.setTitle("", for: UIControlState.normal)
            case "PHOTO IMPORT":
                uploadCheck = true
                //print(placeholderScenario.imageLoc = URL(string: (s3Handler.uploadImage(scenario: placeholderScenario).result?.string)!)!)
                placeholderScenarioButton.setTitle("", for: UIControlState.normal)
            default:
                //user has not chosen an image yet, so present appropriate warning
                let alertController = UIAlertController(title: "Upload Failure", message: "Please select an image above.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                uploadCheck = false
        }
        if (hackyBoolean == true && uploadCheck == true && placeholderText.text.count > 0 && placeholderText.text != textFieldPlaceholderText) {
            s3Handler.uploadImage(scenario: placeholderScenario).continueWith(block: {
                (task: AWSTask<StupidStringObject>) -> Void in
                if let error = task.error {
                    print("failed put request to bucket. Error: \(error)")
                }
                else if let obj = task.result {
                    self.placeholderScenario.imageLoc = URL(string: obj.string)!
                    print(obj.string)
                }
            })
            _ = dynamoHandler.putScenario(placeholderScenario)
            hackyBoolean = false
            let alertController = UIAlertController(title: "Upload Complete", message: "Your scenario has been uploaded successfully!", preferredStyle: .alert)
            // Add Options to Alert
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
                self.segueToMain()
            }))
            // Show Alert View
            self.present(alertController, animated: true, completion: nil)
        }
        else if (hackyBoolean == true && uploadCheck == true && placeholderText.text == textFieldPlaceholderText) {
            //user has successfully chosen an image, but has not entered text, so present appropriate warning
            let alertController = UIAlertController(title: "Upload Failure", message: "Please describe your scenario in the text box above.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                let bestString = result?.bestTranscription.formattedString
                self.placeholderText.text = bestString
                isFinal = (result?.isFinal)!
                }
            
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        
    }
    
    func segueToMain() -> Void{
        //temporary "solution" to segue into main menu
        placeholderCloseButton.sendActions(for: UIControlEvents.touchUpInside)
    }
    
    @IBAction func switchClicked(_ sender: UISwitch) {
        if (sender.isOn == true) {
            placeholderScenario.initialAnswer = 10
        }
        else {
            sender.tintColor = UIColor.red
            sender.layer.cornerRadius = 16
            sender.backgroundColor = UIColor.red
            placeholderScenario.initialAnswer = 0
        }
    }
    @IBAction func closeAction(_ sender: Any) {
        //navigationController?.setNavigationBarHidden(false, animated: true)
        self.performSegue(withIdentifier:"uploadScenarioToMain", sender:self)
        //Currently closing the upload scenario or finishing an upload WILL redirect the user back to the main menu
    }
    
    
    @IBAction func importImageButton(_ sender: Any) {
        //function to import the image from the device
        hackyLabel = "PHOTO IMPORT"
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true) {
            //after image is complete
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            placeholderScenarioImage.image = image
        }
        else {
            //error message with uploading image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cameraPickerController(_ sender: Any) {
        hackyLabel = "PHOTO IMPORT"
        let image = UIImagePickerController()
        image.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            image.sourceType = .camera
            //safety clause for simulation since camera is not enabled unless on a device
        }
        else {
            image.sourceType = .photoLibrary
            //safety clause for simulation since camera is not enabled unless on a device
        }
        image.allowsEditing = false
        self.present(image, animated: true) {
            //after image is complete
        }
    }

}
