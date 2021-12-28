//
//  WalletViewController.swift
//  CrowdWisdom
//
//  Created by Nooralam Shaikh on 19/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import BLKFlexibleHeightBar
import ViewAnimator
import TwicketSegmentedControl

class WalletViewController: NavigationSearchViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var walletScrollView: UIScrollView!
    @IBOutlet weak var topFlexibleBarView: BLKFlexibleHeightBar!
    @IBOutlet weak var topBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var verifyMobileView: UIView!
    @IBOutlet weak var headerViewName: UILabel!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var optionSegmentControl: TwicketSegmentedControl!
    @IBOutlet weak var gradientImageView: UIImageView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    lazy var headerLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 65))
        label.textColor = UIColor.white
        label.font = Common.shared.getFont(type: .bold, size: 19)
        label.text = "Wallet"
        label.textAlignment = .center
        return label
    }()
    
    var initialNaviBarFrame : CGRect?
    var statusBarHeight: CGFloat = 20
    var navigationBarHeight: CGFloat = 44
    var topBarHeightConstraintMax:CGFloat = 200
    var centerArrays = [CGPoint]()
    var dataWalletPoints = [PointsHistory]()
    var offset = 0
    var isAvailable = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupLeftBarButton(isback: true)
        self.statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        
        self.navigationBarHeight = (self.navigationController?.navigationBar.frame.height)!
        topBarHeightConstraintMax += statusBarHeight + navigationBarHeight
        topBarHeightConstraint.constant = topBarHeightConstraintMax
        
        setOptionsControl()
        tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "historyCell")
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.getPointsHistory()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initialNaviBarFrame = self.navigationController?.navigationBar.frame
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.barTintColor = .orange
        
        centerArrays.removeAll()
        centerArrays.append(headerViewName.center)
        centerArrays.append(walletView.center)
        centerArrays.append(verifyMobileView.center)
        centerArrays.append(optionView.center)
        centerArrays.append(gradientImageView.center)
        
        
        setcollapsibleToolbar()
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "center"{
            
            let newValue = change?[.newKey] as! CGPoint
            print("Changed Value \(newValue)")
            if newValue.y <= 100{
//                self.navigationItem.title = "Wallet"
                self.navigationItem.titleView = headerLabel
            }else {
                //self.navigationItem.titleView = Common.shared.setAppLogoToNavigationTitle()
                self.navigationItem.titleView = setAppLogoToNavigationTitle()
            }
        } else if keyPath == "contentSize" {
            tableViewHeight.constant = tableView.contentSize.height
        }
    }
    
    deinit {
        tableView.removeObserver(self, forKeyPath: "contentSize")
        topFlexibleBarView.subviews.forEach { (view) in
            view.removeObserver(self, forKeyPath: "center")
        }
    }
    
    func getImageWithColor(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func setOptionsControl() {
//        optionSegmentControl.setTitleTextAttributes([NSAttributedString.Key.font: Common.shared.getFont(type: .regular, size: 14)],
//                                                    for: .normal)
//        optionSegmentControl.layer.cornerRadius = optionSegmentControl.frame.height / 2
//        optionSegmentControl.layer.masksToBounds = true
//        optionSegmentControl.tintColor = BLUE_COLOR
//        optionSegmentControl.backgroundColor = UIColor.white
//        optionSegmentControl.setBackgroundImage(getImageWithColor(color:optionSegmentControl.backgroundColor!), for: .normal, barMetrics: .default)
//        optionSegmentControl.setBackgroundImage(getImageWithColor(color:optionSegmentControl.tintColor!), for: .selected, barMetrics: .default)
//        optionSegmentControl.setDividerImage(getImageWithColor(color:.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
//        optionSegmentControl.layer.borderWidth = 0.5
//        optionSegmentControl.layer.borderColor = UIColor.lightGray.cgColor
//
//        optionSegmentControl.layer.masksToBounds = false
//        optionSegmentControl.layer.shadowColor = UIColor.black.cgColor
//        optionSegmentControl.layer.shadowOpacity = 0.3
//        optionSegmentControl.layer.shadowRadius = 3
//        optionSegmentControl.layer.masksToBounds = true
        optionSegmentControl.setSegmentItems(["History","Passbook"])
        optionSegmentControl.delegate = self
        optionSegmentControl.sliderBackgroundColor = BLUE_COLOR
        optionSegmentControl.font = Common.shared.getFont(type: .regular, size: 15)
    }
    
   
    
    @IBAction func verifyMobileButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func optionSegmentControlTapped(_ sender: UISegmentedControl) {
        
        
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

extension WalletViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}

extension WalletViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataWalletPoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        return cell
    }
}

