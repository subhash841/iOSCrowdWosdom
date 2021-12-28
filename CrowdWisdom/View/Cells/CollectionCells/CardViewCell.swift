//
//  CardViewCell.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 10/8/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class CardViewCell: CardStackViewCell {
    
    
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardQuestionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var voteNowButton: UIButton!
    @IBOutlet weak var voteNowHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var votesUILabel: UILabel!
    
    var voteButtonHeight: CGFloat = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        //        self.roundCorners([.topRight, .topLeft], radius: 5)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        //        cell.layer.shadowPath = shadowLayer.path
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 5
//        shareImageView.transform = .identity
//        shareImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//        shareImageView.image = shareImageView.image?.maskWithColor(color: UIColor.lightGray)
        shareImageView .isHidden = true
        votesUILabel.layer.cornerRadius = 2
        votesUILabel.clipsToBounds = true
        shareButton.transform = .identity
        shareButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        shareButton.setImage(UIImage(named: "shareThreeDot")?.transform(withNewColor: UIColor.lightGray), for: .normal)

//        self.seperatorDecoratorLabel.layer.cornerRadius = self.seperatorDecoratorLabel.frame.width/2
        

        if Device.IS_IPHONE_5{
            self.voteNowHeightConstraint.constant = 30
            voteButtonHeight = 30
            self.cardViewHeightConstraint.constant = 180
            cardQuestionLabel.font = UIFont.systemFont(ofSize: 13.0)

        } else{
            self.voteNowHeightConstraint.constant = 40
            voteButtonHeight = 40
            if Device.IS_IPHONE_6{
                cardQuestionLabel.font = UIFont.systemFont(ofSize: 15.0)
                self.cardViewHeightConstraint.constant = 230
            } else if Device.IS_IPHONE_6P{
                cardQuestionLabel.font = UIFont.systemFont(ofSize: 16.0)
                self.cardViewHeightConstraint.constant = 280
            } else if Device.IS_IPHONE_X {
                cardQuestionLabel.font = UIFont.systemFont(ofSize: 16.0)
                self.cardViewHeightConstraint.constant = 310
            } else if Device.IS_IPHONE_XR{
                cardQuestionLabel.font = UIFont.systemFont(ofSize: 16.0)
                self.cardViewHeightConstraint.constant = 350
                self.voteNowHeightConstraint.constant = 50
                voteButtonHeight = 50
            }
        }
    }
    
    //        self.layer.cornerRadius = 5
}

