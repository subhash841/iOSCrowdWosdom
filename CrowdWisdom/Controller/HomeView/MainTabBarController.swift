//
//  MainTabBarController.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 10/16/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import os.log
import GoogleSignIn
import FacebookLogin
import FacebookCore
import TwitterKit

class MainTabBarController: UITabBarController {
    
    @IBOutlet var optionsView: UIView!
    
    var secondItemImageView: UIImageView!
    var firstItemImageView: UIImageView!
    var thirdItemImageView: UIImageView!
    var indicatorImage: UIImageView?
    var tabBarItemSize: CGSize?
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

    var isSet: Bool = false {
        didSet {
            //            os_log("is set value changed")
            if isSet {
                addOptionsView()
                
            } else {
                removeOptionsiew()
            }
        }
    }
    
    lazy var playAndWinViewController: PlayAndWinViewController = storyboard?.instantiateViewController(withIdentifier: "PlayAndWinViewController") as! PlayAndWinViewController
    lazy var newNavigationController: UINavigationController = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarItems()
        registernotificationCenter()
        
//        if let profileTab = tabBar.items?[2]{
//            profileTab.isEnabled = false
//        }
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Notification Center
    
    private func registernotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(logoutUser),
            name: NSNotification.Name(rawValue: LogoutNotification),
            object: nil)
    }
    
    @objc func logoutUser(notification: NSNotification){
        //do stuff
        //TWTRTwitter
        let store = TWTRTwitter.sharedInstance().sessionStore
        
        if let userID = store.session()?.userID {
            store.logOutUserID(userID)
        }
        LoginManager().logOut()
        GIDSignIn.sharedInstance()?.signOut()
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
        
//        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func createSelectionIndicator(color: UIColor, size: CGSize, lineHeight: CGFloat, lineWidth:CGFloat, isFlat:Bool) -> UIImageView {
        var xpos = CGFloat(0)
        xpos = size.width/3 - lineWidth/2
        //        if isFlat{
        //            xpos = size.width/3 - lineWidth/2
        //        } else{
        //            xpos = size.width/3 - lineWidth/2
        //        }
        let rect: CGRect = CGRect(x: xpos, y: size.height/2 - lineWidth/2 - 5, width: lineWidth, height: lineHeight)
        let view = UIImageView(frame: rect)
        view.image = UIImage(named: "tabBarSelectionIcon")
        //        view.layer.borderColor = color.cgColor
        //        view.layer.borderWidth = 1
        //        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        //        color.setFill()
        //        UIRectFill(rect)
        //        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        //        UIGraphicsEndImageContext()
        return view
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeOptionsiew()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if isSet {
            isSet = !isSet
        }
                
        var centerX = CGFloat(0)
        let number = -(tabBar.items?.index(of: item)?.distance(to: 0))! + 1
        if number == 1 {
            centerX = tabBar.frame.width/3/2
        } else if number == 2 {
            centerX =  tabBar.frame.width/3/2 + tabBar.frame.width/3
        } else if number == 3 {
                centerX =  tabBar.frame.width/3/2 + 2 * tabBar.frame.width/3
        } else {
            centerX = tabBar.frame.width - tabBar.frame.width/3/2
        }
        UIView.animate(withDuration: 0.6, animations: {
            self.indicatorImage?.alpha = 0
            self.indicatorImage?.center.x =  centerX
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.06
            animation.repeatCount = 2
            animation.autoreverses = true
            let rotation = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            self.indicatorImage?.transform = rotation
        }) { (completed) in
            var imgView = UIImageView()
            if item.tag == 0{
                //do our animations
                imgView = self.firstItemImageView
            } else if item.tag == 1{
                imgView = self.secondItemImageView
            } else if item.tag == 2{
                imgView = self.thirdItemImageView
            }
            self.indicatorImage?.alpha = 1
            imgView.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 0.7, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { () -> Void in
                
                let midX = self.secondItemImageView.center.x
                let midY = self.secondItemImageView.center.y
                
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.06
                animation.repeatCount = 2
                animation.autoreverses = true
                animation.fromValue = CGPoint(x: midX - 3, y: midY)
                animation.toValue = CGPoint(x: midX + 3, y: midY)
                imgView.layer.add(animation, forKey: "position")
            }, completion: {completed in
                
            })
        }
        
        if selectedIndex == 3 {
            let profileVC = storyBoard.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
            profileVC.isWalletShow = false
            profileVC.isProfileData = true
        }
        if selectedIndex == 1 && USERID == "0"{
//            let vc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            vc.isFromAction = true
//            vc.delegate = self
//            let nav = UINavigationController(rootViewController: vc)
//            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func setTabBarItems(){
        
        
        let myTabBarItem1 = self.tabBar.subviews[0]
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.tabBar.frame.width / 3, height: myTabBarItem1.frame.height))
        button.center.x = self.tabBar.frame.width / 3 / 2
        button.addTarget(self, action: #selector(toggleView), for: .touchUpInside)
        //        button.backgroundColor = UIColor.black
        self.tabBar.addSubview(button)
        
        self.selectedIndex = 1
        self.navigationController?.isNavigationBarHidden = true
        
        let secondItemView = self.tabBar.subviews[1]
        self.secondItemImageView = secondItemView.subviews.first as? UIImageView
        self.secondItemImageView.contentMode = .center
        
        let firstItemView = self.tabBar.subviews[0]
        self.firstItemImageView = firstItemView.subviews.first as? UIImageView
        self.firstItemImageView.contentMode = .center
        
        let thirdItemView = self.tabBar.subviews[2]
        self.thirdItemImageView = thirdItemView.subviews.first as? UIImageView
        self.thirdItemImageView.contentMode = .center
        
        let numberOfItems = CGFloat(tabBar.items!.count)
        tabBarItemSize = CGSize(width: (tabBar.frame.width / numberOfItems) - 20, height: tabBar.frame.height)
        indicatorImage = createSelectionIndicator(color: UIColor(red:0.18, green:0.66, blue:0.24, alpha:1.0), size: tabBarItemSize!, lineHeight: 30, lineWidth: 30, isFlat: false)
        indicatorImage?.contentMode = .scaleToFill
        indicatorImage?.clipsToBounds = true
        indicatorImage?.layer.masksToBounds = true
        indicatorImage?.layer.shouldRasterize = true
        indicatorImage?.layer.cornerRadius = 15
        indicatorImage?.center.x = tabBar.frame.width/3/2 + tabBar.frame.width/3
        tabBar.insertSubview(indicatorImage!, at: 0)
        
    }
    
    @objc func toggleView(){
        isSet = !isSet
        let centerX = tabBar.frame.width/3/2
        //        let firstItemView =
        //        let image = Common.shared.resizeImage(image: (UIImage(named: "34.png")?.withRenderingMode(.alwaysOriginal))!, targetSize: CGSize(width: 30, height: 30))
        //        image.size = CGSize(width: 30, height: 30)
        //        firstItemImageView.image = image
        UIView.animate(withDuration: 0.5, animations: {
            self.indicatorImage?.alpha = 0
            self.indicatorImage?.center.x =  centerX
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.05
            animation.repeatCount = 2
            animation.autoreverses = true
            let rotation = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
            self.indicatorImage?.transform = rotation
        }) { (completed) in
            var imgView = UIImageView()
            //            if item.tag == 0{
            //do our animations
            imgView = self.firstItemImageView
            //            } else if item.tag == 1{
            //                imgView = self.secondItemImageView
            //            } else if item.tag == 2{
            //                imgView = self.thirdItemImageView
            //            }
            self.indicatorImage?.alpha = 1
            imgView.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 0.6, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { () -> Void in
                
                let midX = self.secondItemImageView.center.x
                let midY = self.secondItemImageView.center.y
                
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.05
                animation.repeatCount = 2
                animation.autoreverses = true
                animation.fromValue = CGPoint(x: midX - 3, y: midY)
                animation.toValue = CGPoint(x: midX + 3, y: midY)
                imgView.layer.add(animation, forKey: "position")
            }, completion: {completed in
                
            })
        }
        //        self.selectedIndex = 0
        
    }
    
    func removeOptionsiew() {
        if let view1 = self.view.viewWithTag(100), let view2 = self.view.viewWithTag(200) {
            view1.removeFromSuperview()
            view2.removeFromSuperview()
        }
    }
    
    func addOptionsView() {
        //        optionsView.removeFromSuperview()
        
        optionsView.frame = CGRect(x: 40, y: UIScreen.main.bounds.height - self.tabBar.frame.height - 90, width: 210, height: 70)
        optionsView.tag = 100
        let blurView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - self.tabBar.frame.height))
        blurView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        //        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        //        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //        blurEffectView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - self.tabBar.frame.height)
        //        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.tag = 200
        self.view.addSubview(blurView)
        
        self.view.addSubview(optionsView)
    }
    
    
    @IBAction func packagesButtonTapped(_ sender: UIButton) {
        //        newNavigationController.r
        openView = 0
        fromTabBar = selectedIndex
        
        if selectedIndex == 0{
            let vc = self.viewControllers![0] as! UINavigationController
            let vcController = vc.viewControllers.first as! MoreOptionsViewController
            vcController.switchViews()
            
        }
        selectedIndex = 0
//        removeOptionsiew()
        isSet = false
    }
    
    @IBAction func howItWorkBtnAction(_ sender: Any) {
        openView = 2
        fromTabBar = selectedIndex
        
        if selectedIndex == 0{
//            if tabBarController != nil{
                let vc = self.viewControllers![0] as! UINavigationController
            let vcController = vc.viewControllers.first as! MoreOptionsViewController
            vcController.switchViews()
//                vc.switchViews()
//            }
        }
        selectedIndex = 0
//        removeOptionsiew()
        isSet = false
    }
    
    @IBAction func walletButtonAction(_ sender: Any) {
        if USERID == "0" {
            self.setLoginView()
        }else
        {
            openView = 1
            fromTabBar = selectedIndex
            
            if selectedIndex == 0{
                let vc = self.viewControllers![0] as! UINavigationController
                let vcController = vc.viewControllers.first as! MoreOptionsViewController
                vcController.switchViews()
            }
            selectedIndex = 0
            //        removeOptionsiew()
            isSet = false

        }
    }
    
    func setLoginView() {
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
extension MainTabBarController:LoginViewDelegate{
    func loginSuccessful() {
        openView = 1
        fromTabBar = selectedIndex
        
        if selectedIndex == 0{
            let vc = self.viewControllers![0] as! UINavigationController
            let vcController = vc.viewControllers.first as! MoreOptionsViewController
            vcController.switchViews()
        }
        selectedIndex = 0
        isSet = false
    }
}
