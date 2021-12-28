//
//  PartyTableViewCell.swift
//  CrowdWisdom
//
//  Created by Sunday on 10/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class PartyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var partyImageView: UIImageView!
    @IBOutlet weak var partyNameLabel: UILabel!
    @IBOutlet weak var seatPredictionLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        partyImageView.layer.shadowOpacity = 0.5
        partyImageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        partyImageView.layer.shadowRadius = 2
        partyImageView.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
