//
//  MenuDrawerViewController.swift
//  CrowdWisdom
//
//  Created by  user on 11/22/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

@objc protocol DrawerCloseDelegate {
    func closeDrawerHome()
}
class MenuDrawerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var drawerTableView = UITableView()
    var closeDrawerDelegate : DrawerCloseDelegate?
    private var menuDrawerArray = [userDetails]()
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    var isProfile = false
//    var menuDrawerArray = ["Home", "Search By topic", "Notification","Packages", "Prediction", "Ask Questions","Your Voice", "Wall", "Rated Article","Profile", "Logout"]
    

    struct menuImagesDrawer {
        let aboutUsIcon = "aboutUs_Drawer"
        let searchBytopicIcon = "searchbytopic_Drawer"
        let notificationIcon = "notification_Drawer"
        let packagesIcon = "packges_Drawer"
        let predictionIcon = "predictions_Drawer"
        let askQuestionsIcon = "askquestion_Drawer"
        let yourVoiceIcon = "yourvoice_Drawer"
        let wallIcon = "wall_Drawer"
        let ratedArticleIcon = "ratedarticle_Drawer"
        let profileIcon = "profile_Drawer"
        let logoutIcon = "logout_Drawer"
        let loginIcon = "login_Drawer"
        
    }
    
    struct menuNameDrawer {
        let aboutUs = "About Us"
        let searchBytopic = "Search By topic"
        let notification = "Notification"
        let packages = "Competitions"
        let prediction = "Predictions"
        let askQuestions = "Questions"
        let yourVoice = "Your Voice"
        let wall = "Discussion Wall"
        let ratedArticle = "From The Web"
        let profile = "Profile"
        let logout = "Logout"
        let login = "Log In"
        
    }
    
    struct userDetails  {
        let name: String
        let image: String
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(menuDrawerArraySet), name: NSNotification.Name(rawValue: UpdateDrawerListingAfterLogin), object: nil)

        menuDrawerArraySet()
