//
//  VoteTableViewCell.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 11/16/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class VoteTableViewCell: UITableViewCell {

    @IBOutlet weak var trendButton: UIButton!
    @IBOutlet weak var voteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        voteButton.layer.cornerRadius = voteButton.frame.height/2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
