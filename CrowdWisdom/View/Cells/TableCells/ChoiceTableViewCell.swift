//
//  ChoiceTableViewCell.swift
//  CrowdWisdom
//
//  Created by Sunday on 08/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class ChoiceTableViewCell: UITableViewCell {

    @IBOutlet weak var choiceTextField: UITextField!
    @IBOutlet weak var optionImage: UIImageView!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        choiceTextField.layer.borderColor = UIColor.lightGray.cgColor
        choiceTextField.layer.cornerRadius = 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
