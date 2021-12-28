//
//  TopDiscussionCell.swift
//  CrowdWisdom
//
//  Created by Sunday on 04/06/19.
//  Copyright © 2019 Gaurav. All rights reserved.
//

import UIKit

class TopDiscussionCell: UICollectionViewCell {
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionInitialLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeLabelHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tintImageView: UIImageView!
    var isVoiceCell: Bool = false {
        didSet {
            if isVoiceCell {
                typeLabelHeight.constant = 15
            } else {
                typeLabelHeight.constant = 0
            }
        }
    }
    var questionInitialLabelBackgroundColor : UIColor? {
        didSet{
            questionInitialLabel.backgroundColor = questionInitialLabelBackgroundColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //        cellView.layer.masksToBounds = true
        questionInitialLabel.layer.cornerRadius = questionInitialLabel.frame.width / 2
        questionInitialLabel.layer.masksToBounds = true
        
        //        cellView.layer.cornerRadius = 5
        //        cellView.layer.masksToBounds = true
        //        cellView.layer.borderWidth = 0.1
        //        cellView.layer.borderColor = UIColor.darkGray.cgColor
        //
        //        cellView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        //        cellView.layer.shadowColor = UIColor.black.cgColor
        //        cellView.layer.shadowRadius = 2
        //        cellView.layer.shadowOpacity = 0.3
        //        cellView.clipsToBounds = true
    }
    
}
