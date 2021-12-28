//
//  UserProfileViewController.swift
//  CrowdWisdom
//
//  Created by sunday on 10/9/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import BLKFlexibleHeightBar

class UserProfileViewController: NavigationBaseViewController {
    
    @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileScrollView: UIScrollView!
    @IBOutlet weak var gradientImageView: UIImageView!
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var topFlexibleBar: BLKFlexibleHeightBar!
    @IBOutlet weak var userWalletView: UIStackView!
    @IBOutlet weak var headerViewName: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    var initialNaviBarFrame : CGRect?
    
    @IBOutlet weak var testViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalCoinsLabel: UILabel!
    @IBOutlet weak var verifyMobileView: UIView!
    var statusBarHeight: CGFloat = 20
    var navigationBarHeight: CGFloat = 44
    var topBarHeightConstraintMax:CGFloat = 160
    var centerArrays = [CGPoint]()
    var isNavigationSet = false
    var isDrawer = false
    var dataProfile : ProfileData?
    
    private let imageView = UIImageView(image: UIImage(named: "dummyImage"))
    
    lazy var headerLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 65))
        label.textColor = UIColor.white
        label.font = Common.shared.getFont(type: .bold, size: 19)
        label.text = headerViewName.text
        label.textAlignment = .center
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProfileData()
        self.statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        
        if let navHeight = self.navigationController?.navigationBar.frame.height{
            self.navigationBarHeight = navHeight
        }
        
        topBarHeightConstraintMax = 160
        topBarHeightConstraint.constant = topBarHeightConstraintMax
        
        transactionTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        transactionTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        if isDrawer == true{
            setupLeftBarButton(isback: true)
        }
        profileScrollView.delegate = self
        //        profileScrollView.delegate = topFlexibleBar.behaviorDefiner
        profileScrollView.contentInset = UIEdgeInsets(top: 160, left: 0, bottom: 0, right: 0)
        
        //        setupNavigationBarAndToolbar()
//        setupNavigationBarAndToolbar()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        if !isNavigationSet{
        setupNavigationBarAndToolbar()
        //        }
        //        gradientImageView.frame = CGRect(x: gradientImageView.frame.origin.x, y: gradientImageView.frame.origin.y, width: CGFloat(Device.SCREEN_WIDTH), height: gradientImageView.frame.height)
        //        centerArrays[3] = gradientImageView.center
        //        setCollapsibleView(view: gradientImageView, index: 3)
        //        self.transactionTableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
    }
    
    func setupNavigationBarAndToolbar(){
        initialNaviBarFrame = self.navigationController?.navigationBar.frame
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        self.navigationController?.navigationBar.backgroundimage
        //        self.navigationController?.navigationBar.shadowImage = UIImage()
        //        self.navigationController?.navigationBar.isTranslucent = false
        //        self.navigationController?.navigationBar.barTintColor = .orange
        //        self.navigationController?.view.backgroundColor = .clear
        //        self.navigationController?.navigationBar.backgroundColor = .orange
        //        self.navigationItem.title = "test"
        //        setupUI()
        centerArrays.removeAll()
        centerArrays.append(headerViewName.center)
        centerArrays.append(userWalletView.center)
        centerArrays.append(verifyMobileView.center)
        centerArrays.append(gradientImageView.center)
//        setcollapsibleToolbar()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "center"{
            
            let newValue = change?[.newKey] as! CGPoint
            print("Changed Value \(newValue)")
            if newValue.y <= 180{
                self.navigationItem.titleView = headerLabel
//                self.navigationItem.title = "Sameer 1234"
            }else {
                //                self.navigationItem.titleView?.isHidden = false
                //self.navigationItem.titleView = Common.shared.setAppLogoToNavigationTitle()
                self.navigationItem.titleView = setAppLogoToNavigationTitle()
            }
        } else if keyPath == "contentSize" {
            tableViewHeight.constant = transactionTableView.contentSize.height
            
        }
    }
    
    deinit {
        transactionTableView.removeObserver(self, forKeyPath: "contentSize")
        topFlexibleBar.subviews.forEach { (view) in
            view.removeObserver(self, forKeyPath: "center")
        }
    }
    
    @IBAction func verifyMobileTapped(_ sender: UIButton) {
    }
    
}

//extension UserProfileViewController:UIScrollViewDelegate{
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y >= 100{
////            self.navigationItem.titleView?.isHidden = true
////            self.navigationItem.title = "Sameer 1234"
//            self.navigationItem.titleView = headerLabel
//
//        } else{
//            self.navigationItem.titleView = Common.shared.setAppLogoToNavigationTitle()
////            self.navigationItem.title = ""
////            self.navigationItem.titleView?.isHidden = false
//        }
//    }
//}


extension UserProfileViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "showWallet", sender: self)
        }
    }
}

extension UserProfileViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.type = ProfileCellType.points
            if let silver = dataProfile?.total_silver, silver != "" {
                cell.emailIDLabel.text = silver
            }else {
                cell.emailIDLabel.text = "-"
            }
            
            if let gold = dataProfile?.total_gold {
                cell.partyAffiliationLabel.text = "\(gold)"
            }else {
                cell.partyAffiliationLabel.text = "-"
            }
            
            if let diamond = dataProfile?.total_diamond {
                cell.locationLabel.text = "\(diamond)"
            }else {
                cell.locationLabel.text = "-"
            }
            cell.historyButton.isHidden = false
        case 1:
            
            cell.type = ProfileCellType.basic
            if let email = dataProfile?.email, email != "" {
                cell.emailIDLabel.text = email
            }else {
               cell.emailIDLabel.text = "-"
            }
            
            if let partyAffiliation = dataProfile?.party_affiliation, partyAffiliation != "" {
                cell.partyAffiliationLabel.text = partyAffiliation
            }else {
                cell.partyAffiliationLabel.text = "-"
            }

            if let location = dataProfile?.location, location != "" {
                cell.locationLabel.text = location
            }else {
                cell.locationLabel.text = "-"
            }
            cell.historyButton.isHidden = true

