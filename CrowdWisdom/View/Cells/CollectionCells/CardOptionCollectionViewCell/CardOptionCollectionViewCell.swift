//
//  CardOptionCollectionViewCell.swift
//  CrowdWisdom
//
//  Created by Nooralam Shaikh on 19/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class CardOptionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var lineLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lineLable.backgroundColor = BLUE_COLOR
    }

}
