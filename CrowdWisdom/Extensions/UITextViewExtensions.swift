//
//  UITextViewExtensions.swift
//  CrowdWisdom
//
//  Created by Sunday on 19/11/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    func validate() -> Bool {
        guard let text = self.text, !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                return false
        }
        return true
    }
}
