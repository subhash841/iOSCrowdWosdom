//
//  CompetitionInfoRewardCell.swift
//  CrowdWisdom
//
//  Created by sunday on 12/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class CompetitionInfoRewardCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var rewardLabel: UILabel!
    
    @IBOutlet weak var lineLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
