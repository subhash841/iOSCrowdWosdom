//
//  HomeHeaderCollectionReusableView.swift
//  CrowdWisdom
//
//  Created by Sunday on 15/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class HomeHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var viewMoreButton: NSButton!
    
    var sectionType: HomeSectionType?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
