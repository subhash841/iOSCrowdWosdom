//
//  CompetitionDetailCell.swift
//  CrowdWisdom
//
//  Created by sunday on 12/5/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import Lottie

protocol competitionDetailDelegate {
    func setNointernetState()
    func addNoDataState()
}

class CompetitionDetailCell: UICollectionViewCell {
    var delegate: competitionDetailDelegate?
    var cardData: TypeStatus?
    private var cellCount = 0
    var competitionId: String?
    
    var selectedIndex = Int()
    var previousIndex = Int()
    var selectedOptionIndexArray = [Bool]()
    var optionsArray = [Options]()
    var expertOptions = [ExpertOption]()
    var expertOn = false
    var showDescription = false
    var showPercent = false
    
    @IBOutlet weak var contentTableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentTableView.delegate = self
        contentTableView.dataSource = self
    }
    
    //MARK:-  Table view setup
    func registerCell() {
        
        contentTableView.register(UINib(nibName: "CompetitionHeaderCell", bundle: nil), forCellReuseIdentifier: "CompetitionHeaderCell")
        contentTableView.register(UINib(nibName: "CompetitionOptionCell", bundle: nil), forCellReuseIdentifier: "CompetitionOptionCell")
        contentTableView.register(UINib(nibName: "CompetitionButtonCell", bundle: nil), forCellReuseIdentifier: "CompetitionButtonCell")
        contentTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func scrollToTop() {
        contentTableView.scrollsToTop = true
    }
    private func scrollTableViewToTop() {
        let index = IndexPath(item: 0, section: 0)
        contentTableView.scrollToRow(at: index, at: .top, animated: false)
    }
    
    //MARK:-  Api call and Populate data
    
    func getDetailsData(for competitionID: String) {
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.contentView, animated: true)
            let param = ["user_id":USERID,"id":competitionID]
            DLog(message: param)
            Service.sharedInstance.request(api: API_PREDICTIONS_DETAIL, type: .post, parameters: param, complete: { (response) in
                do {
                    let cardDetails = try decoder.decode(TypeStatus.self, from: response as! Data)
                    if cardDetails.status ?? false {
                        self.contentTableView.isHidden = false
                        self.cardData = cardDetails
                        //self.expertOn = false
                        DispatchQueue.main.async {
                            self.setDetails()
                        }
                    } else {
                        self.contentTableView.isHidden = true
                        self.viewController?.showAlert(message: cardDetails.message ?? "Something went wrong")
                        if let delegate = self.delegate {
                            delegate.addNoDataState()
                        }
                    }
                    //self.setDetails()
                } catch {
                    //self.showAlert(message: "\(error)")
                }
                Loader.hide(for: self.contentView, animated: true)
            }) { (error) in
                DLog(message: error)
                Loader.hide(for: self.contentView, animated: true)
            }
        }else{
            if let delegate = delegate {
                delegate.setNointernetState()
            }
        }
    }
    
    private func callVoteWebService(infoData: TypeDetail) {
        
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.contentView, animated: true)
            let selectedOption = optionsArray[selectedIndex - 1]
            let params = ["id": infoData.id ?? "",
                          "choice":selectedOption.choice_id ?? "",
                          "user_id":USERID] as [String : Any]
            DLog(message: "Vote Param:\(params)")
            Service.sharedInstance.request(api: API_PREDICTIONS_VOTE, type: .post, parameters: params, complete: { (response) in
                do{
                    let resp = try decoder.decode(TypeStatus.self, from: response as! Data)
                    if resp.status ?? false{
                        DispatchQueue.main.async {
                            if self.cardData?.data?.users_choice == ""{
                                self.coinAnimation()
                            }
                            self.selectedIndex = 0
                            self.cardData = resp
                            self.expertOn = false
                            self.showPercent = true
                            self.setDetails()
                        }
                    } else{
                        DLog(message: resp.message ?? "Something went wrong.")
                    }
                } catch{
                    DLog(message: "\(error)")
                }
                Loader.hide(for: self.contentView, animated: true)
            }) { (error) in
                Loader.hide(for: self.contentView, animated: true)
            }
        } else {
            viewController?.showAlert(message: NO_INTERNET)
        }
        
        //api = API_PREDICTIONS_VOTE
    }
    
    private func callExpertWebservice() {
        
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.contentView, animated: true)
            let params = ["id" : self.cardData?.data?.id ?? ""]
            Service.sharedInstance.request(api: API_PREDICTIONS_EXPERT, type: .post, parameters: params, complete: { (response) in
                do{
                    let resp = try decoder.decode(ExpertResponse.self, from: response as! Data)
                    if resp.status {
                        DispatchQueue.main.async {
                            self.expertOptions = resp.data
                            self.expertOn = true
                            UIView.performWithoutAnimation {
                                self.contentTableView.reloadData()
                            }
                        }
                    } else {
                        self.viewController?.showAlert(message: resp.message ?? "Something went wrong.")
                    }
                    Loader.hide(for: self.contentView, animated: true)
                } catch{
                    DLog(message: "\(error)")
                    Loader.hide(for: self.contentView, animated: true)
                }
            }) { (error) in
                DLog(message: "\(error)")
                Loader.hide(for: self.contentView, animated: true)
            }
        } else{
            viewController?.showAlert(message: NO_INTERNET)
        }
        
    }
    
    //MARK:- Ui updete
    private func setDetails() {
        
        if let data = cardData?.data, let options = data.options {
            self.optionsArray = options
            selectedOptionIndexArray = [Bool](repeating: false, count: options.count + 2)
            if data.users_choice == ""{
                self.showPercent = false
            } else{
                self.showPercent = true
            }
        }
        
        contentTableView.reloadData()
        scrollTableViewToTop()
        
        if let headerCell = contentTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CardDetailsTableViewCell{
            headerCell.expertSwitch.setOn(false, animated: true)
        }
    }
    
    func coinAnimation(){
        let tintView = UIView(frame: Device.SCREEN_BOUND)
        tintView.backgroundColor = UIColor.init(hexString: "#000000", alpha: 0.5)
        let containerView = UIView(frame: CGRect(x: Device.SCREEN_WIDTH/2 - 100 , y: Device.SCREEN_HEIGHT/2 - 100 - Int(viewController?.tabBarController?.tabBar.frame.height ?? 0) - Int(viewController?.navigationController?.navigationBar.frame.height ?? 0), width: 200, height: 200))
        containerView.backgroundColor = UIColor.white
        let animationView = LOTAnimationView(name: "lottie_wallet")
        animationView.frame = containerView.bounds
        animationView.contentMode = .scaleAspectFit
        
        let infoLabel = UILabel(frame: CGRect(x: 0, y: containerView.frame.height - 40
            , width: containerView.frame.width, height: 20))
        
        infoLabel.text = "You got 1 silver point."
        infoLabel.font = Common.shared.getFont(type: .bold, size: 13)
        infoLabel.textAlignment = .center
        containerView.addSubview(animationView)
        containerView.addSubview(infoLabel)
        tintView.addSubview(containerView)
        viewController?.view.addSubview(tintView)
        //self.refreshDelegate?.refreshVotes(index: index, section: section)
        animationView.play(fromProgress: 0.5, toProgress: 1.0, withCompletion:{ (finished) in
            tintView.removeFromSuperview()
        })
    }
    
    //MARK:- Button Actions
    
    @objc func commentButtonAction(_ sender: UIButton) {
        let commentsViewController = storyboard.instantiateViewController(withIdentifier: "RevisedCommentsViewController") as! RevisedCommentsViewController
        commentsViewController.commentId = "\(sender.tag)"
        commentsViewController.type = CardType.prediction
        commentsViewController.isOnlyCommentsView = true
        //commentsViewController.delegate = self
        self.viewController?.navigationController?.pushViewController(commentsViewController, animated: true)
    }
    
    @objc func expertSwitchChangedAction(_ sender: UISwitch) {
        let cell = contentTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! CompetitionHeaderCell
        selectedIndex = 0
        
        if !self.expertOn{
            if self.cardData?.data?.users_choice == ""{
                cell.expertSwitch.setOn(false, animated: true)
                self.viewController?.showAlert(message: "Please vote to see expert Result.")
            } else{
                if expertOptions.count > 0{
                    self.expertOn = true
                } else{
                    callExpertWebservice()
                }
            }
        } else{
            expertOn = false
        }
        UIView.performWithoutAnimation {
            self.contentTableView.reloadData()
        }
    }
    @objc func voteButtonAction() {
        // send Your Vote here
        guard let info = cardData, let infodata = info.data, let options = infodata.options else {
            DLog(message: "Passing Data missing")
            return
        }
        if selectedIndex > 0 && options.count > 0 {
            callVoteWebService(infoData: infodata)
        } else{
            viewController?.showAlert(message: "Please select an option")
        }
    }
    
    @objc func knowMoreButtonAction(_ sender: UIButton) {
        showDescription = !showDescription
        UITableView.performWithoutAnimation {
            self.contentTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    @objc func shareButtonAction(_ sender: UIButton) {
        guard let info = cardData,
            let infoData = info.data else {
                return
        }
        
        var shareLink = ""
        shareLink = Common.shared.shareURL(id: competitionId ?? "", isVoice: 6)
        shareLink = "\(shareLink)/\(infoData.id ?? "")"
        if let someText:String = infoData.title {
            let objectsToShare = URL(string:shareLink)
            let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
            let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = viewController?.view
            viewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
}

extension UIResponder {
    var viewController: UIViewController? {
        if let vc = self as? UIViewController {
            return vc
        }
        
        return next?.viewController
    }
}

//MARK:- Table View delegate & datasource
extension CompetitionDetailCell: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = cardData {
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cardDetails = cardData {
            if let data = cardDetails.data,let options = data.options {
                cellCount = options.count + 2
                return options.count + 2
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompetitionHeaderCell") as! CompetitionHeaderCell
            if let data = cardData {
                cell.setDetails(info: data)
            }
            
            cell.expertSwitch.setOn(self.expertOn, animated: false)
            if showDescription{
                UIView.animate(withDuration: 0.2) {
                    cell.knowMoreIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }
                cell.showDescriptionView()
            } else{
                UIView.animate(withDuration: 0.2) {
                    cell.knowMoreIcon.transform = .identity
                }
                cell.hideDescriptionView()
            }
            
            cell.commentButton.tag = Int(cardData?.data?.id ?? "0") ?? 0
            cell.commentButton.addTarget(self, action: #selector(commentButtonAction(_:)), for: .touchUpInside)
            
            cell.knowMoreButton.tag = indexPath.row
            cell.knowMoreButton.addTarget(self, action: #selector(knowMoreButtonAction(_ :)), for: .touchUpInside)
            
            cell.shareButton.tag = indexPath.row
            cell.shareButton.addTarget(self, action: #selector(shareButtonAction(_ :)), for: .touchUpInside)
            cell.expertSwitch.tag = indexPath.row
            cell.expertSwitch.addTarget(self, action: #selector(expertSwitchChangedAction(_:)), for: .valueChanged)
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == cellCount - 1 {
            
            if let expiryString = cardData?.data?.end_date {
                let expiryDate = Common.shared.dateFromStringDate(date: expiryString, fromFormat: "yyyy-MM-dd HH:mm:ss ", isUTC: false)
               
                guard let exDate = expiryDate,
                    (exDate > Date()) else {
                    return UITableViewCell()
                }
                /*if !(exDate > Date()) {
                    return UITableViewCell()
                }*/
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompetitionButtonCell") as! CompetitionButtonCell
            cell.selectionStyle = .none
            cell.voteButton.tag = indexPath.row
            cell.voteButton.addTarget(self, action: #selector(voteButtonAction), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompetitionOptionCell") as! CompetitionOptionCell
            
            let option = optionsArray[indexPath.row - 1]
            cell.choicelabel.text = option.choice ?? ""

            cell.selectionStyle = .none
            cell.progressBarView.setIndicatorTextMode(.none)
            
            if expertOn{
                let expertOption = expertOptions[indexPath.row - 1]
                if let n = NumberFormatter().number(from: expertOption.expertPercent ?? "0"){
                    cell.percentLabel.text = "\(CGFloat(truncating: n)) %"
                    cell.progressBarView.progress = CGFloat(truncating: n)/100
                    if expertOption.type == "0"{
                        cell.percentLabel.isHidden = true
                    } else{
                        cell.percentLabel.isHidden = false
                    }
                }
                cell.progressBarView.progressTintColor = UIColor(hexString: "#b3e1fc")
            } else{
                cell.tintView.backgroundColor = UIColor.clear
                if showPercent{
                    if let n = NumberFormatter().number(from: option.avg ?? "0"){
                        cell.percentLabel.text = "\(CGFloat(truncating: n)) %"
                        cell.progressBarView.progress = CGFloat(truncating: n)/100
                        if option.type == "0"{
                            cell.percentLabel.isHidden = true
                        } else{
                            cell.percentLabel.isHidden = false
                        }
                    }
                } else{
                    cell.progressBarView.progress = 0
                    cell.percentLabel.isHidden = false
                }
                
                cell.progressBarView.progressTintColor = UIColor(hexString: "#b3e1fc")
            }
            
            if selectedIndex == indexPath.row{
                cell.tintView.backgroundColor = UIColor(hexString: "#007AFF")
                cell.choicelabel.textColor = UIColor.white
                cell.percentLabel.textColor = UIColor.white
            } else{
                if expertOn{
                    cell.choicelabel.textColor = UIColor.darkGray
                    cell.percentLabel.textColor = UIColor.black
                } else{
                    if option.choice_id == cardData?.data?.users_choice{
                        cell.choicelabel.textColor = UIColor(hexString: "#007AFF")
                        cell.percentLabel.textColor = UIColor(hexString: "#007AFF")
                        cell.percentLabel.textColor = UIColor(hexString: "#007AFF")
                    } else{
                        cell.choicelabel.textColor = UIColor.darkGray
                        cell.percentLabel.textColor = UIColor.darkGray
                        cell.percentLabel.textColor = UIColor.darkGray
                    }
                }
                cell.tintView.backgroundColor = UIColor.clear
            }
            
            cell.progressBarView.backgroundColor = UIColor.groupTableViewBackground
            cell.progressBarView.layer.cornerRadius = 20
            
            cell.progressBarView.clipsToBounds = true
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let expiryString = cardData?.data?.end_date {
            let expiryDate = Common.shared.dateFromStringDate(date: expiryString, fromFormat: "yyyy-MM-dd HH:mm:ss ", isUTC: false)
            guard let exDate = expiryDate,
                exDate > Date() else {
                    return 
            }
        }
        if indexPath.row > optionsArray.count {
            return
        }
        
        let previousIndex = selectedIndex
        
        selectedIndex = indexPath.row
        
        if selectedIndex == 0{
            for i in 0..<optionsArray.count{
                optionsArray[i].selected = false
            }
            UIView.performWithoutAnimation {
                self.contentTableView.reloadData()
            }
        } else{
            
            if indexPath.row > 0 && indexPath.row < self.contentTableView.numberOfRows(inSection: 0) - 1 && selectedIndex > 0{
                
                self.optionsArray[selectedIndex - 1].selected = true
                
                UIView.performWithoutAnimation {
                    self.contentTableView.reloadRows(at: [IndexPath(row: selectedIndex, section: 0), IndexPath(row: previousIndex, section: 0)], with: .none)
                }
            }
        }
    }
}
