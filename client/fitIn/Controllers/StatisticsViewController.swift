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
    var currentScenario = Scenario()
    
    /* NEED TO DISPLAY
         generic scenario view of image
         createdBy
         average answer
         number of answers
         response time
         standardDev?
 */
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
        scenarioImage.image = UIImage(data:currentScenario.imageData)
        questionText.text = currentScenario.questionText
        createdBy.text = currentScenario.createdBy
        answerReasoning.text = currentScenario.answerReasoning
        initialAnswer.text = String(currentScenario.initialAnswer)
        averageAnswer.text = String(currentScenario.averageAnswer)
        numberOfAnswers.text = String(currentScenario.numberOfAnswers)
        responseTime.text = String(currentScenario.averageTimeToAnswer)
        standardDeviation.text = String(currentScenario.standardDeviation)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

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
