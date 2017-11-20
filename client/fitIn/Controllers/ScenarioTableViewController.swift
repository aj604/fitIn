//
//  ScenarioTableViewController.swift
//  
//
//  Created by Avery Jones on 2017-11-18.
//

import UIKit

class ScenarioTableViewController: UITableViewController {
    
    var user = UserProfile()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        print("History Count == \(scenarioController.scenarioHistory.count)")
        print("current user == \(user.emailAddress)")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return scenarioController.scenarioHistory.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scenarioCell", for: indexPath) as? ScenarioTableViewCell
            let history = scenarioController.scenarioHistory[indexPath.row]
            cell?.imageCell.image = UIImage(data:history.imageData)
            cell?.scenarioName.text = history.questionText
            cell?.createdBy.text = history.createdBy
            print("question text for cell is \(history.questionText)")
        return cell!
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "statisticsDetailSegue" {
            print("USING THE RIGHT SEGUE!!!!!!!!!!!!!")
            let destination = segue.destination as! StatisticsViewController
            if let rowIndex = tableView.indexPathForSelectedRow {
                destination.scenarioHistoryIndex = rowIndex.row
                print("scenario controller history currently has \(scenarioController.scenarioHistory.count) values")
                //destination.scenarioController = scenarioController
                //destination.user = user
            }
        }
        /*if segue.identifier == "mainMenuFromHistorySegue" {
            print("RETURNING TO MENU SEGUE")
            let destination = segue.destination as! MainMenuViewController
            //destination.scenarioController = scenarioController
            //destination.currentUser = user
        }*/
    }
    

}
