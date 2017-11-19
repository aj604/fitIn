//
//  ScenarioTableViewController.swift
//  
//
//  Created by Avery Jones on 2017-11-18.
//

import UIKit

class ScenarioTableViewController: UITableViewController {
    
    var scenarioController = ScenarioHandler()
    var user = UserProfile()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension

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
        return 0
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
        return cell!
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "statisticsDetailSegue" {
        let destination = segue.destination as! StatisticsViewController
        if let rowIndex = tableView.indexPathForSelectedRow {
                destination.scenarioController = self.scenarioController
                destination.user = self.user
                destination.currentScenario = scenarioController.scenarioHistory[rowIndex.row]
            }
        }
    }
    

}
