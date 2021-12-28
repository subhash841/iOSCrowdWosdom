//
//  NewWalletHistoryCell.swift
//  CrowdWisdom
//
//  Created by  user on 11/29/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class NewWalletHistoryCell: UITableViewCell {

    @IBOutlet weak var walletMainView: UIView!
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
