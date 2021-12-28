//
//  SegmentedControlExtension.swift
//  CrowdWisdom
//
//  Created by Sunday on 22/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

//extension UISegmentedControl {
//    func removeBorders() {
//        setBackgroundImage(imageWithColor(color: self.backgroundColor ?? UIColor()), for: .normal, barMetrics: .default)
//        setBackgroundImage(imageWithColor(color: tintColor ?? UIColor() ), for: .selected, barMetrics: .default)
//        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
//    }
//    
//    // create a 1x1 image with this color
//    private func imageWithColor(color: UIColor) -> UIImage {
//        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
//        UIGraphicsBeginImageContext(rect.size)
//        let context = UIGraphicsGetCurrentContext()
//        context!.setFillColor(color.cgColor);
//        context!.fill(rect);
//        let image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        return image!
//    }
//}
//extension UIImage {
//    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
//        let rect = CGRect(origin: .zero, size: size)
//        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
//        color.setFill()
//        UIRectFill(rect)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        guard let cgImage = image?.cgImage else { return nil }
//        self(cgImage: cGImage)
//    }
//}
