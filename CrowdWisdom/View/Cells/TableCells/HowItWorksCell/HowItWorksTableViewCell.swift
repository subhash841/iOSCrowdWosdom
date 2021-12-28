//
//  HowItWorksTableViewCell.swift
//  HowItWorks
//
//  Created by  user on 10/23/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class HowItWorksTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
