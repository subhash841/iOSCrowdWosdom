//
//  FeaturedTopicCellTableViewCell.swift
//  CrowdWisdom
//
//  Created by Sunday on 06/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class FeaturedTopicCellTableViewCell: UITableViewCell {

    @IBOutlet weak var topicImageView: UIImageView!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        followButton.backgroundColor = .clear
        followButton.layer.cornerRadius = followButton.frame.height / 2
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.red.cgColor
        // Configure the view for the selected state
    }

}
