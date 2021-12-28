//
//  CompetitionOptionCell.swift
//  CrowdWisdom
//
//  Created by sunday on 12/5/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class CompetitionOptionCell: UITableViewCell {

    @IBOutlet weak var progressBarView: YLProgressBar!
    @IBOutlet weak var tintView: UIView!
    @IBOutlet weak var choicelabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    var expertOn = Bool()
    var expertOptions = [ExpertOption]()
    var showPercent = Bool()
    var selectedIndex = Int()
    var isMultipleChoice = String()
    var selectedOptionIndexArray = [Bool]()
    
    
    var isVoted = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        progressBarView.setIndicatorFont(UIFont(name: "Roboto-Medium", size: 12)!)
        progressBarView.behavior = .default
        progressBarView.trackTintColor = UIColor.clear
        progressBarView.progressStretch = false
        progressBarView.progressBarInset = 0.0
        progressBarView.layer.borderColor = UIColor.init(hexString: "#ffffff", alpha: 0.5).cgColor
        progressBarView.stripesOrientation = .left
        progressBarView.uniformTintColor = true
        progressBarView.layer.borderWidth = 0.5
        progressBarView.layer.cornerRadius = 20
        
        tintView.layer.cornerRadius = 20
    }
 
    
    func setNewDetails(info: TypeStatus, index: Int) {
        guard let infoData = info.data,
            let options = infoData.options else {
                return
        }
        
        choicelabel.text = options[index].choice ?? ""
        let userChoice: Int = Int(infoData.users_choice ?? "0") ?? 0
        if userChoice > 0 {
            // user vote already, showing percentage
            if let n = NumberFormatter().number(from: options[index].avg ?? "0"){
                percentLabel.text = "\(CGFloat(truncating: n)) %"
                progressBarView.progress = CGFloat(truncating: n)/100
            }
            percentLabel.isHidden = false
            progressBarView.progressTintColor = UIColor(hexString: "#b3e1fc")
            
            if selectedOptionIndexArray[index] == true { // user select option
                choicelabel.textColor = .white
                percentLabel.textColor = .white
                tintView.backgroundColor = UIColor(hexString: "#007AFF")
            } else {
                if userChoice == Int(options[index].choice_id ?? "0") ?? 0 {
                    // showin cell selected
                    choicelabel.textColor = UIColor(hexString: "#007AFF")
                    percentLabel.textColor = UIColor(hexString: "#007AFF")
                } else {
                    // set prograss bar
                    choicelabel.textColor = UIColor.darkGray
                    percentLabel.textColor = UIColor.darkGray
                }
                tintView.backgroundColor = UIColor.clear
            }
        } else {
            // user not voted
            percentLabel.isHidden = true
            choicelabel.textColor = UIColor.darkGray
            percentLabel.textColor = UIColor.darkGray
            progressBarView.progressTintColor = UIColor.groupTableViewBackground
            tintView.backgroundColor = UIColor.clear
        }

        progressBarView.backgroundColor = UIColor.groupTableViewBackground
        progressBarView.layer.cornerRadius = 20
        
        progressBarView.clipsToBounds = true
    }
    
    // create is Voted and vote button handling in details cell
    
   // private func isVoted()
    func setDetails(info: TypeStatus, index: Int) {
        
        guard let infoData = info.data,
            let options = infoData.options else {
                return
        }

        choicelabel.text = options[index].choice ?? ""
        
        if expertOn{
            let expertOption = expertOptions[index]
            if let n = NumberFormatter().number(from: expertOption.expertPercent ?? "0"){
                percentLabel.text = "\(CGFloat(truncating: n)) %"
                progressBarView.progress = CGFloat(truncating: n)/100
                if expertOption.type == "0"{
                    percentLabel.isHidden = true
                } else{
                    percentLabel.isHidden = false
                }
            }
            progressBarView.progressTintColor = UIColor(hexString: "#b3e1fc")
        } else{
            tintView.backgroundColor = UIColor.clear
            if showPercent{
                if let n = NumberFormatter().number(from: options[index].avg ?? "0"){
                    percentLabel.text = "\(CGFloat(truncating: n)) %"
                    progressBarView.progress = CGFloat(truncating: n)/100
                    if options[index].type == "0"{
                        percentLabel.isHidden = true
                    } else{
                        percentLabel.isHidden = false
                    }
                }
            } else{
                progressBarView.progress = 0
                percentLabel.isHidden = false
            }
            
            progressBarView.progressTintColor = UIColor(hexString: "#b3e1fc")
        }
        
        if isMultipleChoice == "1" {
            if selectedOptionIndexArray[index] {
                tintView.backgroundColor = UIColor(hexString: "#007AFF")
                choicelabel.textColor = UIColor.white
                percentLabel.textColor = UIColor.white
            } else{
                if expertOn{
                    choicelabel.textColor = UIColor.darkGray
                    percentLabel.textColor = UIColor.black
                } else{
                    if options[index].choice_id == infoData.users_choice{
                        choicelabel.textColor = UIColor(hexString: "#007AFF")
                        percentLabel.textColor = UIColor(hexString: "#007AFF")
                        percentLabel.textColor = UIColor(hexString: "#007AFF")
                    } else{
                        choicelabel.textColor = UIColor.darkGray
                        percentLabel.textColor = UIColor.darkGray
                        percentLabel.textColor = UIColor.darkGray
                    }
                    
                }
                tintView.backgroundColor = UIColor.clear
            }
        } else {
            if selectedIndex == index{
                tintView.backgroundColor = UIColor(hexString: "#007AFF")
                choicelabel.textColor = UIColor.white
                percentLabel.textColor = UIColor.white
            } else{
                if expertOn{
                    choicelabel.textColor = UIColor.darkGray
                    percentLabel.textColor = UIColor.black
                } else{
                    if options[index].choice_id == infoData.users_choice{
                        choicelabel.textColor = UIColor(hexString: "#007AFF")
                        percentLabel.textColor = UIColor(hexString: "#007AFF")
                        percentLabel.textColor = UIColor(hexString: "#007AFF")
                    } else{
                        choicelabel.textColor = UIColor.darkGray
                        percentLabel.textColor = UIColor.darkGray
                        percentLabel.textColor = UIColor.darkGray
                    }
                    
                }
                tintView.backgroundColor = UIColor.clear
            }
            
        }
        
        progressBarView.backgroundColor = UIColor.groupTableViewBackground
        progressBarView.layer.cornerRadius = 20
        
        progressBarView.clipsToBounds = true
    }
}
