//
//  DrawerHeaderTableViewCell.swift
//  CrowdWisdom
//
//  Created by  user on 11/22/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class DrawerHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var contentViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var bgImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 35
        profileImage.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
