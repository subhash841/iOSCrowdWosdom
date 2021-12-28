//
//  HotTopicCollectionViewCell.swift
//  CrowdWisdom
//
//  Created by Sunday on 06/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class HotTopicCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var topicImageView: UIImageView!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        cellView.layer.cornerRadius = 8.0
//        cellView.layer.masksToBounds = true
//        cellView.layer.borderWidth = 0.1
//        cellView.layer.borderColor = UIColor.darkGray.cgColor
//        cellView.layer.shadowOffset = CGSize(width: 1, height: 1)
//        cellView.layer.shadowColor = UIColor.black.cgColor
//        cellView.layer.shadowRadius = 8.0
//        cellView.layer.shadowOpacity = 0.28
        cellView.clipsToBounds = true
        topicLabel.textColor = UIColor.black
//        followButton.backgroundColor = .clear
//        followButton.layer.cornerRadius = followButton.frame.height / 2
//        followButton.layer.borderWidth = 1
//        followButton.layer.borderColor = UIColor.red.cgColor
    }
}