//        case 2:
//            cell.type = ProfileCellType.game
        default:
            cell.type = ProfileCellType.points
            
        }
        return cell
    }
}


extension UserProfileViewController{
    func setcollapsibleToolbar(){
        let behaviourDefiner = SquareCashStyleBehaviorDefiner()
        behaviourDefiner.addSnappingPositionProgress(0.0, forProgressRangeStart: 0.0, end: 0.5)
        behaviourDefiner.addSnappingPositionProgress(1.0, forProgressRangeStart: 0.5, end: 1.0)
        behaviourDefiner.isSnappingEnabled = true
        behaviourDefiner.isElasticMaximumHeightAtTop = true
        topFlexibleBar.behaviorDefiner = behaviourDefiner
        topFlexibleBar.maximumBarHeight = topBarHeightConstraintMax
        topFlexibleBar.minimumBarHeight = initialNaviBarFrame?.height ?? 64
        topFlexibleBar.progress = 1
        profileScrollView.delegate = self
        //        profileScrollView.delegate = topFlexibleBar.behaviorDefiner
        profileScrollView.contentInset = UIEdgeInsets(top: 160, left: 0, bottom: 0, right: 0)
        setCollapsibleView(view: headerViewName, index: 0)
        setCollapsibleView(view: userWalletView, index: 1)
        setCollapsibleView(view: verifyMobileView, index: 2)
        setCollapsibleView(view: gradientImageView, index: 3)
        profileScrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        isNavigationSet = true
    }
    
    func setCollapsibleView(view:UIView, index:Int){
        
        let initialProfileImageViewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes.init()
        initialProfileImageViewLayoutAttributes.size = CGSize(width: CGFloat(view.frame.width), height: view.frame.height)
        initialProfileImageViewLayoutAttributes.center = centerArrays[index]//CGPoint(x:CGFloat(Device.SCREEN_WIDTH/4), y:topFlexibleBar.maximumBarHeight - (view.frame.height/2))
        view.add(initialProfileImageViewLayoutAttributes, forProgress: 0.0)
        
        let midwayProfileImageViewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes.init(existing: initialProfileImageViewLayoutAttributes)
        midwayProfileImageViewLayoutAttributes?.center = CGPoint(x: (midwayProfileImageViewLayoutAttributes?.center.x)!, y: -((midwayProfileImageViewLayoutAttributes?.frame.height)!))
        view.add(midwayProfileImageViewLayoutAttributes, forProgress: 0.5)
        
        let finalProfileImageViewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes.init(existing: midwayProfileImageViewLayoutAttributes)
        finalProfileImageViewLayoutAttributes?.center = CGPoint(x: (midwayProfileImageViewLayoutAttributes?.center.x)!, y: -((midwayProfileImageViewLayoutAttributes?.frame.height)!))
        view.add(finalProfileImageViewLayoutAttributes, forProgress: 1)
        
        view.addObserver(self, forKeyPath: "center", options: [.new, .old], context: nil)
        
    }
    
    func getProfileData (){
        
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            let params = ["user_id":USERID]
            Service.sharedInstance.request(api: API_USER_PROFILE, type: .post, parameters: params, complete: { (response) in
                do {
                    let profileData = try decoder.decode(UserProfile.self, from: response as! Data)
                    self.dataProfile = profileData.user_data
//                    print(self.dataProfile)
                    self.setData()
                    self.transactionTableView .reloadData()
                    
                } catch {
                    DLog(message: error)
                    self.showAlert(message: error.localizedDescription)
                }
                Loader.hide(for: self.view, animated: true)
                
            }) { (error) in
                DLog(message: error)
                Loader.hide(for: self.view, animated: true)
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }

    func setData() {
        
        if let userName = dataProfile?.alias, userName != "" {
            self.headerViewName.text = userName
        }else {
            self.headerViewName.text = "-"
        }
        
        if let points = dataProfile?.points, points != "" {
            self.totalCoinsLabel.text = points
        }else {
            self.totalCoinsLabel.text = "0"
        }
    }
}

extension UserProfileViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        DLog(message: "Content Offset \(scrollView.contentOffset)")
        
        testViewHeightConstraint.constant = 0 - scrollView.contentOffset.y

        if scrollView.contentOffset.y >= -160{
                self.verifyMobileView.alpha = 0.0
        } else{
            UIView.animate(withDuration: 0.3) {
                self.verifyMobileView.alpha = 1.0
                
            }
        }
        
        if scrollView.contentOffset.y >= -140{
                self.userWalletView.alpha = 0.0
        } else{
            UIView.animate(withDuration: 0.3) {
                self.userWalletView.alpha = 1.0
            }

        }
        
        if scrollView.contentOffset.y >= -40{
            UIView.animate(withDuration: 0.3) {
                self.headerViewName.alpha = 0.0
            }
            self.navigationItem.titleView = headerLabel
        } else{
            UIView.animate(withDuration: 0.3) {
                self.headerViewName.alpha = 1.0
                
            }
            
            self.navigationItem.titleView = setAppLogoToNavigationTitle()
        }
    }
    
}
