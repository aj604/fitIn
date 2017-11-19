//
//  ScenarioTableViewCell.swift
//  
//
//  Created by Avery Jones on 2017-11-18.
//

import UIKit

class ScenarioTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var scenarioName: UILabel!
    @IBOutlet weak var createdBy: UILabel!
    var cellScenario = Scenario()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