//        drawerTableView.bounces = false
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @objc func menuDrawerArraySet() {
        menuDrawerArray.removeAll()
        let first = userDetails(name: menuNameDrawer().aboutUs, image: menuImagesDrawer().aboutUsIcon)
        let second = userDetails(name: menuNameDrawer().searchBytopic, image: menuImagesDrawer().searchBytopicIcon)
        let third = userDetails(name: menuNameDrawer().notification, image: menuImagesDrawer().notificationIcon)
        let four = userDetails(name: menuNameDrawer().packages, image: menuImagesDrawer().packagesIcon)
        let five = userDetails(name: menuNameDrawer().prediction, image: menuImagesDrawer().predictionIcon)
        let six = userDetails(name: menuNameDrawer().askQuestions, image: menuImagesDrawer().askQuestionsIcon)
        let seven = userDetails(name: menuNameDrawer().yourVoice, image: menuImagesDrawer().yourVoiceIcon)
        let eight = userDetails(name: menuNameDrawer().wall, image: menuImagesDrawer().wallIcon)
        let nine = userDetails(name: menuNameDrawer().ratedArticle, image: menuImagesDrawer().ratedArticleIcon)
        let ten = userDetails(name: menuNameDrawer().profile, image: menuImagesDrawer().profileIcon)
        let eleven = userDetails(name: menuNameDrawer().logout, image: menuImagesDrawer().logoutIcon)
        let twelve = userDetails(name: menuNameDrawer().login, image: menuImagesDrawer().loginIcon)

        menuDrawerArray.append(four)
        menuDrawerArray.append(five)
        menuDrawerArray.append(six)
        menuDrawerArray.append(seven)
        menuDrawerArray.append(eight)
        menuDrawerArray.append(nine)
        if USERID == "0" {
            menuDrawerArray.append(twelve)
        }else
        {
//            menuDrawerArray.append(third)
            menuDrawerArray.append(eleven)
        }
        
    }
    func setUpView(with frame: CGRect) {
        self.view.frame = frame
        drawerTableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.view.addSubview(drawerTableView)
        drawerTableView.backgroundColor = UIColor.white
        drawerTableView.register(UINib(nibName: "DrawerTableViewCell", bundle: nil), forCellReuseIdentifier: "DrawerTableViewCell")
        drawerTableView.register(UINib(nibName: "DrawerHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "DrawerHeaderTableViewCell")

        drawerTableView.delegate = self
        drawerTableView.dataSource = self
        drawerTableView.separatorStyle = .none
        drawerTableView .reloadData()
    }

    // MARK: - table View

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if USERID == "0" {
            return menuDrawerArray.count
        }else
        {
            return menuDrawerArray.count + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if USERID == "0" {
            let cell : DrawerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DrawerTableViewCell", for: indexPath) as! DrawerTableViewCell
            let dict = menuDrawerArray[indexPath.row]
            cell.drawerMenuName?.text = dict.name
            cell.drawerMenuImage?.image =  UIImage(named: dict.image)
            return cell
        }else
        {
            if indexPath.row == 0 {
                let cell : DrawerHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DrawerHeaderTableViewCell", for: indexPath) as! DrawerHeaderTableViewCell
                if USERID == "0"{
                    cell.userNameLabel?.text = "User Name"
                }else
                {
                    cell.isHidden = false
                    cell.bgImageView.isHidden = true
                    cell.userNameLabel.isHidden = false
                    let dict = Common.shared.getUserInfo()
                    if let aliasName = dict["alias"] as? String {
                        cell.userNameLabel?.text = aliasName
                    }
                    cell.editProfileButton.setTitle("View Profile", for: .normal)
                    cell.editProfileButton.isUserInteractionEnabled = false
                }
                return cell
            }else
            {
                let cell : DrawerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DrawerTableViewCell", for: indexPath) as! DrawerTableViewCell
                let dict = menuDrawerArray[indexPath.row - 1]
                
                cell.drawerMenuName?.text = dict.name
                cell.drawerMenuImage?.image =  UIImage(named: dict.image)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.closeDrawerDelegate?.closeDrawerHome()
        if USERID == "0" {
            if indexPath.row == 6{
                self.setLoginPage()
            }
            else{
                let cardViewController = storyBoard.instantiateViewController(withIdentifier: "CardMainViewViewController") as! CardMainViewViewController
                if indexPath.row == 0{
                    cardViewController.type = CardType.competition
                }else if indexPath.row == 1{
                    cardViewController.type = CardType.prediction
                }else if indexPath.row == 2{
                    cardViewController.type = CardType.askQuestion
                }else if indexPath.row == 3{
                    cardViewController.type = CardType.voice
                }else if indexPath.row == 4{
                    cardViewController.type = CardType.discussion
                }else if indexPath.row == 5{
                    cardViewController.type = CardType.ratedArticle
                }
                self.navigationController?.pushViewController(cardViewController, animated: true)
            }
        }else
        {
            if indexPath.row == 0 {
                let profileVC = storyBoard.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
                profileVC.isDrawer = true
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
            else if indexPath.row == 7{
                self.logOutApp()
            }
            else{
                let cardViewController = storyBoard.instantiateViewController(withIdentifier: "CardMainViewViewController") as! CardMainViewViewController
                if indexPath.row == 1{
                    cardViewController.type = CardType.competition
                }else if indexPath.row == 2{
                    cardViewController.type = CardType.prediction
                }else if indexPath.row == 3{
                    cardViewController.type = CardType.askQuestion
                }else if indexPath.row == 4{
                    cardViewController.type = CardType.voice
                }else if indexPath.row == 5{
                    cardViewController.type = CardType.discussion
                }else if indexPath.row == 6{
                    cardViewController.type = CardType.ratedArticle
                }
                self.navigationController?.pushViewController(cardViewController, animated: true)
            }
        }
    }

    func logOutApp() {
        let alertController = UIAlertController(title: "Are you sure you want to logout from the app?", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            DispatchQueue.main.async {
                Common.shared.logoutUser()
                Common.shared.loadInfo()
                Common.shared.userInfoDict.removeValue(forKey: "UserData")
                Common.shared.saveInfo()
                UserDefaults.standard.set(false, forKey: IS_USER_LOGIN)
                UserDefaults.standard.synchronize()
                USERID = "0"
                NotificationCenter.default.post(name: Notification.Name(LogoutNotification), object: nil)
            }
        }))
        alertController.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in
            self.dismiss(animated: true)
        }))
        present(alertController, animated: true)
    }
    
    func setLoginPage() {
        let vc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.isFromAction = true
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
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
extension MenuDrawerViewController: LoginViewDelegate {
    func loginSuccessful() {
        if isProfile == true {
            let profileVC = storyBoard.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
            profileVC.isDrawer = true
            self.navigationController?.pushViewController(profileVC, animated: true)
        }else{
            let cardView = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
            self.navigationController?.pushViewController(cardView, animated: false)
        }
        menuDrawerArray.removeAll()
        self.menuDrawerArraySet()
    }
}
