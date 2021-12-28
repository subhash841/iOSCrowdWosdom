//
//  CommentTableViewCell.swift
//  CrowdWisdom
//
//  Created by Sunday on 05/11/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import NextGrowingTextView
class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet var decorationViews: [UILabel]!
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

    @IBOutlet weak var editCancelButton: NSButton!
    //    @IBAction func editCancelButton(_ sender: UIButton) {
//        isEdit = !isEdit
//    }
    
//    var isEdit: Bool = false {
//        didSet {
//            UIView.animate(withDuration: 0.5) {
//                //                self.editCommentTextField.text = ""
//                if self.isEdit {
//                    self.deleteButton.isHidden = true
//                    self.editCommentTextField.becomeFirstResponder()
//                    self.commentLabel.alpha = 0.0
//                    self.editView.alpha = 1.0
//
//                } else {
//                    self.deleteButton.isHidden = false
//                    self.editCommentTextField.resignFirstResponder()
//                    self.commentLabel.alpha = 1.0
//                    self.editView.alpha = 0.0
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
        editButto.contentHorizontalAlignment = .left
        //deleteButton.contentHorizontalAlignment = .left
        replyButton.contentHorizontalAlignment = .left
        
        userInitialLabel.layer.cornerRadius = userInitialLabel.frame.width / 2
        userInitialLabel.layer.masksToBounds = true
//        editCommentSendButton.roundCorners([.bottomRight, .topRight], radius: editCommentSendButton.frame.height / 2)
        self.editCommentTextField.layer.cornerRadius = 4
        //self.editCommentTextField.backgroundColor = UIColor(white: 0.9, alpha: 1)
        editCommentTextField.layer.borderWidth = 0.5
        editCommentTextField.layer.borderColor = UIColor.lightGray.cgColor
        //        editCommentTextField.roundCorners([.bottomLeft, .topLeft], radius: 5)
        //        editCommentTextField.layer.borderWidth = 1
        //        editCommentTextField.layer.masksToBounds = true
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
