//
//  AchievementTableViewCell.swift
//  runit
//
//  Created by Denise NGUYEN on 06/01/2018.
//  Copyright © 2018 Denise NGUYEN. All rights reserved.
//

import UIKit

class AchievementTableViewCell: UITableViewCell {
    
        var id: String = "";
        @IBOutlet weak var contentLabel: UILabel!
        @IBOutlet weak var startDateLabel: UILabel!
        @IBOutlet weak var endDateLabel: UILabel!
        @IBOutlet weak var typeLabel: UILabel!
        @IBOutlet weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
