//
//  RandomColorGenerator.swift
//  CrowdWisdom
//
//  Created by Sunday on 09/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat{
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}


