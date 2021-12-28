//
//  ApplicationExtension.swift
//  CrowdWisdom
//
//  Created by Sunday on 24/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
