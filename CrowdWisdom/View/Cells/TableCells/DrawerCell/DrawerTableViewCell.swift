//
//  DrawerTableViewCell.swift
//  CrowdWisdom
//
//  Created by  user on 11/22/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class DrawerTableViewCell: UITableViewCell {

    @IBOutlet weak var drawerMenuCountLabel: UILabel!
    @IBOutlet weak var drawerMenuName: UILabel!
    @IBOutlet weak var drawerMenuImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        drawerMenuCountLabel.layer.cornerRadius = 15
        drawerMenuCountLabel.clipsToBounds = true
        
        drawerMenuImage.clipsToBounds = false
        drawerMenuImage.layer.shadowColor = UIColor.lightGray.cgColor
        drawerMenuImage.layer.shadowOpacity = 0.5
        drawerMenuImage.layer.shadowOffset = CGSize.zero
        drawerMenuImage.layer.shadowRadius = 1
        drawerMenuImage.layer.shadowPath = UIBezierPath(roundedRect: drawerMenuImage.bounds, cornerRadius: 20).cgPath

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
