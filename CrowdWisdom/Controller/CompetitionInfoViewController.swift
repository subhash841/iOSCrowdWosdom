//
//  CompetitionInfoViewController.swift
//  CrowdWisdom
//
//  Created by sunday on 12/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import PopupDialog



class CompetitionInfoViewController: NavigationBaseViewController {
    
    var competitionID = ""
    
    private var competitionInfo: CompetitionInfoModel?
    var isFirstOpen = true
    
    @IBOutlet weak var competititontableView: UITableView!

    //MARK:- View life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLeftBarButton(isback: true)
        registerCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if competitionID != "" {
            getCompetitionInfo()
        } else {
            DLog(message: "id is blank")
        }
    }
    
    private func registerCells() {
        
        competititontableView.register(UINib(nibName: "CompetitionInfoHeaderCell", bundle: nil), forCellReuseIdentifier: "CompetitionInfoHeaderCell")
        competititontableView.register(UINib(nibName: "CompetitionInfoRewardCell", bundle: nil), forCellReuseIdentifier: "CompetitionInfoRewardCell")
        competititontableView.register(UINib(nibName: "CompetitionInfoRulesCell", bundle: nil), forCellReuseIdentifier: "CompetitionInfoRulesCell")
    }
    
    //MARK:- API handling
    
    private func getCompetitionInfo() {
        if NetworkStatus.shared.haveInternet() {
            if isFirstOpen { Loader.showAdded(to: self.view, animated: true) }
            let params = ["user_id":USERID,"id":competitionID]
            Service.sharedInstance.request(api: API_COMPETITION_INFO, type: .post, parameters: params, complete: { (response) in
                do {
                    /*let json = try JSONSerialization.jsonObject(with: response as! Data, options: JSONSerialization.ReadingOptions.allowFragments)
                     print("json:\(json)")*/
                    self.isFirstOpen = false
                    let competitionInfo = try decoder.decode(CompetitionInfoModel.self, from: response as! Data)
                    if competitionInfo.status ??  false {
                        // set data here
                        self.emptyView.removeFromSuperview()
                        
                        self.competitionInfo = competitionInfo
                        self.competititontableView.reloadData()
                    } else {
                        if let msg = competitionInfo.message {
                            self.showAlert(message: msg)
                            self.setNoDataState()
                        }
                    }
                } catch {
                    DLog(message: error)
                    self.showAlert(message: error.localizedDescription)
                }
                Loader.hide(for: self.view, animated: true)
                
            }) { (error) in
                DLog(message: error)
                Loader.hide(for: self.view, animated: true)
            }
        } else  {
            setNoConnectionState()
        }
    }
    
    private func purchasePackage() {
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            let params = ["user_id":USERID,"id":competitionID]
            Service.sharedInstance.request(api: API_COMPETITION_PURCHASE_PKG, type: .post, parameters: params, complete: { (response) in
                do {
                    let purchasePackegeInfo = try decoder.decode(PurchasePackageModel.self, from: response as! Data)
                    if purchasePackegeInfo.status ??  false {
                        if let questionIds = purchasePackegeInfo.question_ids, questionIds.count > 0 {
                            self.dismiss(animated: true, completion: nil)
                            self.navigateToDetail(ids: questionIds)
                        } else {
                            if let msg = purchasePackegeInfo.message {
                                self.showAlert(message: msg)
                            } else {
                                self.showAlert(message: "something went wrong")
                            }
                        }
                    } else {
                        if let msg = purchasePackegeInfo.message {
                            self.showAlert(message: msg)
                        }
                    }
                    
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
    
    private func navigateToDetail(ids: [String]) {
        let competitionDetailVC = CompetitionDetailViewController.init(nibName: "CompetitionDetailViewController", bundle: nil)
        competitionDetailVC.questionIds = ids
        competitionDetailVC.competitionId = competitionID
        self.navigationController?.pushViewController(competitionDetailVC, animated: true)
    }
}

extension CompetitionInfoViewController:LoginViewDelegate{
    func loginSuccessful() {
        getCompetitionInfo()
        self.payNowView()
    }
}
//MARK:- Table view delegate

extension CompetitionInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = competitionInfo {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = competitionInfo {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompetitionInfoHeaderCell") as! CompetitionInfoHeaderCell
            cell.selectionStyle = .none
            if let info = competitionInfo {
                cell.setDetails(with: info)
            }
            cell.shareButton.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)
            cell.payNowButton.tag = indexPath.row
            cell.payNowButton.addTarget(self, action: #selector(payNowbuttonAction( _:)), for: .touchUpInside)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompetitionInfoRewardCell") as! CompetitionInfoRewardCell
            cell.containerView.dropShadowToCell()
            cell.lineLabel.addGradient()
            if let info = competitionInfo, let infoData = info.data {
                cell.rewardLabel.text = infoData.reward_text ?? ""
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompetitionInfoRulesCell") as! CompetitionInfoRulesCell
            cell.containerView.dropShadowToCell()
            cell.lineLabel.addGradient()
            if let info = competitionInfo, let infoData = info.data {
                cell.rule2.text = infoData.prize_text ?? ""
                cell.rule4.text = infoData.point_required_text ?? ""
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 220
     }*/
    
    
    //MARK:- Button Actions
    
    @objc func payNowbuttonAction(_ sender: UIButton) {
        let buttonTitle = sender.title(for: .normal)
        if buttonTitle == "Play Now" {
            // call api
            if USERID == "0"{
                self.setLoginPage()
            }else
            {
                purchasePackage()
            }
        } else if buttonTitle == "Pay Now" {
            if USERID == "0"{
                self.setLoginPage()
            }else
            {
                self.payNowView()
            }
        }
    }
    
    func setLoginPage() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.isFromAction = true
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }

    func payNowView(){
        
        guard let info = competitionInfo else {
            DLog(message: "No data")
            return
        }
        if info.data?.purchased == "0" {
            if let silverPoint = info.silver_points, let infoData = info.data {
                if let price = infoData.price {
                    if silverPoint.integerValue ?? 0 >= price.integerValue ?? 0 {
                        // call api
                        isPointsRequired = true
                        let competitionPopup = CompetitionPopupViewController(nibName: "CompetitionPopupViewController", bundle: nil)
                        // Create the dialog
                        competitionPopup.delegate = self
                        competitionPopup.requiredPoints = price.integerValue
                        let popup = PopupDialog(viewController: competitionPopup,
                                                buttonAlignment: .horizontal,
                                                transitionStyle: .zoomIn,
                                                tapGestureDismissal: false,
                                                panGestureDismissal: false)
                        
                        // Present dialog
                        present(popup, animated: true, completion: nil)
                        //                      purchasePackage()
                        
                    } else {
                        let competitionPopup = CompetitionPopupViewController(nibName: "CompetitionPopupViewController", bundle: nil)
                        competitionPopup.requiredPoints = price.integerValue
                        // Create the dialog
                        isPointsRequired = false
                        let popup = PopupDialog(viewController: competitionPopup,
                                                buttonAlignment: .horizontal,
                                                transitionStyle: .zoomIn,
                                                tapGestureDismissal: false,
                                                panGestureDismissal: false)
                        
                        // Present dialog
                        present(popup, animated: true, completion: nil)
                        
                        //                        self.showAlert(message: "You do not have sufficient Silver Points")
                    }
                }
            } else {
                let competitionPopup = CompetitionPopupViewController(nibName: "CompetitionPopupViewController", bundle: nil)
                if let price = info.data?.price {
                    competitionPopup.requiredPoints = price.integerValue
                }
                // Create the dialog
                isPointsRequired = false
                let popup = PopupDialog(viewController: competitionPopup,
                                        buttonAlignment: .horizontal,
                                        transitionStyle: .zoomIn,
                                        tapGestureDismissal: false,
                                        panGestureDismissal: false)
                
                // Present dialog
                present(popup, animated: true, completion: nil)
                
                //                    self.showAlert(message: "You do not have sufficient Silver Points")
            }
        }
    }
    @objc func shareButtonAction() {
        // share handling
        guard let info = competitionInfo,
            let infoData = info.data else {
                return
        }
        
        var shareLink = ""
        shareLink = Common.shared.shareURL(id: infoData.id ?? "", isVoice: 5)
        if let someText:String = infoData.name {
            let objectsToShare = URL(string:shareLink)
            let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
            let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
        
    }
}

extension CompetitionInfoViewController: CompetitionPopUpDelegate{
    func playActive() {
        purchasePackage()
    }
}

/*private func postData() {
 if NetworkStatus.shared.haveInternet() {
 Loader.showAdded(to: self.view, animated: true)
 let jsonData : [String: String] = ["link":"www.google.com","img":"https://imgupload.crowdwisdom.co.in/images/XDzTn5NBuQ.jpg","domain":"www.google.com","title":"Google","description":"ios"]
 
 let params = ["id":"0", "user_id":USERID, "title":"test ios","topics":["16"],"description":"description ios","uploaded_filename":"https://imgupload.crowdwisdom.co.in/images/XDzTn5NBuQ.jpg","is_topic_change":"0","json_data":jsonData] as [String : Any]
 print("param:\(params)")
 Service.sharedInstance.request(api: API_RATEDARTICLE_CREATE_UPDATE, type: .post, parameters: params, complete: { (response) in
 do {
 let json = try JSONSerialization.jsonObject(with: response as! Data, options: JSONSerialization.ReadingOptions.allowFragments)
 print("json:\(json)")
 } catch {
 DLog(message: error)
 self.showAlert(message: error.localizedDescription)
 }
 }) { (error) in
 
 }
 } else {
 // no internet
 }
 
 }*/
