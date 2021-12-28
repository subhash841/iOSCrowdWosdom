//
//  UserInfoViewController.swift
//  CrowdWisdom
//
//  Created by  user on 11/29/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import TwicketSegmentedControl
import PopupDialog

class UserInfoViewController: NavigationBaseViewController {
    
    @IBOutlet weak var profileScrollView: UIScrollView!
    @IBOutlet weak var gradientImageView: UIImageView!
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var userWalletView: UIStackView!
    @IBOutlet weak var headerViewName: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    var initialNaviBarFrame : CGRect?
    
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var optionSegmentView: TwicketSegmentedControl!
    @IBOutlet weak var testViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalCoinsLabel: UILabel!
    var statusBarHeight: CGFloat = 20
    var navigationBarHeight: CGFloat = 44
    var topBarHeightConstraintMax:CGFloat = 160
    var centerArrays = [CGPoint]()
    var isNavigationSet = false
    var isDrawer = false
    var dataProfile : ProfileData?
    var selectedSegment = 0
    var dataWalletPoints = [PointsHistory]()
    var isProfileData = true
    var isWalletShow = false
    var walletData : WalletHistory?
    var isAvailable = "0"
    var offset = 0
    private let imageView = UIImageView(image: UIImage(named: "dummyImage"))
    
    lazy var headerLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 160, height: 65))
        label.textColor = UIColor.white
        label.font = Common.shared.getFont(type: .bold, size: 19)
        label.text = headerViewName.text
        label.textAlignment = .center
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false
        self.statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        
        if let navHeight = self.navigationController?.navigationBar.frame.height{
            self.navigationBarHeight = navHeight
        }
        topBarHeightConstraintMax = 160
        testViewHeightConstraint.constant = topBarHeightConstraintMax
        transactionTableView.addObserver(self, forKeyPath: "contentSize", options: [.new, .old], context: nil)
      
        transactionTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        transactionTableView.register(UINib(nibName: "NewWalletHistoryCell", bundle: nil), forCellReuseIdentifier: "NewWalletHistoryCell")

        if isDrawer == true{
            setupLeftBarButton(isback: true)
        }
        
        let dict = Common.shared.getUserInfo()
        if let aliasName = dict["alias"] as? String {
            self.headerViewName.text = aliasName
        }else {
            self.headerViewName.text = "-"
        }

        setOptionsControl()
        profileScrollView.delegate = self
        profileScrollView.contentInset = UIEdgeInsets(top: 215, left: 0, bottom: 0, right: 0)
        self.emptyStateAction = {
            self.getUserProfileData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isWalletShow == false {
            isProfileData = true
            selectedSegment = 0
            optionSegmentView.move(to: 0)
            getUserProfileData()
        }
        else
        {
            selectedSegment = 1
            isProfileData = false
            optionSegmentView.move(to: 1)
            getPointsHistory()
        }

    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            tableViewHeight.constant = transactionTableView.contentSize.height
        }
    }
    
    deinit {
        if transactionTableView != nil {
            transactionTableView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
    @IBAction func verifyMobileTapped(_ sender: UIButton) {
    }
    
    @IBAction func editAlaiseNameTapped(_ sender: Any) {
        showAliasPopup()
    }
    
}

extension UserInfoViewController: AliasPopUpDelegate {
    private func showAliasPopup() {
        let aliasPopUpVC = AliasPopUpViewController(nibName: "AliasPopUpViewController", bundle: nil)
        aliasPopUpVC.isEdit = true
        aliasPopUpVC.delegate = self
        // Create the dialog
        let popup = PopupDialog(viewController: aliasPopUpVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    func updateData(with aliasName: String) {
        self.headerViewName.text = aliasName
        
    }
}

extension UserInfoViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isProfileData == true {
            return 2
        }else
        {
            return dataWalletPoints.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isProfileData == true {
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
                
                if let gold = dataProfile?.total_gold , gold != "" {
                    cell.partyAffiliationLabel.text = gold
                }else {
                    cell.partyAffiliationLabel.text = "-"
                }
                
                if let diamond = dataProfile?.total_diamond {
                    cell.locationLabel.text = "\(diamond)"
                }else {
                    cell.locationLabel.text = "-"
                }
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
                
                //        case 2:
            //            cell.type = ProfileCellType.game
            default:
                cell.type = ProfileCellType.points
                
            }
            return cell

        }else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewWalletHistoryCell", for: indexPath) as! NewWalletHistoryCell
            if indexPath.row > dataWalletPoints.count { return cell }
            if let date = dataWalletPoints[indexPath.row].date , date != ""  {
                cell.dateLabel.text = date
            }else {
                cell.dateLabel.text = "-"
            }
            
            if let topic = dataWalletPoints[indexPath.row].topic , topic != ""  {
                cell.topicLabel.text = topic
            }else {
                cell.topicLabel.text = "-"
            }
            
            if let category = dataWalletPoints[indexPath.row].category , category != ""  {
                cell.categoryLabel.text = category
                if let points = dataWalletPoints[indexPath.row].points , points != ""{
                   if let value = dataWalletPoints[indexPath.row].value
                   {
                        cell.pointsLabel.text = "\(value) \(points)"
                   }else
                   {
                        cell.pointsLabel.text = "-"
                    }
//                    if category == "Questions"{
//                        cell.pointsLabel.text = "\(2) \(points)"
//                    }else if category == "Prediction"{
//                        cell.pointsLabel.text = "\(1) \(points)"
//                    }else
//                    {
//                        cell.pointsLabel.text = "\(2) \(points)"
//                    }

                }else
                {
                    cell.pointsLabel.text = "-"
                }
                
            }else {
                cell.categoryLabel.text = "-"
            }
            
            if let action = dataWalletPoints[indexPath.row].action , action != ""  {
                cell.actionLabel.text = action
            }else {
                cell.actionLabel.text = "-"
            }
            
            if let points = dataWalletPoints[indexPath.row].points , points != ""
            {
                
//                if category == "Prediction"{
//                    let str : String = "1"
//                    cell.pointsLabel.text = "\(str) \(points)"
//                }else if category == "survey" || category == "Questions" {
//                    let str : String = "2"
//                    cell.pointsLabel.text = "\(str) \(points)"
//                }
            }else {
            }

            return cell
        }
    }
}

