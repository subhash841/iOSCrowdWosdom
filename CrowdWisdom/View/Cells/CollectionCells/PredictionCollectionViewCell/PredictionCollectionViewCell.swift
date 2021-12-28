//
//  PredictionCollectionViewCell.swift
//  CrowdWisdom
//
//  Created by Sunday on 15/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class PredictionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var predictionDetailLabel: UILabel!
    @IBOutlet weak var predictionNameLabel: UILabel!
    @IBOutlet weak var makeAPredictionButton: NSButton!
    @IBOutlet weak var predictionImageView: UIImageView!
    @IBOutlet weak var tintImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        predictionImageView.cornerRadius = 5
        tintImageView.cornerRadius = 5
        
//        containerView.layer.cornerRadius = 5
//        containerView.layer.borderWidth = 0.5
//        containerView.layer.borderColor = UIColor.gray.cgColor
    }
   
}
