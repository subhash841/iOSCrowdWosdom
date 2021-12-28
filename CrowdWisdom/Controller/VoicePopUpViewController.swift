//
//  VoicePopUpViewController.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 1/11/19.
//  Copyright © 2019 Gaurav. All rights reserved.
//

import UIKit

protocol CreateBlogDelegate {
    func createBlog()
}
class VoicePopUpViewController: UIViewController {

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    var delegate: CreateBlogDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointsLabel.text = "\(Common.shared.USER_POINT)"
        if Common.shared.USER_POINT >= 25 {
            infoLabel.text = "Redeem 25 points to create a blog."
            descriptionLabel.text = ""
            dismissButton.isHidden = true
        } else {
            cancelButton.isHidden = true
            createButton.isHidden = true
        }
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        delegate?.createBlog()
    }
}
