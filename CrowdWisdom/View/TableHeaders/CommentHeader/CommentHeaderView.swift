//
//  CommentHeaderView.swift
//  CrowdWisdom
//
//  Created by Sunday on 09/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class CommentHeaderView: UITableViewHeaderFooterView {


    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userInitialLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var numberOfRepliesLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var newReplyTextField: UITextField!
    @IBOutlet weak var newReplyButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editedCommentTextField: UITextField!
    @IBOutlet weak var editedCommentSaveButton: UIButton!
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replyStackHeight: NSLayoutConstraint!
    
    var isEdit = false {
        didSet {
            UIView.animate(withDuration: 0.5) {
                if self.isEdit {
                    self.commentLabel.alpha = 0.0
                    self.editView.alpha = 1.0
                    
                } else {
                    self.commentLabel.alpha = 1.0
                    self.editView.alpha = 0.0
                    
                }
            }
        }
    }
    
    var userInitialBackgroundColor : UIColor? {
        didSet{
            userInitialLabel.backgroundColor = userInitialBackgroundColor
        }
    }
    
    override func awakeFromNib() {
        
        replyButton.contentHorizontalAlignment = .left
        editButton.contentHorizontalAlignment = .left
        deleteButton.contentHorizontalAlignment = .left
        userInitialLabel.layer.cornerRadius = userInitialLabel.frame.width / 2
        userInitialLabel.layer.masksToBounds = true
        newReplyButton.roundCorners([.bottomRight, .topRight], radius: newReplyButton.frame.height / 2)
        
        replyView.layer.cornerRadius = replyView.frame.height / 2
        replyView.layer.borderColor = UIColor.lightGray.cgColor
        replyView.layer.borderWidth = 1
        
        editedCommentSaveButton.roundCorners([.bottomRight, .topRight], radius: editedCommentSaveButton.frame.height / 2)
        
        editView.layer.cornerRadius = editView.frame.height / 2
        editView.layer.borderColor = UIColor.lightGray.cgColor
        editView.layer.borderWidth = 1
//        newReplyTextField.layer.borderColor = UIColor.lightGray.cgColor
//        newReplyTextField.layer.borderWidth = 1
//        newReplyTextField.layer.cornerRadius = newReplyTextField.frame.height / 2
        
//        if let color = userInitialBackgroundColor {
//            userInitialLabel.backgroundColor = color
//        } else {
//            userInitialBackgroundColor = UIColor.random()
//        }

        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
