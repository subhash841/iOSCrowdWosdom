////
////  TabContainerViewController.swift
////  TabBarAnimationDemo
////
////  Created by sunday on 10/4/18.
////  Copyright © 2018 sunday. All rights reserved.
////
//
//import UIKit
////import BATabBarController
//
////MARK:- Tab bar type enum
//
//enum TabBarType {
//    case BATabBarTypeWithText, BATabBarTypeNoText
//}
//
//class HomeContainerViewController: NavigationSearchViewController {
//
//
//    private let tabBarType: TabBarType = .BATabBarTypeWithText
//    private var isFirstTime = true
//
//    // Tab bars
//    private lazy var tipTabBar: BATabBarItem = {
//        let tabBarItem1 = BATabBarItem()
//        return tabBarItem1
//    }()
//
//    private lazy var homeTabBar: BATabBarItem = {
//        let tabBarItem1 = BATabBarItem()
//        return tabBarItem1
//    }()
//
//    private lazy var userProfileTabBar: BATabBarItem = {
//        let tabBarItem1 = BATabBarItem()
//        return tabBarItem1
//    }()
//
//
//    //View controllers
//    private lazy var toolTipVC: UserProfileViewController = {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
//        vc.view.backgroundColor = .red
//        return vc
//    }()
//
//    private lazy var homeVC: HomeViewController = {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        vc.view.backgroundColor = .white
//        return vc
//    }()
//
//    private lazy var userProfileVC: UserProfileViewController = {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
//        vc.view.backgroundColor = .yellow
//        return vc
//    }()
//
//    private lazy var barController: BATabBarController = {
//        let vc = BATabBarController()
//        let controllers = [homeVC, toolTipVC, userProfileVC]//[toolTipVC, homeVC, userProfileVC]
//        vc.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
//         //vc.viewControllers = controllers
//        vc.tabBarItems = [tipTabBar,homeTabBar,userProfileTabBar]
//        vc.delegate = self
//        return vc
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        isFirstTime = true
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//     super.viewDidAppear(true)
//        self.navigationController?.navigationBar.isHidden = true
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        //self.navigationController?.navigationBar.isHidden = true
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        self.navigationController?.navigationBar.isHidden = false
//    }
//
//    override func viewDidLayoutSubviews() {
//
//        if (isFirstTime) {
//
//            switch tabBarType {
//
//            case .BATabBarTypeNoText:
//                loadwithNoText()
//
//            default:
//                loadWithText()
//
//            }
//
//            let controllers = [homeVC, toolTipVC, userProfileVC]//toolTipVC
//            let array =  controllers.compactMap { UINavigationController(rootViewController: $0)}
//            print("array:\(array)")
//
//            barController.setSelectedView(array[1], with: 1, animated: false)
//            //barController.setSelectedView(homeVC, animated: false)
//            self.view.addSubview(barController.view)
//            barController.tabBarBackgroundColor = UIColor.lightGray
//            APP_DELEGATE.tabBarController = barController
//            isFirstTime = false
//        }
//    }
//
//    private func loadWithText() {
//
//        let option1 = NSMutableAttributedString(string: "Feed")
//        option1.addAttribute(.foregroundColor, value: UIColor(hex: 0xf0f2f6), range: NSRange(location: 0, length: option1.length))
//        tipTabBar = BATabBarItem(image: UIImage(named: "icon1_unselected"), selectedImage: UIImage(named: "icon1_selected"), title: option1)
//
//        let option2 = NSMutableAttributedString(string: "Home")
//        option2.addAttribute(.foregroundColor, value: UIColor(hex: 0xf0f2f6), range: NSRange(location: 0, length: option2.length))
//        homeTabBar = BATabBarItem(image: UIImage(named: "icon2_unselected"), selectedImage: UIImage(named: "icon2_selected"), title: option2)
//
//        let option3 = NSMutableAttributedString(string: "Profile")
//        option3.addAttribute(.foregroundColor, value: UIColor(hex: 0xf0f2f6), range: NSRange(location: 0, length: option3.length))
//        userProfileTabBar = BATabBarItem(image: UIImage(named: "icon3_unselected"), selectedImage: UIImage(named: "icon3_selected"), title: option3)
//
//    }
//
//    private func loadwithNoText() {
//
//        tipTabBar = BATabBarItem(image: UIImage(named: "icon1_unselected"), selectedImage: UIImage(named: "icon1_selected"))
//
//        homeTabBar = BATabBarItem(image: UIImage(named: "icon2_unselected"), selectedImage: UIImage(named: "icon2_selected"))
//
//        userProfileTabBar = BATabBarItem(image: UIImage(named: "icon3_unselected"), selectedImage: UIImage(named: "icon3_selected"))
//
//    }
//}
//
//extension HomeContainerViewController: BATabBarControllerDelegate {
//
//    func tabBarController(_ tabBarController: BATabBarController!, didSelect viewController: UIViewController!) {
//        print("tab bar is selected")
//    }
//
//
//}
