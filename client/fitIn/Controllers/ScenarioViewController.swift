//
//  ScenarioViewController.swift
//  fitIn
//
//  Created by Avery Jones on 2017-10-06.
//  Copyright © 2017 group of 5. All rights reserved.
//  contributors: Vlad Polin, Scott Checko, Avery Jones, Aarish Kapila, Yanisa Chinitsarayos, Kevin Cheng
//  Known bugs:
//  

import UIKit
import Speech

var startRecordBool = false;

class ScenarioViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    
    //Image View, Put Image HERE!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var questionDescription: UILabel!
    
    //voice recognition stuff
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var testbox: UITextView!
    @IBOutlet weak var detectedSpeech: UIView!
    
    //setup variables for speech recog
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    //Control Current Scenario
    //var scenarioController = ScenarioHandler()
    
    // Eventually this will be access point for subView
    //fileprivate var responseController : responseViewController
    
    let DISABLE_TIME = 0.5; //seconds
    //User input
    @IBAction func proSocialPic(_ sender: UIButton?) {
        sender?.isEnabled = false;

        Timer.scheduledTimer(withTimeInterval: DISABLE_TIME, repeats: false, block: {
            (timer: Timer) -> Void in
            sender?.isEnabled = true;
        })

        scenarioController.voteChoice = Scenario.ANSWER_YES
        //if user is incorrect, send to reasoning pop up
        if !userIsCorrect
        {
            self.performSegue(withIdentifier: "scenarioViewToReasoningPopup", sender:self);
        }
        scenarioController.loadNextScenario()
        updateUI()
    }

    @IBAction func antiSocialPic(_ sender: UIButton?) {
        sender?.isEnabled = false;
        Timer.scheduledTimer(withTimeInterval: DISABLE_TIME, repeats: false, block: {
            (timer: Timer) -> Void in
            sender?.isEnabled = true;
        })

        scenarioController.voteChoice = Scenario.ANSWER_NO
        //if user is incorrect, send to reasoning pop up
        if !userIsCorrect
        {
            self.performSegue(withIdentifier: "scenarioViewToReasoningPopup", sender:self);
        }
        scenarioController.loadNextScenario()
        updateUI()
    }
    @IBAction func startRecord(_ sender: UIButton) {
        voiceButton.backgroundColor = UIColor.green
        startRecordBool = true;
        startRecording()
    }
    @IBAction func stopRecord(_ sender: UIButton?) {
        voiceButton.setTitle("Voice Recognition", for : .normal)
        voiceButton.backgroundColor = UIColor.white;
        if audioEngine.isRunning{
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionRequest?.endAudio()
        }
    }
    

    //function to check whether speech recognizied is trigger word
    func isTrigger( word: String) -> Bool {
        switch word.lowercased() {
        case "prosocial", "yes":
            proSocialPic(nil)
            return true;
        case "antisocial", "no":
            antiSocialPic(nil)
            return true;
        default:
            break
        }
        return false;
    }
    
    //function to handle specch recognition
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
            
            if result != nil && startRecordBool {
                let bestString = result?.bestTranscription.formattedString
                self.testbox.text = bestString
                self.testbox.text = "Detected speech: " + self.testbox.text
                
                var lastString: String = ""
                //look through every word in detected speech, looking for keywords
                for segment in (result?.bestTranscription.segments)! {
                    let indexTo = bestString?.index((bestString?.startIndex)!, offsetBy: segment.substringRange.location)
                    lastString = (bestString?.substring(from: indexTo!))!
                }
                
                if self.isTrigger(word: lastString) {
                    isFinal = true;
                    self.stopRecord(nil)
                    startRecordBool = false
                }
                 //= result?.bestTranscription.formattedString
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
        
        voiceButton.setTitle("Listening", for : .normal)
        
    }

 

    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        self.proSocialPic(UIButton())
    }
    
    @IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        self.antiSocialPic(UIButton())
    }
    
    
    // Update the UI to represent the change in Scenario
    // Once different response views are set they can be set here
    func updateUI() {
        if let image = UIImage(data: scenarioController.loadScenarioImageData()){
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            questionDescription.text! = scenarioController.scenarios[scenarioController.currentScenario].questionText
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateUI()
        //Try loading image data from first Scenario
        if let image = UIImage(data: scenarioController.loadScenarioImageData()){
            print("image loaded")
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
        } else {
            print("hmm something went wrong buffering the initial image")
        }
        
        detectedSpeech.clipsToBounds = true;
        detectedSpeech.layer.cornerRadius = 3
        
        
        //set up speech recognition permission request; disable button if no permission is given
        voiceButton.isEnabled = false
        speechRecognizer?.delegate = self  //3
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
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
                self.voiceButton.isEnabled = isButtonEnabled
            }
        }
        
    }

    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "scenarioViewToReasoningPopup"  {
     
                let popView = segue.destination as! popUpViewController
                popView.passedReasoning = scenarioController.returnReasoning()
        }/*
        if segue.identifier == "sliderSegue" {
            let destination = segue.destination as? SliderViewController
            destination?.scenarioController = scenarioController
        }
        if segue.identifier == "multipleChoiceSegue" {
            let destination = segue.destination as? MultipleChoiceViewController
            destination?.scenarioController = scenarioController
        }
        if segue.identifier == "mainMenuSegue" {
            let destination = segue.destination as? MainMenuViewController
            destination?.scenarioController = scenarioController
        }*/
    }
}

