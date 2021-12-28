//
//  CardDetailsTableViewCell.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 10/30/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class CardDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var expertLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var votesLabel: UIButton!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var viewDescriptionButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var expertSwitch: UISwitch!
    @IBOutlet weak var descriptionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var knowMoreImageView: UIImageView!
    @IBOutlet weak var expertSwitchHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        shareButton.setImage(UIImage(named: "shareThreeDot")?.transform(withNewColor: UIColor.lightGray), for: .normal)
        shareButton.transform = .identity
        shareButton.transform = shareButton.transform.rotated(by: CGFloat(Double.pi))
        // Configure the view for the selected state
    }

}
