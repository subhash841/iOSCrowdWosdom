//
//  GameDetailViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 11/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class GameDetailViewController: NavigationBaseViewController {

    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var numberOfQuestionLabel: UILabel!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var rewardImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // Do any additional setup after loading the view.
    }
    func setUI() {
        setupLeftBarButton(isback: true)
        proceedButton.contentHorizontalAlignment = .right
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
