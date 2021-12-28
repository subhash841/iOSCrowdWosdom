//
//  CompetitionHeaderCell.swift
//  CrowdWisdom
//
//  Created by sunday on 12/5/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class CompetitionHeaderCell: UITableViewCell {

    @IBOutlet weak var competitionImage: UIImageView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var userDateLabel: UILabel!
    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var knowMoreButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var knowMoreIcon: UIImageView!
    @IBOutlet weak var expertSwitch: UISwitch!
    @IBOutlet weak var expertLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var descriptionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var expertSwitchHeight: NSLayoutConstraint!

    private var descriptionString: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        /*self.descriptionViewHeight.constant = 60
        self.descriptionView.isHidden = true*/
        
        shareButton.transform = .identity
        shareButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        shareButton.setImage(UIImage(named: "shareThreeDot")?.transform(withNewColor: UIColor.lightGray), for: .normal)
    }
    
    
    func setDetails(info: TypeStatus) {
        
        guard let infoData = info.data else {
            return
        }
        
        
        if let userChoice = infoData.users_choice, userChoice.isEmpty {
            expertSwitch.isHidden = true
            expertLabel.isHidden = true
            expertSwitchHeight.constant = 0
            
        } else {
            expertSwitchHeight.constant = 31
            expertSwitch.isHidden = false
            expertLabel.isHidden = false
        }
        
        // image
        if let url = URL(string: infoData.image ?? "") {
            self.competitionImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
        
        self.questionLabel.text = infoData.title ?? ""

        // user label data
        self.userDateLabel.text = ""
        if let date = infoData.created_date, let alias = infoData.alias  {
            
            let dat = Common.shared.stringFromDateString(date: date, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "MMMM dd, yyyy", isUT: false)
            
            if let raisedBy = infoData.raised_by_admin, raisedBy == "1"{
                userDateLabel.text = "By "
                userDateLabel.addImage(imageName: "logo_red", afterLabel: true, afterText: "| \(dat)")
            } else {
                userDateLabel.text = "By \(alias) | \(dat)"
            }
        }
        
        let comment = infoData.total_comments == "0" || infoData.total_comments == "1" ? "COMMENT" : "COMMENTS"
        let votes = infoData.total_votes == "0" || infoData.total_votes == "1" ? "VOTE" : "VOTES"

//        let votes = Int(infoData.total_votes ?? "0") ?? 0 < 0 ? " VOTE":" VOTES"
        let voteStr = "\(infoData.total_votes ?? "0") \(votes)"
        self.voteButton.setTitle(voteStr, for: .normal)
        
//        let comment = Int(infoData.total_comments ?? "0") ?? 0 < 0 ? " COMMENT":" COMMENTS"
        commentLabel.text  = "\(infoData.total_comments ?? "0") \(comment)"

        self.expertSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

        let description = infoData.description ?? ""
        self.descriptionLabel.text = description
        descriptionString = description
        
        
        /*if knowMoreButton.isSelected {
            hideDescriptionView()
            knowMoreButton.isSelected = false
        } else {
            showDescriptionView()
            knowMoreButton.isSelected = true
        }*/
    }
    
    func showDescriptionView(){
        descriptionView.isHidden = false
        self.descriptionViewHeight.constant = 60
        UIView.animate(withDuration: 0.2) {
            self.knowMoreIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        
        if let description = descriptionString, description != "" {
            let height = description.height(withConstrainedWidth: self.descriptionLabel.frame.size.width, font: self.descriptionLabel.font)
            self.descriptionViewHeight.constant = height + 50
        }
    }
    
    func hideDescriptionView() {
        descriptionView.isHidden = true
        self.descriptionViewHeight.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.knowMoreIcon.transform = .identity
        }
    }
    
}
