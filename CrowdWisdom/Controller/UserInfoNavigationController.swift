//
//  UserInfoNavigationController.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 1/9/19.
//  Copyright © 2019 Gaurav. All rights reserved.
//

import UIKit

class UserInfoNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if USERID == "0" {
            setLoginPage()
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
            self.pushViewController(vc, animated: true)
        }
    }
    
    
    func setLoginPage() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.isFromAction = true
        vc.isTab = true
        vc.delegate = self
        self.pushViewController(vc, animated: true)
//        let nvc = UINavigationController(rootViewController: vc)
//        self.present(nvc, animated: true, completion: nil)
//        self.pushViewController(vc, animated: true)
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

extension UserInfoNavigationController: LoginViewDelegate {
    func loginSuccessful() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
        self.pushViewController(vc, animated: true)
    }
}
