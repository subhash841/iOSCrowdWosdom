//
//  AddPredictionTableViewCell.swift
//  CrowdWisdom
//
//  Created by Sunday on 11/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class AddPredictionTableViewCell: UITableViewCell {
    

    @IBOutlet weak var partyImageView: UIImageView!
    @IBOutlet weak var partyNameLabel: UILabel!
    @IBOutlet weak var predictionTextField: UITextField!
    @IBOutlet weak var commentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        predictionTextField.borderWidth = 0.5
        predictionTextField.borderColor = UIColor.lightGray
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
