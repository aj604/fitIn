//
//  StatisticsViewController.swift
//  fitIn
//
//  Created by Avery Jones on 2017-11-18.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    var scenarioController = ScenarioHandler()
    var user = UserProfile()
    var scenarioHistoryIndex = 0
    

    @IBOutlet weak var scenarioImage: UIImageView!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var createdBy: UILabel!
    @IBOutlet weak var answerReasoning: UILabel!
    @IBOutlet weak var initialAnswer: UILabel!
    @IBOutlet weak var averageAnswer: UILabel!
    @IBOutlet weak var numberOfAnswers: UILabel!
    @IBOutlet weak var responseTime: UILabel!
    @IBOutlet weak var standardDeviation: UILabel!

    
    func updateUI() {
        let tempScenario = scenarioController.scenarioHistory[scenarioHistoryIndex]
        scenarioImage.image = UIImage(data:tempScenario.imageData)
        questionText.text = tempScenario.questionText
        print("question text is \(tempScenario.questionText)")
        createdBy.text = tempScenario.createdBy
        answerReasoning.text = tempScenario.answerReasoning
        initialAnswer.text = String(tempScenario.initialAnswer)
        averageAnswer.text = String(tempScenario.averageAnswer)
        numberOfAnswers.text = String(tempScenario.numberOfAnswers)
        responseTime.text = String(tempScenario.averageTimeToAnswer)
        standardDeviation.text = String(tempScenario.standardDeviation)
    }

    override func viewDidLoad() {
   
        print("scenario controller history currently has \(scenarioController.scenarioHistory.count) values")
        updateUI()
super.viewDidLoad()
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