extension UserInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataWalletPoints.count - 2 && isAvailable == "1" && !isProfileData {
            offset = dataWalletPoints.count
            getPointsHistory()
        }
    }
    
}

extension UserInfoViewController{

    func getUserProfileData (){
        
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            let params = ["user_id":USERID]
            Service.sharedInstance.request(api: API_USER_PROFILE, type: .post, parameters: params, complete: { (response) in
                do {
                    self.emptyView.removeFromSuperview()
                    let profileData = try decoder.decode(UserProfile.self, from: response as! Data)
                     print("profileData \(profileData)")
                    self.dataProfile = profileData.user_data
                    // print(self.dataProfile)
                    self.setData()
                    self.transactionTableView.isHidden = false
                    self.transactionTableView.reloadData()
                    
                } catch {
                    self.transactionTableView.isHidden = true
                    self.setNoDataInfo(with:CGRect(x: 0, y: 200, width: Device.SCREEN_WIDTH, height: Device.SCREEN_HEIGHT-200), sendToBack: false)
                    DLog(message: error)
                    self.showAlert(message: error.localizedDescription)
                }
                Loader.hide(for: self.view, animated: true)
                
            }) { (error) in
                self.transactionTableView.isHidden = true
                self.setNoDataInfo(with:CGRect(x: 0, y: 200, width: Device.SCREEN_WIDTH, height: Device.SCREEN_HEIGHT-200), sendToBack: false)
                DLog(message: error)
                Loader.hide(for: self.view, animated: true)
            }
        } else {
            self.setNoConnectionState()
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    
    func getPointsHistory() {
        
            if NetworkStatus.shared.haveInternet() {
                if offset == 0 {
                    dataWalletPoints .removeAll()

                }
            Loader.showAdded(to: self.view, animated: true)
            let params = ["user_id":USERID,"offset":"\(offset)"]
            DLog(message: "\(params)")
            Service.sharedInstance.request(api: API_USER_POINT_HISTROY, type: .post, parameters: params, complete: { (response) in
                do {
                    self.walletData = try decoder.decode(WalletHistory.self, from: response as! Data)
                    if let points = self.walletData?.pointsHistory {
                        if points.isEmpty == false {
                            self.hideNoDataInfo()
                            self.dataWalletPoints.append(contentsOf: self.walletData?.pointsHistory ?? [PointsHistory]())
                            self.isAvailable = self.walletData?.isAvailable ?? "0"
                            self.setData()
                            self.transactionTableView.isHidden = false
                            self.transactionTableView.reloadData()
                        }else
                        {
                            if self.dataWalletPoints.isEmpty {
                                self.transactionTableView.isHidden = true
                                self.setNoDataInfo(with:CGRect(x: 0, y: 200, width: Device.SCREEN_WIDTH, height: Device.SCREEN_HEIGHT-200), sendToBack: false)
                            }
                        }
                    }
                    
                } catch {
                    self.transactionTableView.isHidden = true
                    self.setNoDataInfo(with:CGRect(x: 0, y: 200, width: Device.SCREEN_WIDTH, height: Device.SCREEN_HEIGHT-200), sendToBack: false)
                    DLog(message: error)
                    self.showAlert(message: error.localizedDescription)
                }
                Loader.hide(for: self.view, animated: true)
                
            }) { (error) in
                self.transactionTableView.isHidden = true
                self.setNoDataInfo(with:CGRect(x: 0, y: 200, width: Device.SCREEN_WIDTH, height: Device.SCREEN_HEIGHT-200), sendToBack: false)
                DLog(message: error)
                Loader.hide(for: self.view, animated: true)
            }
        } else {
            self.setNoConnectionState()
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func setData() {
        
        if isProfileData == true {
            if let points = dataProfile?.points, points != "" {
                self.totalCoinsLabel.text = points
            }else {
                self.totalCoinsLabel.text = "0"
            }
        }else
        {
            if let points = walletData?.points {
                self.totalCoinsLabel.text = points
            }else {
                self.totalCoinsLabel.text = "0"
            }
        }
    }

}

extension UserInfoViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        DLog(message: "Content Offset \(scrollView.contentOffset)")
        
        testViewHeightConstraint.constant = 0 - (scrollView.contentOffset.y + 55)
        
        if scrollView.contentOffset.y >= -160{
//            self.verifyMobileView.alpha = 0.0
        } else{
            UIView.animate(withDuration: 0.3) {
//                self.verifyMobileView.alpha = 1.0
                
            }
        }
        
        if scrollView.contentOffset.y >= -120{
            self.userWalletView.alpha = 0.0
        } else{
            UIView.animate(withDuration: 0.3) {
                self.userWalletView.alpha = 1.0
            }
        }
        
        if scrollView.contentOffset.y >= -60{
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

extension UserInfoViewController: TwicketSegmentedControlDelegate {
    func setOptionsControl() {
        optionSegmentView.setSegmentItems(["Profile","Wallet"])
        optionSegmentView.delegate = self
        optionSegmentView.sliderBackgroundColor = BLUE_COLOR
        optionSegmentView.font = Common.shared.getFont(type: .regular, size: 15)
        optionSegmentView.isSliderShadowHidden = true
    }

    
    func didSelect(_ segmentIndex: Int) {
        hideNoDataInfo()
        if selectedSegment != segmentIndex{
            selectedSegment = segmentIndex
            if segmentIndex == 0 {
                isWalletShow = false
                isProfileData = true
                getUserProfileData()
            } else {
                isWalletShow = true
                isProfileData = false
                offset = 0
                getPointsHistory()
            }
        }
    }
}
