//
//  PlayAndWinCollectionViewCell.swift
//  CrowdWisdom
//
//  Created by Sunday on 15/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class PlayAndWinCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var playNowButtonTapped: NSButton!
    
    @IBOutlet weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.cornerRadius = 5
        cellView.layer.masksToBounds = true
        cellView.layer.borderWidth = 0.1
        cellView.layer.borderColor = UIColor.darkGray.cgColor
        
        cellView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowRadius = 2
        cellView.layer.shadowOpacity = 0.3
        cellView.clipsToBounds = true
    }

}
