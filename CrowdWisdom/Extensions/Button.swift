//
//  Button.swift
//  CrowdWisdom
//
//  Created by Sunday on 08/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    func makeRoundedCorners() {
        self.layer.cornerRadius = self.layer.frame.size.height / 2
    }
    
    func makeShadow() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 2.5
        self.layer.shadowOpacity = 0.3
    }
}
