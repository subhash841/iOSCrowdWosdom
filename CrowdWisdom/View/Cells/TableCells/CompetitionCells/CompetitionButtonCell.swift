//
//  CompetitionButtonCell.swift
//  CrowdWisdom
//
//  Created by sunday on 12/5/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class CompetitionButtonCell: UITableViewCell {

    @IBOutlet weak var voteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        voteButton.backgroundColor = BLUE_COLOR
        voteButton.layer.cornerRadius = 15
        
    }
}
