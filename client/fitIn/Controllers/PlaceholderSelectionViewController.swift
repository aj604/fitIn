//
//  PlaceholderSelectionViewController.swift
//  fitIn
//
//  Created by Vlad Polin on 11/14/17.
//  Copyright © 2017 AJ productions. All rights reserved.
//

import UIKit

class PlaceholderSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var strings = ["Running", "Thinking", "Walking", "Throwing", "Looking", "Finding"]
    var images = ["man-running-stroller-emoji.jpg", "thinking.jpg", "walking.jpg", "throwing.jpg", "looking.jpg", "finding.jpg"]
    //instantiation of label strings, asset's strings and the table view itself
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strings.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaceholderTableViewCell
        cell.layer.borderWidth = 10
        cell.labelText.text = strings[indexPath.row]
        cell.cellImage.image = UIImage(named: images[indexPath.row])
        //made every cell an object of PlaceholderTableViewCell, which is a custom class for a specific cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        //sets the cell size to 200 for UI
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "UploadCustomScenarioViewController") as! UploadCustomScenarioViewController
        destinationViewController.placeholderImage = UIImage(named: images[indexPath.row])!
        destinationViewController.hackyLabel = strings[indexPath.row]
        self.navigationController?.pushViewController(destinationViewController, animated: true)
        //passing data into the next view controller as soon as a user clicks on a picture
        //once a user clicks on a picture they are re-directed back to previous view controller
    }
}
