//
//  TaskTableViewCell.swift
//  ZohoKeep
//
//  Created by Bala on 1/25/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var groupName : UILabel!
    @IBOutlet weak var deleteButton : UIButton!
    @IBOutlet weak var completedButton : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
