//
//  ChoiceNewTableViewCell.swift
//  CrowdWisdom
//
//  Created by Sunday on 22/11/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class ChoiceNewTableViewCell: UITableViewCell {
    @IBOutlet weak var choiceTextField: UITextField!
    @IBOutlet weak var optionImage: UIImageView!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    var typeWall = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        choiceTextField.layer.borderColor = UIColor.lightGray.cgColor
        choiceTextField.layer.cornerRadius = 2
        choiceTextField.setRightPaddingPoints(15)
        self.bringSubviewToFront(optionImage)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
