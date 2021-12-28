//
//  CardDetailsViewController.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 10/9/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import Lottie

protocol RefreshCounts{
    func refreshComments(index: Int, isDelete: Bool, section: Int)
    func refreshVotes(index: Int, section: Int)
}

enum ViewMoreSectionType: Int {
    case popularPredictions = 0
    case trendingQuestions = 1
    case playAndWin = 2
    case yourVoice = 3
    case topRatedArticles = 4
    case topDiscussions = 5
    
}

class CardDetailsViewController: NavigationBaseViewController {
    
    @IBOutlet weak var optionsTableView: UITableView!
    //    @IBOutlet weak var voteButton: UIButton!
    //    @IBOutlet weak var trendButton: UIButton!
    var type: CardType?
    var cardData: TypeStatus!
    var cardId = String()
    var optionsArray = [Options]()
    var expertOptions = [ExpertOption]()
    var backgroundView = UIView()
    var expertOn = Bool()
    var showPercent = Bool()
    var selectedIndex = 0
    var showDescription = Bool()
    var refreshDelegate: RefreshCounts?
    var index = 0
    var section = 0
    var isFirstTime = true
    var cellHeights = [Int:CGFloat]()
    var selectedOptionIndexArray = [Bool]()
    var isMultipleChoice = String()
    var isAfterLogin = false
    var cardListViewController = CardMainViewViewController()
    var isFromCardList = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let typ = type {
            optionsTableView.isHidden = true
            getCardDetail(with: typ)
            emptyStateAction = {
                self.getCardDetail(with: typ)
            }
        }
        //        optionsTableView.addObserver(self, forKeyPath: "contentSize", options: [.new, .old], context: nil)
        self.setupLeftBarButton(isback: true)
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        /*let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
         statusBar.isHidden = false*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        optionsTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("View did appear")
        super.viewDidAppear(animated)
        
        //        self.view.layer.insertSublayer(Common.shared.createGradientLayer(viewFrame: self.view.frame, colors: [UIColor (hexString: "#423394").cgColor, UIColor (hexString: "#0C98BA").cgColor], startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5)), at: 0)
        
    }
    
    //    @IBAction func animateSwitch(_ sender: UISwitch) {
    //        //sender.setOn(!sender.isOn, animated: true)
    //    }
    @IBAction func expertSwitchChangedAction(_ sender: UISwitch) {
        let cell = optionsTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! CardDetailsTableViewCell
        selectedIndex = 0
        
        if !self.expertOn{
            if self.cardData.data?.users_choice == ""{
                cell.expertSwitch.setOn(false, animated: true)
                self.showAlert(message: "Please vote to see expert Result.")
            } else{
                if expertOptions.count > 0{
                    //                    cell.expertSwitch.setOn(false, animated: true)
                    self.expertOn = true
                    //                    selectedIndex = 0
                    //                    for i in 0..<optionsArray.count{
                    //                        var option = optionsArray[i]
                    //                        option.selected = false
                    //                        optionsArray[i] = option
                    //                    }
                } else{
                    callExpertWebservice()
                }
                
            }
        } else{
            //            for i in 0..<optionsArray.count{
            //                var option = optionsArray[i]
            //                if option.choice_id == cardData.data?.users_choice{
            //                    option.selected = true
            //                } else{
            //                    option.selected = false
            //                }
            //                optionsArray[i] = option
            //            }
            expertOn = false
        }
        UIView.performWithoutAnimation {
            optionsTableView.reloadData()
            
        }
        //        self.optionsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
    @IBAction func voteButtonAction(_ sender: Any) {
        if (cardData.data?.isMultiple != "1" && selectedIndex > 0 ) || ( cardData.data?.isMultiple == "1" && selectedOptionIndexArray.contains(true))  {
            if USERID == "0" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                vc.isFromAction = true
                vc.delegate = self
                let nvc = UINavigationController(rootViewController: vc)
                self.present(nvc, animated: true, completion: nil)
            } else {
                voteWebservice()
            }
        } else{
            self.showAlert(message: "Please select an option")
        }
    }
    
    @IBAction func infoButtonAction(_ sender: UIButton){
        showDescription = !showDescription
        UITableView.performWithoutAnimation {
            optionsTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        //        let dict = cardData.data
        var shareLink = ""
        if let idTopic = cardData.data?.id{
            if type == .prediction{
                shareLink = Common.shared.shareURL(id: idTopic, isVoice: 1)
            }else if type == .askQuestion
            {
                shareLink = Common.shared.shareURL(id: idTopic, isVoice: 4)
            }else
            {
                shareLink = Common.shared.shareURL(id: idTopic, isVoice: 0)
            }
            
            if let someText:String = cardData.data?.title{
                let objectsToShare = URL(string:shareLink)
                let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
                let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        let commentsViewController = storyboard?.instantiateViewController(withIdentifier: "RevisedCommentsViewController") as! RevisedCommentsViewController
        commentsViewController.commentId = "\(sender.tag)"
        if let typ = type {
            commentsViewController.type = typ
            commentsViewController.isOnlyCommentsView = true
            commentsViewController.delegate = self
            self.navigationController?.pushViewController(commentsViewController, animated: true)
        }
    }
    @IBAction func viewMoreButtonAction(_ sender: Any) {
        cardListViewController = storyboard?.instantiateViewController(withIdentifier: "CardMainViewViewController") as! CardMainViewViewController
        if let typ = type, typ == CardType.askQuestion {
            cardListViewController.type = CardType.askQuestion
        }else
        {
            cardListViewController.type = CardType.prediction
        }
        if isFromCardList == true {
            self.navigationController?.popViewController(animated: true)
        }else {
            self.navigationController?.pushViewController(cardListViewController, animated: true)
        }
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

extension CardDetailsViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if optionsArray.count > 0{
            return optionsArray.count + 2
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardDetailsViewHeaderCell", for: indexPath) as! CardDetailsTableViewCell
            
            
            if let userChoice = cardData.data?.users_choice, userChoice.isEmpty {
                cell.expertSwitch.isHidden = true
                cell.expertLabel.isHidden = true
                cell.expertSwitchHeight.constant = 0

            } else {
                cell.expertSwitchHeight.constant = 31
                cell.expertSwitch.isHidden = false
                cell.expertLabel.isHidden = false
            }
            
            if let typ = type, typ == CardType.askQuestion {
                cell.expertSwitch.isHidden = true
                cell.expertLabel.isHidden = true
                cell.expertSwitchHeight.constant = 0
            }
            
            if let date = cardData.data?.created_date, let alias = cardData.data?.alias, let raisedBy = cardData.data?.raised_by_admin {
                let dat = Common.shared.stringFromDateString(date: date, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "MMMM dd, yyyy", isUT: false)
                
                if raisedBy == "1"{
                    cell.infoLabel.text = "By "
                    cell.infoLabel.addImage(imageName: "logo_red", afterLabel: true, afterText: "| \(dat)")
                } else {
                    cell.infoLabel.text = "By \(alias) | \(dat)"
                }
                cell.infoLabel.font = Common.shared.getFont(type: .medium, size: 12)
                cell.infoLabel.textColor = UIColor.darkGray
            }
            cell.expertSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            cell.expertSwitch.tag = indexPath.row
            //            cell.expertSwitch.addTarget(self, action: #selector(animateSwitch(_:)), for: .touchUpInside)
            cell.expertSwitch.addTarget(self, action: #selector(expertSwitchChangedAction(_:)), for: .valueChanged)
            cell.commentButton.tag = Int(cardData.data?.id ?? "0") ?? 0
            cell.commentButton.addTarget(self, action: #selector(commentButtonTapped(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            cell.expertSwitch.setOn(self.expertOn, animated: false)
            let filteredConstraints = cell.descriptionView.constraints.filter { $0.identifier == "heightConstraint" }
            if let const = filteredConstraints.first {
                const.isActive = false
            }
            var constraint = NSLayoutConstraint()
            constraint.identifier = "heightConstraint"
            
            cell.viewDescriptionButton.addTarget(self, action: #selector(infoButtonAction(_:)), for: .touchUpInside)
            
            if showDescription{
                UIView.animate(withDuration: 0.2) {
                    cell.knowMoreImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }
                cell.descriptionView.isHidden = false
                constraint = NSLayoutConstraint(item: cell.descriptionView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 73)
            } else{
                UIView.animate(withDuration: 0.2) {
                    cell.knowMoreImageView.transform = .identity
                }
                cell.descriptionView.isHidden = true
                constraint = NSLayoutConstraint(item: cell.descriptionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
                constraint.identifier = "heightConstraint"
            }
            cell.questionLabel.text = (cardData.data?.title)?.handleApostrophe()
            
            let commentString = cardData.data?.total_comments == "0" || cardData.data?.total_comments == "1" ? "COMMENT" : "COMMENTS"
            let ViewsString = cardData.data?.total_votes == "0" || cardData.data?.total_votes == "1" ? "VOTE" : "VOTES"
            
//            cell.commentsLabel.text = "3000 COMMENTS"
            cell.commentsLabel.text = "\(cardData.data?.total_comments ?? "") \(commentString)"
            cell.votesLabel.setTitle("\(cardData.data?.total_votes ?? "") \(ViewsString)", for: .normal)
            cell.descriptionLabel.text = cardData.data?.description
            cell.descriptionLabel.textColor = UIColor.darkGray
            if let imageURL = URL(string: cardData.data?.image ?? "") {
                cell.cardImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
                cell.cardImageView.contentMode = .scaleAspectFit
            }
            cell.descriptionView.addConstraint(constraint)
            constraint.isActive = true
            cell.viewDescriptionButton.setTitleColor(BLUE_COLOR, for: .normal)
            
            cell.shareButton.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
            return cell
        } else if indexPath.row == (optionsTableView.numberOfRows(inSection: 0) - 1){
            if let typ = type, let userChoice = cardData.data?.users_choice, typ == CardType.askQuestion, !userChoice.isEmpty {
                return UITableViewCell()
            }
            
            if let typ = type, let expiryString = cardData.data?.end_date, typ == CardType.prediction {
                let expiryDate = Common.shared.dateFromStringDate(date: expiryString, fromFormat: "yyyy-MM-dd HH:mm:ss ", isUTC: false)
                guard let exDate = expiryDate,
                    exDate > Date() else {
                        return UITableViewCell()
                }
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "VoteTableViewCell", for: indexPath) as! VoteTableViewCell
            cell.voteButton.addTarget(self, action: #selector(voteButtonAction(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }else {
            let option = optionsArray[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "progressBarCell", for: indexPath) as! CardPercentTableViewCell
            
            cell.optionNameLabel.text = option.choice ?? ""
            cell.optionNameLabel.numberOfLines = 0
            cell.selectionStyle = .none
            cell.progressBarView.setIndicatorTextMode(.none)
            
            if expertOn && expertOptions.count > indexPath.row {
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
//                cell.percentLabel.textColor = UIColor.white
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
            //            cell.tintView.isHidden = true
            
            if isMultipleChoice == "1" {
                if selectedOptionIndexArray[indexPath.row] {
                    //                cell.progressBarView.backgroundColor = UIColor(hexString: "#007AFF")
                    cell.tintView.backgroundColor = UIColor(hexString: "#007AFF")
                    cell.optionNameLabel.textColor = UIColor.white
                    cell.percentLabel.textColor = UIColor.white
                } else{
                    if expertOn{
                        cell.optionNameLabel.textColor = UIColor.darkGray
                        cell.percentLabel.textColor = UIColor.black
                    } else{
                        if option.choice_id == cardData.data?.users_choice{
                            cell.optionNameLabel.textColor = UIColor(hexString: "#007AFF")
                            cell.percentLabel.textColor = UIColor(hexString: "#007AFF")
                            cell.percentLabel.textColor = UIColor(hexString: "#007AFF")
                            //                        cell.bringSubviewToFront(cell.progressBarView.indicatorTextLabel)
                        } else{
                            cell.optionNameLabel.textColor = UIColor.darkGray
                            cell.percentLabel.textColor = UIColor.darkGray
                            cell.percentLabel.textColor = UIColor.darkGray
                        }
                        
                    }
                    //                cell.progressBarView.backgroundColor = UIColor.groupTableViewBackground
                    cell.tintView.backgroundColor = UIColor.clear
                }
            } else {
                if selectedIndex == indexPath.row{
                    //                cell.progressBarView.backgroundColor = UIColor(hexString: "#007AFF")
                    cell.tintView.backgroundColor = UIColor(hexString: "#007AFF")
                    cell.optionNameLabel.textColor = UIColor.white
                    cell.percentLabel.textColor = UIColor.white
                } else{
                    if expertOn{
                        cell.optionNameLabel.textColor = UIColor.darkGray
                        cell.percentLabel.textColor = UIColor.black
                    } else{
                        if option.choice_id == cardData.data?.users_choice{
                            cell.optionNameLabel.textColor = UIColor(hexString: "#007AFF")
                            cell.percentLabel.textColor = UIColor(hexString: "#007AFF")
                            cell.percentLabel.textColor = UIColor(hexString: "#007AFF")
                            //                        cell.bringSubviewToFront(cell.progressBarView.indicatorTextLabel)
                        } else{
                            cell.optionNameLabel.textColor = UIColor.darkGray
                            cell.percentLabel.textColor = UIColor.darkGray
                            cell.percentLabel.textColor = UIColor.darkGray
                        }
                        
                    }
                    //                cell.progressBarView.backgroundColor = UIColor.groupTableViewBackground
                    cell.tintView.backgroundColor = UIColor.clear
                }

            }
            
            
//            cell.progressBarView.indicatorTextLabel.textColor = UIColor.darkGray
            
            cell.progressBarView.backgroundColor = UIColor.groupTableViewBackground
            cell.progressBarView.layer.cornerRadius = 20
            
            cell.progressBarView.clipsToBounds = true
            return cell
        }
        //        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath.row] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row] ?? UITableView.automaticDimension
    }
    
}

extension CardDetailsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let typ = type, let userChoice = cardData.data?.users_choice, typ == CardType.askQuestion, !userChoice.isEmpty {
            return
        }
        if let typ = type, let expiryString = cardData.data?.end_date, typ == CardType.prediction {
            let expiryDate = Common.shared.dateFromStringDate(date: expiryString, fromFormat: "yyyy-MM-dd HH:mm:ss ", isUTC: false)
            guard let exDate = expiryDate,
                exDate > Date() else {
                    return
            }
        }
        if indexPath.row > optionsArray.count {
            return
        }
        
        if isMultipleChoice == "1" {
            if indexPath.row < selectedOptionIndexArray.count {
                selectedOptionIndexArray[indexPath.row] = !selectedOptionIndexArray[indexPath.row]
            }
        }
        
        let previousIndex = selectedIndex
        
        selectedIndex = indexPath.row
        
        if selectedIndex == 0{
            for i in 0..<optionsArray.count{
               optionsArray[i].selected = false
            }
            UIView.performWithoutAnimation {
                self.optionsTableView.reloadData()
            }
        } else{
            
            if indexPath.row > 0 && indexPath.row < self.optionsTableView.numberOfRows(inSection: 0) - 1 && selectedIndex > 0{
                
                self.optionsArray[selectedIndex - 1].selected = true
                
                UIView.performWithoutAnimation {
                    self.optionsTableView.reloadRows(at: [IndexPath(row: selectedIndex, section: 0), IndexPath(row: previousIndex, section: 0)], with: .none)
                }
            }
        }
    }
    
}

extension CardDetailsViewController {
    func getCardDetail(with type: CardType) {
        var api = String()
        switch type {
        case .competition:
            api = API_RATEDARTICLE_DETAIL
        case .prediction:
            api = API_PREDICTIONS_DETAIL
        case .askQuestion:
            api = API_ASKQUESTIONS_DETAIL
        case .voice:
            api = API_RATEDARTICLE_DETAIL
        case .ratedArticle:
            api = API_RATEDARTICLE_DETAIL
        case .discussion:
            api = API_RATEDARTICLE_DETAIL
        }
        
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            Service.sharedInstance.request(api: api, type: .post, parameters: ["user_id":USERID,"id":cardId], complete: { (response) in
                do {
                    self.hideNoDataInfo()
                    self.cardData = try decoder.decode(TypeStatus.self, from: response as! Data)
                    
                    self.setDetails()
                    if self.isAfterLogin { self.voteWebservice() }
                } catch {
                    self.showAlert(message: "\(error)")
                }
                self.optionsTableView.isHidden = false
                Loader.hide(for: self.view, animated: true)
            }) { (error) in
                DLog(message: error)
                Loader.hide(for: self.view, animated: true)
            }
        } else {
            
            self.setNoInternetInfo(with: self.view.frame, backgroungColor: .white)
            //            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func voteWebservice(){
        if NetworkStatus.shared.haveInternet(){
            Loader.showAdded(to: self.view, animated: true)
            
            
            var params = [String: Any]()
            
            var api = String()
            if let typ = type {
                //FIXME:- Fix API
                
                switch typ {
                case .competition:
                    DLog(message: api)
                case .prediction:
                    let selectedOption = optionsArray[selectedIndex - 1]
                    params = ["id":cardId,
                              "choice":selectedOption.choice_id ?? "",
                              "user_id":USERID] as [String : Any]
                    api = API_PREDICTIONS_VOTE
                case .askQuestion:
                    if isMultipleChoice == "1" {
                        if selectedOptionIndexArray.count > 2 {
                            selectedOptionIndexArray.removeFirst()
                            selectedOptionIndexArray.removeLast()
                        }
                        var selectedIdArray = [String]()
                        for i in 0..<selectedOptionIndexArray.count {
                            if selectedOptionIndexArray[i] {
                                selectedIdArray.append(optionsArray[i].choice_id ?? "")
                            }
                        }
                        params = ["id":cardId,
                                  "choice":selectedIdArray,
                                  "user_id":USERID] as [String : Any]
                    } else {
                        let selectedOption = optionsArray[selectedIndex - 1]
                        params = ["id":cardId,
                                  "choice":[selectedOption.choice_id ?? ""],
                                  "user_id":USERID] as [String : Any]
                    }
                    
                    api = API_ASKQUESTIONS_VOTE
                case .voice:
                    DLog(message: api)
                case .ratedArticle:
                    DLog(message: api)
                case .discussion:
                    DLog(message: api)
                
                }
            }
            
            Service.sharedInstance.request(api: api, type: .post, parameters: params, complete: { (response) in
                do{
                    let resp = try decoder.decode(TypeStatus.self, from: response as! Data)
                    if resp.status ?? false{
                        if self.cardData.data?.users_choice == "" && USERID != "0" {
                            self.coinAnimation()
                        }
                        self.selectedIndex = 0
                        self.cardData = resp
                        self.expertOn = false
                        self.showPercent = true
                        self.setDetails()
                    } else{
                        DLog(message: "Something went wrong.")
                    }
                } catch{
                    DLog(message: "\(error)")
                }
                Loader.hide(for: self.view, animated: true)
            }) { (error) in
                Loader.hide(for: self.view, animated: true)
            }
            
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func coinAnimation(){
        let tintView = UIView(frame: Device.SCREEN_BOUND)
        tintView.backgroundColor = UIColor.init(hexString: "#000000", alpha: 0.5)
        let containerView = UIView(frame: CGRect(x: Device.SCREEN_WIDTH/2 - 100 , y: Device.SCREEN_HEIGHT/2 - 100 - Int(self.tabBarController?.tabBar.frame.height ?? 0) - Int(self.navigationController?.navigationBar.frame.height ?? 0), width: 200, height: 200))
        containerView.backgroundColor = UIColor.white
        let animationView = LOTAnimationView(name: "lottie_wallet")
        animationView.frame = containerView.bounds
        animationView.contentMode = .scaleAspectFit
        
        let infoLabel = UILabel(frame: CGRect(x: 0, y: containerView.frame.height - 40
            , width: containerView.frame.width, height: 20))
        if type == .askQuestion{
            infoLabel.text = "You got 2 silver point."
        } else{
            infoLabel.text = "You got 1 silver point."
        }
        infoLabel.font = Common.shared.getFont(type: .bold, size: 13)
        infoLabel.textAlignment = .center
        containerView.addSubview(animationView)
        containerView.addSubview(infoLabel)
        tintView.addSubview(containerView)
        self.view.addSubview(tintView)
        self.refreshDelegate?.refreshVotes(index: index, section: section)
        animationView.play(fromProgress: 0.5, toProgress: 1.0, withCompletion:{ (finished) in
            tintView.removeFromSuperview()
        })
    }
    
    func callExpertWebservice(){
        
        if NetworkStatus.shared.haveInternet(){
            let params = ["id" : cardId]
            var api = String()
            if let typ = type {

                //FIXME:- Fix API
                switch typ {
                case .competition:
                    DLog(message: api)
                case .prediction:
                    api = API_PREDICTIONS_EXPERT
                case .askQuestion:
                    DLog(message: api)
                case .voice:
                    DLog(message: api)
                case .ratedArticle:
                    DLog(message: api)
                case .discussion:
                    DLog(message: api)
                }
            }
            
            Service.sharedInstance.request(api: "ApiPredictions/experts_result", type: .post, parameters: params, complete: { (response) in
                
                do{
                    let resp = try decoder.decode(ExpertResponse.self, from: response as! Data)
                    
                    
//                    self.expertOptions = resp.data
                    let sortArray = resp.data.sorted(by: { Float($0.expertPercent!)! > Float($1.expertPercent!)!})
                    
                    self.expertOptions = sortArray
                    self.expertOn = true
                    //                    self.selectedIndex = 0
                    //                    for i in 0..<self.optionsArray.count{
                    //                        var option = self.optionsArray[i]
                    //                        option.selected = false
                    //                        self.optionsArray[i] = option
                    //                    }
                    UIView.performWithoutAnimation {
                        self.optionsTableView.reloadData()
                        
                    }
                    //                    self.optionsTableView.scrollToRow(at: IndexPath(row: self.optionsTableView.numberOfRows(inSection: 0) - 1, section: 0), at: .bottom, animated: false)
                    
                } catch{
                    DLog(message: "\(error)")
                }
                
            }) { (error) in
                DLog(message: "\(error)")
            }
            
        } else{
            DLog(message: "No internet.")
        }
        
    }
    
    
    func setDetails(){
        
        self.optionsArray = self.cardData.data?.options ?? [Options]()
        print("normal:\(optionsArray)")
        
        
        
       /* let tempArray = NSMutableArray()
        for  index in self.optionsArray {
            tempArray.add(index.toDictionary())
        }
        
        let descriptor: NSSortDescriptor =  NSSortDescriptor(key: "avg", ascending: false, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        let sortedResults: NSArray = tempArray.sortedArray(using: [descriptor]) as NSArray
        
        for index in 0..<sortedResults.count  {
            do {
                let dict: [String: Any] = sortedResults[index] as! [String: Any]
                let dataExample: Data = NSKeyedArchiver.archivedData(withRootObject: dict)
                let resp = try decoder.decode(Options.self, from: dict)
                self.optionsArray.append(resp)
            }catch {
                
            }
           
        }
        print("sortedResults:\(optionsArray)")*/

       
        selectedOptionIndexArray = [Bool](repeating: false, count: optionsArray.count + 2)
        isMultipleChoice = cardData.data?.isMultiple ?? "0"
        if self.cardData.data?.users_choice == ""{
            self.showPercent = false
        } else{
            let sortArray = self.optionsArray.sorted(by: { Float($0.avg!)! > Float($1.avg!)!})
            print("sortedResults:\(sortArray)")
            self.optionsArray.removeAll()
            self.optionsArray = sortArray
            self.showPercent = true
        }
        //        for i in 0..<self.optionsArray.count{
        //            var option = self.optionsArray[i]
        //            if option.choice_id == self.cardData.data?.users_choice{
        //                option.selected = true
        //            } else{
        //                option.selected = false
        //            }
        //            self.optionsArray[i] = option
        //        }
        UIView.performWithoutAnimation {
            self.optionsTableView.reloadData()
            
        }
        //        if !isFirstTime{
        //            self.optionsTableView.scrollToRow(at: IndexPath(row: optionsTableView.numberOfRows(inSection: 0) - 1, section: 0), at: .bottom, animated: false)
        //        }
        //        isFirstTime = false
        DispatchQueue.main.async {
            if let headerCell = self.optionsTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CardDetailsTableViewCell{
                headerCell.expertSwitch.setOn(false, animated: true)
            }
        }
    }
}

extension CardDetailsViewController: RevisedCommentsViewDelegate{
    func updateViewFrame(height: CGFloat) {
        
    }
    
    func updateComment(deleted: Bool) {
        refreshDelegate?.refreshComments(index: index, isDelete: deleted, section: section)
        guard var totalComment = cardData.data?.total_comments, let totalCount = Int(totalComment) else {
            return
        }
        
        if deleted{
            totalComment = "\(totalCount - 1)"
        } else{
            totalComment = "\(totalCount + 1)"
        }
        
        cardData.data?.total_comments = totalComment
        optionsTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
}

extension CardDetailsViewController: LoginViewDelegate {
    func loginSuccessful() {
        isAfterLogin = true
        if let typ = type {
            optionsTableView.isHidden = true
            getCardDetail(with: typ)
        }
    }
}
