//
//  TopRatedArticlesCollectionViewCell.swift
//  CrowdWisdom
//
//  Created by Sunday on 16/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class TopRatedArticlesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var articleTitleLable: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        articleImageView.layer.cornerRadius = 5
//        articleImageView.layer.shadowColor = UIColor.lightGray.cgColor
//        articleImageView.layer.shadowRadius = 2
//        articleImageView.layer.shadowOffset = CGSize(width: 1, height: 1)
//        articleImageView.layer.shadowOpacity = 0.3
    }

}
