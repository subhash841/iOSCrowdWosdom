////
////  viewMoreButton.swift
////  CrowdWisdom
////
////  Created by sunday on 10/8/18.
////  Copyright © 2018 Gaurav. All rights reserved.
////
//
//import UIKit
//
//
//class viewMoreButton: UIButton {
//
//    @IBInspectable var cornerRadius: CGFloat = 15 {
//        didSet {
//            refreshCorners(value: cornerRadius)
//        }
//    }
//
//    @IBInspectable var borderColor: UIColor = UIColor.blue {
//        didSet {
//            refreshBorderColor(color: borderColor)
//        }
//    }
//
//    @IBInspectable var borderWidth: CGFloat = 0.5 {
//        didSet {
//            refreshBorderWidth(size: borderWidth)
//        }
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//
//    override func prepareForInterfaceBuilder() {
//        commonInit()
//    }
//
//    fileprivate func commonInit() {
//        // Common logic goes here
//        refreshCorners(value: cornerRadius)
//        refreshBorderColor(color: borderColor)
//        refreshBorderWidth(size: borderWidth)
//    }
//
//    fileprivate func refreshCorners(value: CGFloat) {
//        layer.cornerRadius = value
//    }
//
//    fileprivate func refreshBorderColor(color: UIColor) {
//        layer.borderColor = color.cgColor
//    }
//
//    fileprivate func refreshBorderWidth(size: CGFloat) {
//        layer.borderWidth = size
//    }
//
//}
