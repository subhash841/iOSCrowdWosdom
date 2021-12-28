//
//  CommentTableViewCell.swift
//  CrowdWisdom
//
//  Created by Sunday on 09/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class ReplyTableViewCell: UITableViewCell {

    @IBOutlet weak var editButtonheight: NSLayoutConstraint!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userInitialLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var cancelBtn: NSButton!
    @IBOutlet weak var editReplyTextField: UITextView!
    @IBOutlet weak var editReplySendButton: UIButton!
    
    @IBOutlet weak var decorationView: UILabel!
    @IBOutlet weak var editView: UIView!
    
    //    @IBOutlet weak var numberOfRepliesLabel: UILabel!
//    @IBOutlet weak var replyButton: UIButton!
//    @IBOutlet weak var replyTextField: UITextField!
//    @IBOutlet weak var newReplyButton: UIButton!
    var isEdit: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.5) {
                if self.isEdit {
                    self.replyLabel.alpha = 0.0
                    self.editView.alpha = 1.0

                } else {
                    self.replyLabel.alpha = 1.0
                    self.editView.alpha = 0.0

                }
            }
        }
    }
    
    var firstTimeLoad = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        editButton.contentHorizontalAlignment = .left
        deleteButton.contentHorizontalAlignment = .center
        userInitialLabel.layer.cornerRadius = userInitialLabel.frame.width / 2
        userInitialLabel.layer.masksToBounds = true
//        editReplySendButton.roundCorners([.bottomRight, .topRight], radius: editReplySendButton.frame.height / 2)
//        editView.layer.cornerRadius = editView.frame.height / 2
//        editView.layer.borderColor = UIColor.lightGray.cgColor
//        editView.layer.borderWidth = 1
        self.editReplyTextField.layer.cornerRadius = 4
        editReplyTextField.layer.borderWidth = 0.5
        editReplyTextField.layer.borderColor = UIColor.lightGray.cgColor
        editReplyTextField.font = Common.shared.getFont(type: .regular, size: 15)
        //self.editReplyTextField.backgroundColor = UIColor(white: 0.9, alpha: 1)
//        if firstTimeLoad { userInitialLabel.backgroundColor = UIColor.random() }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
//    @IBAction func cancelButtonAction(_ sender: Any) {
//        self.replyLabel.alpha = 1.0
//        self.editView.alpha = 0.0
//    }
    
}
