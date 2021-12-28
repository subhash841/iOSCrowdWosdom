//
//  NewPredictionCell.swift
//  CrowdWisdom
//
//  Created by Sunday on 06/06/19.
//  Copyright © 2019 Gaurav. All rights reserved.
//

import UIKit

class NewPredictionCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var predictionDetailLabel: UILabel!
    @IBOutlet weak var predictionNameLabel: UILabel!
    @IBOutlet weak var makeAPredictionButton: NSButton!
    @IBOutlet weak var predictionImageView: UIImageView!
    @IBOutlet weak var tintImageView: UIImageView!
    
    @IBOutlet weak var makePredictionButtonHeightConstraints: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        predictionImageView.cornerRadius = 5
        predictionImageView.borderColor = .gray
        predictionImageView.borderWidth = 0.2
        
//        predictionImageView.borderColor = UIColor
//        tintImageView.cornerRadius = 5
        
//                containerView.layer.cornerRadius = 5
//                containerView.layer.borderWidth = 0.5
        //        containerView.layer.borderColor = UIColor.gray.cgColor
    }
    
}
