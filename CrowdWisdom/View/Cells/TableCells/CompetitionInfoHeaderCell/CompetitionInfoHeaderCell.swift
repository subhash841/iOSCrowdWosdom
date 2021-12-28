//
//  CompetitionInfoHeaderCell.swift
//  CrowdWisdom
//
//  Created by sunday on 12/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class CompetitionInfoHeaderCell: UITableViewCell {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameEndDateLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var noOfQuestionLabel: UILabel!
    @IBOutlet weak var noOfPoitnsLabel: UILabel!
    @IBOutlet weak var payNowButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setDetails(with info: CompetitionInfoModel) {
        
        guard let infoData = info.data else {
            return
        }
        
        // Image
        if let url = URL(string: infoData.image ?? "") {
            self.gameImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
        // Name
        if let name = infoData.name {
            self.gameTitleLabel.text = name
        } else {
            self.gameTitleLabel.text = ""
        }
        // End date
        if let endDate = infoData.end_date {
            self.gameEndDateLabel.text = "End Date : " + getFormattedDate(dateString: endDate)
        } else {
            self.gameEndDateLabel.text = ""
        }
        
        // Prediction Count
        if let predictionCount = infoData.prediction_count {
            self.noOfQuestionLabel.text = predictionCount.count > 1 ? predictionCount : "0\(predictionCount)"
        } else {
            self.noOfQuestionLabel.text = "-"
        }
        // Price
        if let points = infoData.price, let doublePoint = Double(points) {
            let intPoint = Int(doublePoint)
            self.noOfPoitnsLabel.text = intPoint > 1 ? "\(intPoint)" + " Points" : "\(intPoint)" + " Point"

        } else {
            self.noOfPoitnsLabel.text = ""
        }
        
        // pay now button handling
        setPayNowbutton(with: infoData)
        
        // Points
        
    }
    
    func getFormattedDate(dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let yourDate = formatter.date(from: dateString)
        formatter.dateFormat = "dd-MM-yyyy"
        if let date = yourDate {
            return formatter.string(from: date)
        }
        return ""
    }
    
    func setPayNowbutton(with infoData: CompetitionInfoDataModel) {
        
        func setAccordingToPrice() {
            if let price = infoData.price {
                if price.integerValue ?? 0 > 0 {
                    self.payNowButton.setTitle("Pay Now", for: .normal)
                } else {
                    self.payNowButton.setTitle("Play Now", for: .normal)
                }
            } else {
                self.payNowButton.setTitle("Play Now", for: .normal)
            }
        }
        
        if let purchased = infoData.purchased {
            if purchased == "1" {
                self.payNowButton.setTitle("Play Now", for: .normal)
            } else {
                // check for price key
                setAccordingToPrice()
            }
        } else {
            // check for price key
            setAccordingToPrice()
        }
        
    }
}