//extension WalletViewController:UIScrollViewDelegate{
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y >= 100{
//            self.navigationItem.title = "Wallet"
//        } else{
//            self.navigationItem.title = ""
//        }
//    }
//}

extension WalletViewController{
    func setcollapsibleToolbar(){
        let behaviourDefiner = SquareCashStyleBehaviorDefiner()
        behaviourDefiner.addSnappingPositionProgress(0.0, forProgressRangeStart: 0.0, end: 0.5)
        behaviourDefiner.addSnappingPositionProgress(1.0, forProgressRangeStart: 0.5, end: 1.0)
        behaviourDefiner.isSnappingEnabled = false
        behaviourDefiner.isElasticMaximumHeightAtTop = true
        topFlexibleBarView.behaviorDefiner = behaviourDefiner
        topFlexibleBarView.maximumBarHeight = topBarHeightConstraintMax
        topFlexibleBarView.minimumBarHeight = 1
        walletScrollView.delegate = self
        walletScrollView.delegate = topFlexibleBarView.behaviorDefiner
        
        walletScrollView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        
        setCollapsibleView(view: headerViewName, index: 0)
        setCollapsibleView(view: walletView, index: 1)
        setCollapsibleView(view: verifyMobileView, index: 2)
        setCollapsibleView(view: optionView, index: 3)
        setCollapsibleView(view: gradientImageView, index: 4)
        
        walletScrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height:1 ), animated: false)
    }
    
    func setCollapsibleView(view:UIView, index:Int){
        
        let initialProfileImageViewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes.init()
        initialProfileImageViewLayoutAttributes.size = CGSize(width: CGFloat(view.frame.width), height: view.frame.height)
        initialProfileImageViewLayoutAttributes.center = centerArrays[index]//CGPoint(x:CGFloat(Device.SCREEN_WIDTH/4), y:topFlexibleBar.maximumBarHeight - (view.frame.height/2))
        view.add(initialProfileImageViewLayoutAttributes, forProgress: 0.0)
        
        let midwayProfileImageViewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes.init(existing: initialProfileImageViewLayoutAttributes)
        midwayProfileImageViewLayoutAttributes?.center = CGPoint(x: (midwayProfileImageViewLayoutAttributes?.center.x)!, y: -((midwayProfileImageViewLayoutAttributes?.frame.height)!))
        view.add(midwayProfileImageViewLayoutAttributes, forProgress: 0.8)
        
        let finalProfileImageViewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes.init(existing: midwayProfileImageViewLayoutAttributes)
        finalProfileImageViewLayoutAttributes?.center = CGPoint(x: (midwayProfileImageViewLayoutAttributes?.center.x)!, y: -((midwayProfileImageViewLayoutAttributes?.frame.height)!))
        view.add(finalProfileImageViewLayoutAttributes, forProgress: 1)
        
        view.addObserver(self, forKeyPath: "center", options: [.new, .old], context: nil)
        
    }
}

extension WalletViewController: TwicketSegmentedControlDelegate {
    func didSelect(_ segmentIndex: Int) {
        if segmentIndex == 0 {
            tableView.animate(animations: [AnimationType.from(direction: .left, offset: UIScreen.main.bounds.width)])
        } else {
            tableView.animate(animations: [AnimationType.from(direction: .right, offset: UIScreen.main.bounds.width)])
        }
    }
}

//MARK:- API
extension WalletViewController {
    func getPointsHistory() {
        
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            let params = ["user_id":USERID,"offset":"\(offset)"]
            Service.sharedInstance.request(api: API_USER_POINT_HISTROY, type: .post, parameters: params, complete: { (response) in
                do {
                    let walletData = try decoder.decode(WalletHistory.self, from: response as! Data)
                    
                    self.dataWalletPoints += walletData.pointsHistory ?? [PointsHistory]()
                    self.isAvailable = walletData.isAvailable ?? "0"
//                    //                    print(self.dataProfile)
//                    self.setData()
                    self.tableView .reloadData()
                    
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
}
