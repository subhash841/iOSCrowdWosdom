//
//  NavigationBaseViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 06/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import TransitionButton

class NavigationBaseViewController: UIViewController {
    
    private var firstGradientColor: UIColor = UIColor(red:0.28, green:0.16, blue:0.57, alpha:1.0)
    private var secondGradientColor: UIColor = UIColor(red:0.03, green:0.63, blue:0.74, alpha:1.0)
    private var isBack = false
    private var isHomeMenu = false
    var isConfirm = false
    
    var isSearch = false
    var drawerView = UIView()
    var tintViewButton = UIButton()
    var drawerTableView = UITableView()
    var menuDrawerVC = MenuDrawerViewController()
    var isImageViewLoad = false
    
    lazy var leftBarImageView: UIImageView = {
        let imageview = UIImageView(frame: CGRect(x: 5, y: 12.5, width: 20, height: 15))
        return imageview
    }()
    
    lazy var leftButton: UIButton = {
        var button = UIButton()
        button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        return button
    }()
    
    private var noDataInfoView: UIView?
    private var noDataImage = UIImageView()
    private var noDataLabel = UILabel()
    private var noDataRetryButton = UIButton()

    var emptyViewY: CGFloat = -45
    
    lazy var emptyView: UIView = {
        var view = UIView(frame: CGRect(x: 0, y: Int(emptyViewY), width: Device.SCREEN_WIDTH, height: Device.SCREEN_HEIGHT))
        view.addSubview(emptyImageView)
        view.addSubview(emptyTextLabel)
        view.addSubview(emptyButton)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var emptyImageView: UIImageView = {
        // total hieght = 150+30+30 = 210/2 = 105 is y
        var imageView = UIImageView(frame: CGRect(x: (Device.SCREEN_BOUND.width/2)-75 , y: (Device.SCREEN_BOUND.height/2) - 105 + emptyViewY, width: 150, height: 150))
        return imageView
    }()
    
    lazy var emptyTextLabel: UILabel = {
        // (Device.SCREEN_BOUND.height/2)- 105 + 150 = (Device.SCREEN_BOUND.height/2) + 45 is y
        var label = UILabel(frame: CGRect(x: (Device.SCREEN_BOUND.width/2)-150, y: (Device.SCREEN_BOUND.height/2)+45 + emptyViewY, width: 300, height: 30))
        label.font = Common.shared.getFont(type: .regular, size: 17)
        label.textAlignment = .center
        return label
    }()
    
    lazy var emptyButton: UIButton = {
        //(Device.SCREEN_BOUND.height/2)+45 + 30 = (Device.SCREEN_BOUND.height/2)+75 + 25(padding)
        var button = UIButton(frame: CGRect(x: (Device.SCREEN_BOUND.width/2)-60, y: (Device.SCREEN_BOUND.height/2) + 90 + emptyViewY, width: 120, height: 30))
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(emptyButtonAction), for: .touchUpInside)
        button.backgroundColor = BLUE_COLOR
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()
    
    var emptyStateAction: (() -> Void)?
    var searchCompletion:(() -> Void)?
    
    var isEmptyState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyButton.layer.cornerRadius = 15
        print("titleView hieght:\(String(describing: self.navigationItem.titleView?.frame.size.height))")
        setupLeftBarButton(isback: false)
        self.navigationItem.titleView = setAppLogoToNavigationTitle()
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
        self.navigationController?.navigationBar.isTranslucent = false

        // add gradient to navigation bar
        if isImageViewLoad == true {
            addGradientTonavigationBar1()
        }else
        {
            addGradientTonavigationBar()
        }
        print("titleView hieght after:\(String(describing: self.navigationItem.titleView?.frame.size.height))")
        
        drawerTableView.register(UINib(nibName: "DrawerTableViewCell", bundle: nil), forCellReuseIdentifier: "DrawerTableViewCell")
        menuDrawerVC.closeDrawerDelegate = self
    }
    
