//
//  ReplyHeaderTableViewCell.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 11/14/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class ReplyHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var aliasLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var numberOfRepliesLabel: UILabel!
    @IBOutlet weak var userInitialLabel: UILabel!
    
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var editButto: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editCommentTextField: UITextView!
    @IBOutlet weak var editCommentSendButton: UIButton!
    @IBOutlet weak var editViewHeightConstraint: NSLayoutConstraint!
    
//    var isEdit: Bool = false {
//        didSet {
//            UIView.animate(withDuration: 0.5) {
//                //                self.editCommentTextField.text = ""
//                if self.isEdit {
////                    self.commentLabel.alpha = 0.0
//                    self.editView.alpha = 1.0
//                    self.editViewHeightConstraint.constant = 30
//
//                } else {
////                    self.commentLabel.alpha = 1.0
//                    self.editView.alpha = 0.0
//                    self.editViewHeightConstraint.constant = 0
//
//                }
//            }
//        }
//    }
    var userInitialBackgroundColor : UIColor? {
        didSet{
            userInitialLabel.backgroundColor = userInitialBackgroundColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        editButto.contentHorizontalAlignment = .left
//        deleteButton.contentHorizontalAlignment = .left
//        replyButton.contentHorizontalAlignment = .left
        
        userInitialLabel.layer.cornerRadius = userInitialLabel.frame.width / 2
        userInitialLabel.layer.masksToBounds = true
        editCommentSendButton.roundCorners([.bottomRight, .topRight], radius: editCommentSendButton.frame.height / 2)
        
        editCommentTextField.placeholder = "Write Reply"
        
        editCommentTextField.borderColor = UIColor.black
        editCommentTextField.borderWidth = 0.5
        
        editCommentTextField.font = Common.shared.getFont(type: .regular, size: 15)
        
        editCommentTextField.layer.cornerRadius = 15
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
