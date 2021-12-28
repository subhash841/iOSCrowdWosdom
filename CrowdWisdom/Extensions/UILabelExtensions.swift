//
//  UILabelExtensions.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 12/4/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation
extension UILabel
{
    func addImage(imageName: String, afterLabel bolAfterLabel: Bool = false, afterText: String = "")
    {
        if let icon = UIImage(named: imageName) {
            let attachment: NSTextAttachment = NSTextAttachment()
            attachment.bounds = CGRect(x: 0, y: (self.font.capHeight - icon.size.height) / 2, width: icon.size.width * 1.2, height: icon.size.height * 1.2)
            attachment.image = icon
            let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)

            if (bolAfterLabel)
            {
                let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
                strLabelText.append(attachmentString)
                strLabelText.append(NSAttributedString(string: afterText))
                self.attributedText = strLabelText
            }
            else
            {
                let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
                let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
                mutableAttachmentString.append(strLabelText)

                self.attributedText = mutableAttachmentString
            }
        }

    }

    func removeImage()
    {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
    
    func addGradient() {
        let colorTop = oneGradientColor
        let colorBottom = twoGradientColor
        /*var updatedFrame = self.bounds
        updatedFrame.size.height += self.frame.origin.y*/
        let gradientLayer = CAGradientLayer(frame: self.bounds, colors: [colorTop, colorBottom])
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
//MARK:- Padding

extension UILabel {
//    private struct AssociatedKeys {
//        static var padding = UIEdgeInsets()
//    }
//
//    public var padding: UIEdgeInsets? {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
//        }
//        set {
//            if let newValue = newValue {
//                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            }
//        }
//    }
//
//    override open func draw(_ rect: CGRect) {
//        if let insets = padding {
//            self.drawText(in: rect.inset(by: insets))
//        } else {
//            self.drawText(in: rect)
//        }
//    }
//
//    override open var intrinsicContentSize: CGSize {
//        guard let text = self.text else { return super.intrinsicContentSize }
//
//        var contentSize = super.intrinsicContentSize
//        var textWidth: CGFloat = frame.size.width
//        var insetsHeight: CGFloat = 0.0
//        var insetsWidth: CGFloat = 0.0
//
//        if let insets = padding {
//            insetsWidth += insets.left + insets.right
//            insetsHeight += insets.top + insets.bottom
//            textWidth -= insetsWidth
//        }
//
//        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
//                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
//                                        attributes: [NSAttributedString.Key.font: self.font], context: nil)
//
//        contentSize.height = ceil(newSize.size.height) + insetsHeight
//        contentSize.width = ceil(newSize.size.width) + insetsWidth
//
//        return contentSize
//    }
}