    //MARK:- External Methods
    func setupLeftBarButton(isback: Bool, issearch: Bool = false) {
        isBack = isback
        isSearch = issearch
        if isback {
            leftBarImageView.image = UIImage(named: "backNavIcon")
        } else {
            leftBarImageView.image = UIImage(named: "menunavIcon")
        }
        leftButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        leftButton.addSubview(leftBarImageView)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func hideLfetBarButton() {
        leftButton.isHidden = true
        leftBarImageView.isHidden = true
        //self.navigationItem.leftBarButtonItem = nil
    }
    
    @objc func pressed() {
    
    }
    
    func addGradientTonavigationBar() {
        var colors = [UIColor]()
        colors.append(firstGradientColor)
        colors.append(secondGradientColor)
        navigationController?.navigationBar.setGradientBackground(colors: colors)
    }
    
    func addGradientTonavigationBar1() {
        var colors = [UIColor]()
        colors.append(firstGradientColor)
        colors.append(secondGradientColor)
        navigationController?.navigationBar.setGradientBackground1(colors: colors)
    }

    func setAppLogoToNavigationTitle() -> UIView {
        let width = self.navigationItem.titleView?.bounds.width ?? 200
        let height = self.navigationItem.titleView?.bounds.height ?? 65
        let logoView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let logoImageView = UIImageView()// 5 y
        if #available(iOS 11.0, *) {
             logoImageView.frame = CGRect(x: 20, y: 5, width: width-40, height: height/2) // 5 y
        } else {
             logoImageView.frame = CGRect(x: 20, y: 16, width: width-40, height: height/2) // 5 y
        }
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "navigationLogo")
        logoView.addSubview(logoImageView)
        return logoView
    }
    
    func fornavaigation() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "CardMainViewViewController") as! CardMainViewViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Button Actions
    @objc func goBack() {
        if isBack{
            if isHomeMenu {
                let transition = CATransition()
                transition.startProgress = 0
                transition.endProgress = 1.0
                transition.type = .push
                transition.subtype = .fromRight
                transition.duration = 0.30
                drawerView.alpha = 0
                isHomeMenu = false
                isBack = false
                tintViewButton.alpha = 0
                leftBarImageView.image = UIImage(named: "menunavIcon")
                drawerView.layer.add(transition, forKey: "transition")
            } else if isSearch {
                searchCompletion?()
                self.isSearch = false
            } else if isConfirm {
                let alert = UIAlertController(title: "", message: "Are you sure you want to go back?", preferredStyle: .alert)
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
                alert.addAction(noAction)
                let yesAction = UIAlertAction(title: "Yes", style: .default) { (_) in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(yesAction)
                self.present(alert, animated: true, completion:nil)
            }else if isImageViewLoad{
                let value = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.popViewController(animated: true)
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        } else{
            self.openDrawer()
        }
        
    }
    
    @objc func closeDrawer(){
        let transition = CATransition()
        transition.startProgress = 0
        transition.endProgress = 1.0
        transition.type = .push
        transition.subtype = .fromRight
        transition.duration = 0.30
        drawerView.alpha = 0
        isHomeMenu = false
        isBack = false
        tintViewButton.alpha = 0
        leftBarImageView.image = UIImage(named: "menunavIcon")
        drawerView.layer.add(transition, forKey: "transition")

    }

    @objc func openDrawer() {
        let transition = CATransition()
        transition.startProgress = 0
        transition.endProgress = 1.0
        transition.type = .push
        transition.subtype = .fromLeft
        transition.duration = 0.30

        let screenSize: CGRect = UIScreen.main.bounds
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
        
        if #available(iOS 11.0, *) {
            if Device.IS_IPHONE_6 || Device.IS_IPHONE_5 {
                drawerView = UIView(frame: CGRect(x: 0, y: 0 , width: Device.SCREEN_WIDTH - 60, height: Device.SCREEN_HEIGHT - 150))
            }else if Device.IS_IPHONE_6P{
                drawerView = UIView(frame: CGRect(x: 0, y: 0 , width: Device.SCREEN_WIDTH - 60, height: Device.SCREEN_HEIGHT-175))
            }
            else
            {
                drawerView = UIView(frame: CGRect(x: 0, y: 0 , width: Device.SCREEN_WIDTH - 60, height: Device.SCREEN_HEIGHT-200))
            }
        }else
        {
            drawerView = UIView(frame: CGRect(x: 0, y: Int(navigationBarHeight+20) , width: Device.SCREEN_WIDTH - 60, height: Device.SCREEN_HEIGHT - 150))
        }
        drawerView.backgroundColor = UIColor.red
        drawerView.layer.add(transition, forKey: "transition")
        leftBarImageView.image = UIImage(named: "backNavIcon")
        isBack = true
        isHomeMenu = true
        drawerView.alpha = 1
        leftButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        leftButton.addSubview(leftBarImageView)
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        tintViewButton = UIButton(frame: CGRect(x: 0, y: 0 , width: screenSize.width, height: screenSize.height))
        tintViewButton.backgroundColor = UIColor.black
        tintViewButton.alpha = 0.3
        tintViewButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        self.addChild(menuDrawerVC)
        drawerView.addSubview(menuDrawerVC.view)
        if Device.IS_IPHONE_6 || Device.IS_IPHONE_5 || Device.IS_IPHONE_6P {
            menuDrawerVC.setUpView(with: CGRect(x: 0, y: 0, width: Device.SCREEN_WIDTH-60, height: Device.SCREEN_HEIGHT-110))
        }else
        {
            menuDrawerVC.setUpView(with: CGRect(x: 0, y: 0, width: Device.SCREEN_WIDTH-60, height: Device.SCREEN_HEIGHT-170))
        }
        
        self.view.addSubview(tintViewButton)
        self.view.addSubview(drawerView)
    }

    //MARK:- New Empty states Info
    
    func setNoDataInfo(with frame: CGRect, image: String = "no-data", text: String = "No Data Available", sendToBack: Bool = false) {
        if let _ = noDataInfoView {
            noDataInfoView?.removeFromSuperview()
        }
        noDataInfoView = UIView(frame: frame)
        addNoDataImage(for: frame)
        noDataInfoView?.backgroundColor = .clear
        self.view.addSubview(noDataInfoView!)
        if sendToBack {
            self.view.sendSubviewToBack(noDataInfoView!)
        }
        addNoDataLabel(for: frame)
        noDataImage.image = UIImage(named: image)
        noDataLabel.text = text
    }
    
    func setNoInternetInfo(with frame: CGRect, backgroungColor: UIColor = .clear) {
        if let _ = noDataInfoView {
            noDataInfoView?.removeFromSuperview()
        }
        noDataInfoView = UIView(frame: frame)
        noDataInfoView?.backgroundColor = backgroungColor
        self.view.addSubview(noDataInfoView!)
        
        addNoDataImage(for: frame)
        addNoDataLabel(for: frame)
        addNoDataRetryButton(for: frame)
        noDataImage.image = UIImage(named: "no-connection")
        noDataLabel.text = "No Internet Connection"
    }
    
    private func addNoDataImage(for frame: CGRect) {
        noDataImage = UIImageView(frame: CGRect(x: (frame.size.width/2)-75 , y: (frame.size.height/2) - 105 + emptyViewY, width: 150, height: 150))
        noDataInfoView?.addSubview(noDataImage)
    }
    
    private func addNoDataLabel(for frame: CGRect) {
        noDataLabel = UILabel(frame: CGRect(x: (frame.size.width/2)-150, y: (frame.size.height/2)+45 + emptyViewY, width: 300, height: 30))
        noDataLabel.font = Common.shared.getFont(type: .regular, size: 17)
        noDataLabel.textAlignment = .center
        noDataInfoView?.addSubview(noDataLabel)
    }
    
    private func addNoDataRetryButton(for frame: CGRect) {
        noDataRetryButton = UIButton(frame: CGRect(x: (frame.size.width/2)-60, y: (frame.size.height/2) + 90 + emptyViewY, width: 120, height: 30))
        noDataRetryButton.setTitle("Retry", for: .normal)
        noDataRetryButton.setTitleColor(UIColor.white, for: .normal)
        noDataRetryButton.addTarget(self, action: #selector(emptyButtonAction), for: .touchUpInside)
        noDataRetryButton.backgroundColor = BLUE_COLOR
        noDataRetryButton.layer.cornerRadius = 15
        noDataRetryButton.layer.masksToBounds = true
        noDataInfoView?.addSubview(noDataRetryButton)
    }
    
    func hideNoDataInfo() {
        if let _ = noDataInfoView {
            noDataInfoView?.removeFromSuperview()
        }
    }
    
    func setLoginView()  {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    //MARK:- Empty States
    func setNoDataState() {
        emptyImageView.image = UIImage(named: "no-data")
        emptyTextLabel.text = "No Data Available"
        emptyButton.isHidden = true
        self.view.addSubview(emptyView)
    }
    
    func setNoConnectionState() {
//        hideViews()
        emptyImageView.image = UIImage(named: "no-connection")
        emptyTextLabel.text = "No Internet Connection"
        emptyButton.isHidden = false
        emptyView.backgroundColor = UIColor.white
        self.view.addSubview(emptyView)
    }
    
    func setNoCommentState() {
        emptyImageView.image = UIImage(named: "no-comment")
        emptyTextLabel.text = "No Comments Available"
        emptyButton.isHidden = true
        emptyView.backgroundColor = UIColor.clear
        self.view.addSubview(emptyView)
    }
    
    func setNoReplyState() {
        emptyImageView.image = UIImage(named: "no-comment")
        emptyTextLabel.text = "No Replies Available"
        emptyButton.isHidden = true
        emptyView.backgroundColor = UIColor.clear
        self.view.addSubview(emptyView)
//        self.view.sendSubviewToBack(emptyView)
    }
    
    @objc func emptyButtonAction() {
        if NetworkStatus.shared.haveInternet() {
            //emptyButton.startAnimation()
            emptyStateAction?()
        } else {
            stopAnimationEmptyState()
        }
    }
    
    func refreshEmptyButton() {
        emptyButton.setTitle("Retry", for: .normal)
        emptyButton.setTitleColor(UIColor.white, for: .normal)
        emptyButton.layer.cornerRadius = 15
        emptyButton.layer.masksToBounds = true
    }
    
    func hideViews() {
        self.view.subviews.forEach { (view) in
            view.isHidden = true
        }
    }
    
    func showViews() {
        self.view.subviews.forEach { (view) in
            view.isHidden = false
        }
    }
    
    func hideEmptyStateView(){
//        showViews()
        self.emptyView.removeFromSuperview()
    }
    func stopAnimationEmptyState() {
//        self.emptyButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.5, completion: {
//            self.refreshEmptyButton()
//        })
    }
}

extension NavigationBaseViewController:DrawerCloseDelegate {
    func closeDrawerHome() {
        closeDrawer()
    }
}
