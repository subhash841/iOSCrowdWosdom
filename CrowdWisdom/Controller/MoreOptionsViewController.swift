//
//  MoreOptionsViewController.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 10/25/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class MoreOptionsViewController: NavigationBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switchViews()
    }
    
    func switchViews(){

        for vc in self.children{
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }

        switch openView {
        case 0:
            let cardViewController = storyboard?.instantiateViewController(withIdentifier: "CardMainViewViewController") as! CardMainViewViewController
            cardViewController.type = CardType.competition
//            let playWinVC = storyboard?.instantiateViewController(withIdentifier: "PlayAndWinViewController")
            self.addChild(cardViewController)
            self.view.addSubview((cardViewController.view)!)
            cardViewController.setFloatingMenu(fromTab: true)
            break
        case 1:
            
//            let walletVC = storyboard?.instantiateViewController(withIdentifier: "WalletViewController")
//            self.addChild(walletVC!)
//            self.view.addSubview(walletVC!.view)
            
//            let vc = UserInfoViewController(nibName: "UserInfoViewController", bundle: nil)

            let profileVC = storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
            profileVC.isWalletShow = true
            profileVC.view.frame = self.view.bounds
            self.addChild(profileVC)
            self.view.addSubview(profileVC.view)

            break
        case 2:
            let vc = HowItWorksViewController(nibName: "HowItWorksViewController", bundle: nil)
            vc.view.frame = self.view.bounds
            self.addChild(vc)
            self.view.addSubview(vc.view)
            break
        default:
            break
        }
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
