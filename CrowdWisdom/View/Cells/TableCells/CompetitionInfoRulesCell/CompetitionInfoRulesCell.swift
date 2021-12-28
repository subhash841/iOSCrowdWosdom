//
//  CompetitionInfoRulesCell.swift
//  CrowdWisdom
//
//  Created by sunday on 12/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class CompetitionInfoRulesCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var rule2: UILabel!
    @IBOutlet weak var rule4: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
