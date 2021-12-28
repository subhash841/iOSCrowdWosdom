//
//  AliesCell.swift
//  CrowdWisdom
//
//  Created by sunday on 11/13/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class AliesCell: UITableViewCell {

    private var aliesText = ""
    private var partyAffilliationText = ""
    private var locationText = ""
    
    @IBOutlet weak var conatinerView: UIView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var downArrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        //typeTextField.delegate = self

    }
    
    //MARK:- Convienience Methods
    
    func showDropDownImage() {
        downArrowImageView.isHidden = false
    }
    
    func hideDropDownImage() {
        downArrowImageView.isHidden = true
    }

    func getAliasText() -> String {
        return aliesText
    }
    
    func getPartyAffilliationText() -> String {
        return partyAffilliationText
    }
    
    func getLocationText() -> String {
        return locationText
    }
}

//MARK:- TextField Delegate

extension AliesCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let kActualText = (textField.text ?? "") + string
        switch textField.tag
        {
        case 0:
            aliesText = kActualText;
        case 1:
            partyAffilliationText = kActualText;
        case 2:
            locationText = kActualText;
        default:
            print("It is nothing");
        }
        
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 10
    }
}

