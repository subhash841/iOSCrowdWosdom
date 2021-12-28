//
//  GameTableViewCell.swift
//  CrowdWisdom
//
//  Created by Sunday on 11/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var playNowButton: NSButton!
    @IBOutlet weak var premium: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setAttributedText()
        gameImageView.layer.cornerRadius = 5.0
        gameImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func setAttributedText(){
        if let text = gameNameLabel.text {
            let last = text.getLastWord()
            gameNameLabel.attributedText = Common.shared.attributedText(withString: text, boldString: last, font: Common.shared.getFont(type: .regular, size: gameNameLabel.font.pointSize))
        }
    }
}
