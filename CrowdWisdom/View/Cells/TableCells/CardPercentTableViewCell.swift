//
//  CardPercentTableViewCell.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 10/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class CardPercentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var progressBarView: YLProgressBar!
    @IBOutlet weak var tintView: UIView!
    
    @IBOutlet weak var optionNameLabel: UILabel!
    
    @IBOutlet weak var percentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        progressBarView.indicatorTextDisplayMode = .fixedRight
        progressBarView.setIndicatorFont(UIFont(name: "Roboto-Medium", size: 12)!)
        progressBarView.behavior = .default
        progressBarView.trackTintColor = UIColor.clear
        progressBarView.progressStretch = false
        progressBarView.progressBarInset = 0.0
        progressBarView.layer.borderColor = UIColor.init(hexString: "#ffffff", alpha: 0.5).cgColor
        progressBarView.stripesOrientation = .left
        progressBarView.uniformTintColor = true
        progressBarView.layer.borderWidth = 0.5
        progressBarView.layer.cornerRadius = 20
        
        tintView.layer.cornerRadius = 20
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
