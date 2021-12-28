//
//  CompetitionPopupViewController.swift
//  CrowdWisdom
//
//  Created by  user on 12/14/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import PopupDialog

protocol CompetitionPopUpDelegate {
    func playActive()
}

class CompetitionPopupViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var sufficientPointsViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var sufficientPointsView: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomButtonTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    @IBOutlet weak var mainViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var pointsRequiredLabel: UILabel!
    var delegate: CompetitionPopUpDelegate?
    
    var requiredPoints : Int?

    var type: CardType = CardType.competition
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Common.shared.getUserPoints()
        let str = "You will require"
        let str1 = "silver points to play this pack."
        pointsRequiredLabel.text = String(format: "%@ %d %@" , str,requiredPoints!,str1)
        if type == CardType.competition {
            if isPointsRequired == false {
                cancelButton.isHidden = false
                buttonStackView.isHidden = true
                sufficientPointsView.isHidden = false
            }else
            {
                mainViewHeightConstraints.constant = 170
                buttonStackView.isHidden = false
                cancelButton.isHidden = true
                sufficientPointsView.isHidden = true
                sufficientPointsViewHeight.constant = 0
            }
        } else if type == CardType.voice {
            headerLabel.text = "Your Voice"
            if Common.shared.USER_POINT >= 25 {
                mainViewHeightConstraints.constant = 170
                buttonStackView.isHidden = false
                cancelButton.isHidden = true
                sufficientPointsView.isHidden = true
                sufficientPointsViewHeight.constant = 0
                pointsRequiredLabel.text = "Redeem 25 Points to raise a voice."
                playButton.setTitle("OK", for: .normal)

            } else {
                cancelButton.isHidden = false
                buttonStackView.isHidden = true
                sufficientPointsView.isHidden = false
                pointsRequiredLabel.text = "You must have 25 silver points to raise a voice."
            }
        }
        
        // Do any additional setup after loading the view.
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        delegate?.playActive()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
