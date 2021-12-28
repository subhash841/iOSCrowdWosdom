//
//  ProfileTableViewCell.swift
//  CrowdWisdom
//
//  Created by Sunday on 22/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    
    @IBOutlet weak var historyButton: NSButton!
    @IBOutlet weak var emailIDLabel: UILabel!
    @IBOutlet weak var partyAffiliationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var type: ProfileCellType = .points {
        didSet {
                categoryLabel.text = type.rawValue
                switch type {
                case .points:
                    firstLabel.text = "Silver Points"
                    secondLabel.text = "Gold Points"
                    thirdLabel.text = "Diamond Points"
                case .basic:
                    firstLabel.text = "Email ID"
                    secondLabel.text = "Party Affiliation"
                    thirdLabel.text = "Location"
                    
//                case .game:
//                    firstLabel.text = "Games Played"
//                    secondLabel.text = "Games Won"
//                    thirdLabel.text = "Pending Questions"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
enum ProfileCellType: String {
    case points = "Points Details"
    case basic = "Basic Information"
//    case game = "Game Details"
}
