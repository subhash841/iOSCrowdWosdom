//
//  ReplyViewController.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 11/5/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

protocol RefreshCommentsDelegate {
    func callService()
}

class ReplyViewController: NavigationBaseViewController {
    
    @IBOutlet weak var textFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var replyTextView: UITextView!
    @IBOutlet weak var userInitial: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var replyTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentlabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var noRepliesView: UIView!
    var refreshCommentDelegate: RefreshCommentsDelegate?
    
    var id = ""
    var voiceId = ""
    var type: CardType!
    var replyArray = [ReplyData]()
    var replyIndexPath = IndexPath()
    var offset = 0
    var isAvailable = ""
    var isOnlyCommentsView = Bool()
    var comment: CommentData?
    var headerHeight: CGFloat = 70
    var heightContext : UInt16 = 0
    
    @IBOutlet weak var replyTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var replyViewHeight: NSLayoutConstraint!
    var initialHeightReplyView = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emptyViewY = 250
        self.replyTableView.tableFooterView = UIView()

        setDetails()
        self.emptyStateAction = {
            self.getRepliesOfComment()
        }
        replyTableView.register(UINib(nibName: "ReplyHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "ReplyHeaderTableViewCell")
        
        replyTableView.register(UINib(nibName: "ReplyTableViewCell", bundle: nil), forCellReuseIdentifier: "replyCell")
        
        getRepliesOfComment()
        self.setupLeftBarButton(isback: true)
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
//        UIView.animate(withDuration: 0.2) {
//            self.replyTextView.resignFirstResponder()
//        }
        //        initialHeightReplyView = replyViewHeight.constant
    }
    func setDetails(){
        self.userName.text = comment?.alias != "" ? comment?.alias?.capitalizingFirstLetter() : comment?.alise?.capitalizingFirstLetter()
        
        self.commentLabel.text = comment?.comment
        self.userInitial.text = "\(self.userName.text?.uppercased().first ?? "U")"
        
        replyTextView.layer.borderWidth = 0.5
        replyTextView.layer.borderColor = UIColor.lightGray.cgColor
        replyTextView.layer.cornerRadius = 15
        Common.shared.assignColorToUser {
            userArray.insert(comment?.userID ?? "nil")
        }
        userInitial.backgroundColor = colorDictionary[comment?.userID ?? "nil"]
        userInitial.clipsToBounds = true
        userInitial.layer.cornerRadius = userInitial.frame.height/2
        
        replyButton.layer.cornerRadius = replyButton.frame.height/2
        
        replyTextView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        replyTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: &heightContext)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.commentLabel.sizeToFit()
            //self.replyTextView.becomeFirstResponder()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if object as? UITextView == replyTextView {
            let tv:UITextView = object as! UITextView
//            var topCorrect = (tv.bounds.size.height - tv.contentSize.height - tv.contentSize.height * tv.zoomScale)/2.0
//            topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect )
//            tv.contentOffset = CGPoint(x: 0, y: -topCorrect)
            if tv.contentSize.height < 100 {
                replyTextViewHeight.constant = tv.contentSize.height
                replyTextViewHeight.constant = tv.contentSize.height + 8
            } else {
                replyTextViewHeight.constant = 100
            }
            
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.tableViewHeightConstraint.constant = self.replyTableView.contentSize.height
            }
        }
        
//        if keyPath == "contentSize"{
//            if context == &heightContext{
//                tableViewHeightConstraint.constant = replyTableView.contentSize.height
//            } else{
//                if replyTextView.contentSize.height <= 80{
//                    textFieldHeight.constant = replyTextView.contentSize.height
//                    headerHeight = 70 + cell.editCommentTextField.contentSize.height
//                    cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.width, height: headerHeight)
//                } else{
//                    textFieldHeight.constant = 80
//                    headerHeight = 80 + 70
//                    cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.width, height: headerHeight)
//                }
//            }
//        }
    }
    
    deinit {
        let cell = replyTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ReplyHeaderTableViewCell
        cell?.editCommentTextField.removeObserver(self, forKeyPath: "contentSize")
    }
    
    //MARK:- APIs
    
    func getRepliesOfComment() {
        var api = String()
        var id_key = String()
        var params = [String : Any]()

        
        DLog(message: "offset: \(offset)")
        guard let typ = type else { return }
        
        switch typ {
        case .competition:
            api = API_VOICE_REPLY_OF_COMMENT
            id_key = "voice_id"
            params = ["offset":offset, id_key: voiceId, "comment_id": id]
        case .prediction:
            api = API_PREDICTIONS_REPLY_OF_COMMENT
            id_key = "id"
            params = ["offset":offset, id_key: voiceId, "comment_id": id]

        case .askQuestion:
            api = API_ASKQUESTIONS_REPLY_OF_COMMENT
            id_key = "id"
            params = ["offset":offset, id_key: voiceId, "comment_id": id]

        case .voice:
            api = API_VOICE_REPLY_OF_COMMENT
            id_key = "voice_id"
            params = ["offset":offset, id_key: voiceId, "comment_id": id]

        case .ratedArticle:
            api = API_RATEDARTICLE_REPLY_LIST
            id_key = "id"
            params = ["offset":offset, id_key: voiceId, "comment_id": id]
            params["user_id"] = USERID
        case .discussion:
            api = API_DISSCUSSION_REPLY_OF_COMMENT
            id_key = "id"
            params = ["offset":offset, id_key: voiceId, "comment_id": id]
        }
        
        if offset == 0{
            replyArray.removeAll()
        }
        
        if NetworkStatus.shared.haveInternet() {
            Common.shared.showLoader(isEmpty: isEmptyState, view: self.view)
            Service.sharedInstance.request(api: api, type: .post, parameters: params, complete: { (response) in
                do {
                    let reply = try decoder.decode(Reply.self, from: response as! Data)
                    self.replyArray += reply.data
                    self.isAvailable = reply.isAvailable
                    Common.shared.assignColorToUser(completion: {
                        userArray = userArray.union(Set(self.replyArray.compactMap{ $0.userID }))
                    })
                    self.replyTableView.reloadData()
                    if self.replyArray.isEmpty {
                        self.noRepliesView.isHidden = false
                        self.replyTableView.isHidden = true
                        //                        self.setNoReplyState()
                        //                        if self.isEmptyState {
                        //                            self.stopAnimationEmptyState()
                        //                        }
                        //                        self.isEmptyState = true
                    } else {
                        self.noRepliesView.isHidden = true
                        self.replyTableView.isHidden = false
                        self.emptyView.removeFromSuperview()
                    }
                } catch {
                    DLog(message: error)
                    self.showAlert(message: SOMETHING_WENT_WRONG)
                }
                Loader.hide(for: self.view, animated: true)
            }) { (error) in
//                DLog(message: error)
                self.showAlert(message: SOMETHING_WENT_WRONG)

                self.showAlert(message: "\(error)")
                Loader.hide(for: self.view, animated: true)
            }
        } else {
            if isOnlyCommentsView{
                self.setNoConnectionState()
            }
            //self.showAlert(message: NO_INTERNET)
        }
    }
    
    func addReply(with reply: String) {
        var api = String()
        var id_key = String()
        
        guard let cardType = type else {
            return
        }
        
        switch cardType {
        case .competition:
            api = API_VOICE_ADD_COMMENT_REPLY
            id_key = "voice_id"
        case .prediction:
            api = API_PREDICTIONS_ADD_COMMENT_REPLY
            id_key = "id"
        case .askQuestion:
            api = API_ASKQUESTIONS_ADD_COMMENT_REPLY
            id_key = "id"
        case .voice:
            api = API_VOICE_ADD_COMMENT_REPLY
            id_key = "voice_id"
        case .ratedArticle:
            api = API_RATEDARTICLE_ADD_REPLY
            id_key = "id"
        case .discussion:
            api = API_DISSCUSSION_ADD_COMMENT_REPLY
            id_key = "id"
        
        }
        
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            var params = [String: Any]()
            
            params = [id_key :voiceId,
                      "comment_id":id,
                      "comment_reply": reply,
                      "user_id":USERID,
            "comment_reply_id":"0"]
            
            Service.sharedInstance.request(api: api, type: .post, parameters: params, complete: { (response) in
                do {
                    let newReply = try decoder.decode(NewReply.self, from: response as! Data)
                    //                    self.showAlert(message: newReply.message)
                    //                    self.refreshCommentTextField()
                    self.replyTextView.text = ""
                    //                    self.textFieldHeight.constant = 30
                    //                    self.replyViewHeight.constant = self.initialHeightReplyView
                    self.offset = 0
                    self.getRepliesOfComment()
                    self.refreshCommentDelegate?.callService()
                    
                } catch {
                    DLog(message: error)
                    self.showAlert(message: SOMETHING_WENT_WRONG)
                }
                Loader.hide(for: self.view, animated: true)
            }) { (error) in
                self.showAlert(message: SOMETHING_WENT_WRONG)
                Loader.hide(for: self.view, animated: true)
                DLog(message: error)
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func editReply(with reply: String, replyID: String) {
        var api = String()
        var id_key = String()
        
        guard let cardType = type else {
            return
        }
        
        switch cardType {
        case .competition:
            api = API_VOICE_UPDATE_REPLY
            id_key = "voice_id"
        case .prediction:
            api = API_PREDICTIONS_UPDATE_REPLY
            id_key = "id"
        case .askQuestion:
            api = API_ASKQUESTIONS_UPDATE_REPLY
            id_key = "id"
        case .voice:
            api = API_VOICE_UPDATE_REPLY
            id_key = "voice_id"
        case .ratedArticle:
            api = API_RATEDARTICLE_UPDATE_REPLY
            id_key = "id"
        case .discussion:
            api = API_DISSCUSSION_UPDATE_REPLY
            id_key = "id"
        }
        
        if NetworkStatus.shared.haveInternet() {
            
            Loader.showAdded(to: self.view, animated: true)
            Service.sharedInstance.request(api: api, type: .post, parameters: [id_key: voiceId, "comment_reply": reply, "comment_id": id, "comment_reply_id": replyID, "user_id": USERID] as [String : Any], complete: { (response) in
                do {
                    let newReply = try decoder.decode(NewReply.self, from: response as! Data)
                    //                    self.showAlert(message: newReply.message ?? "")
                    self.offset = 0
                    self.getRepliesOfComment()
                    
                } catch {
                    DLog(message: error)
                    self.showAlert(message: SOMETHING_WENT_WRONG)
                }
                Loader.hide(for: self.view, animated: true)
            }) { (error) in
                DLog(message: error)
                self.showAlert(message: SOMETHING_WENT_WRONG)
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func deleteReply(with replyID: String) {
        
        var api = String()
        var id_key = String()
        
        guard let cardType = type else {
            return
        }
        
        switch cardType {
        case .competition:
            api = API_VOICE_DELETE_REPLY
            id_key = "voice_id"
        case .prediction:
            api = API_PREDICTIONS_DELETE_REPLY
            id_key = "id"
        case .askQuestion:
            api = API_ASKQUESTIONS_DELETE_REPLY
            id_key = "id"
        case .voice:
            api = API_VOICE_DELETE_REPLY
            id_key = "voice_id"
        case .ratedArticle:
            api = API_RATEDARTICLE_DELETE_REPLY
            id_key = "id"
        case .discussion:
            api = API_DISSCUSSION_DELETE_REPLY
            id_key = "id"
        }
        
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            Service.sharedInstance.request(api: api, type: .post, parameters: [id_key: voiceId, "comment_reply_id":replyID , "comment_id":id, "user_id": USERID] as [String : Any], complete: { (response) in
                do {
                    let status = try decoder.decode(NewVoiceComment.self, from: response as! Data)
                    //                    self.showAlert(message: status.message ?? "")
                    self.offset = 0
                    self.refreshCommentDelegate?.callService()
                } catch {
                    DLog(message: error)
                    self.showAlert(message: SOMETHING_WENT_WRONG)
                }
                self.getRepliesOfComment()
                Loader.hide(for: self.view, animated: true)
            }) { (error) in
                DLog(message: error)
                self.showAlert(message: SOMETHING_WENT_WRONG)
                Loader.hide(for: self.view, animated: true)
            }
        } else {
            self.showAlert(message: NO_INTERNET)
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

extension ReplyViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == replyArray.count - 2) && isAvailable == "1"{
            self.offset = replyArray.count
            getRepliesOfComment()
        }
    }
    
}

extension ReplyViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if indexPath.row == 0{
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyHeaderTableViewCell", for: indexPath) as! ReplyHeaderTableViewCell
        ////            cell.replyButton.addTarget(self, action: #selector(replyBtnAction(_:)), for: .touchUpInside)
        //            cell.editCommentSendButton.addTarget(self, action: #selector(sendButtonPressed(_:)), for: .touchUpInside)
        //            cell.selectionStyle = .none
        //            var aliasString = String()
        //            if let alias = comment?.alias, let alise = comment?.alise {
        //                aliasString = alias != "" ? alias : alise
        //                cell.aliasLabel.text = aliasString.capitalizingFirstLetter()
        //            }
        //
        //            if let commentData = comment {
        //                cell.commentLabel.text = commentData.comment
        //                cell.userInitialLabel.text = "\(cell.aliasLabel.text?.first ?? "U")"
        ////                cell.numberOfRepliesLabel.text = "\(commentData.totalReplies ?? "0") Replies"
        ////                cell.numberOfRepliesLabel.isHidden = true
        //            }
        //
        //            cell.editCommentTextField.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        //
        //            return cell
        //        } else{
        let dict = replyArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! ReplyTableViewCell
        cell.userNameLabel.text = dict.alias?.capitalizingFirstLetter()
        cell.replyLabel.text = dict.reply
        cell.editButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        cell.editReplySendButton.tag = indexPath.row
        
        if dict.isEdit ?? false{
            cell.replyLabel.alpha = 0.0
            cell.editView.alpha = 1.0
            cell.editButtonheight.constant = 30.0
        } else{
            cell.replyLabel.alpha = 1.0
            cell.editView.alpha = 0.0
            if dict.userID == USERID {
                cell.editButtonheight.constant = 30.0
            }else{
                cell.editButtonheight.constant = 0.0
            }
        }
        
        cell.userInitialLabel.text = "\(cell.userNameLabel.text?.first ?? "U")"
        if dict.userID == USERID{
            cell.editButton.isHidden = false
            cell.deleteButton.isHidden = false
            cell.decorationView.isHidden = false
        } else{
            cell.editButton.isHidden = true
            cell.deleteButton.isHidden = true
            cell.decorationView.isHidden = true
        }
        cell.userInitialLabel.backgroundColor = colorDictionary[dict.userID ?? "nil"]
        cell.editReplySendButton.addTarget(self, action: #selector(editReplyPressed(_:)), for: .touchUpInside)
        cell.editButton.addTarget(self, action: #selector(replyBtnPressed(_:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(deleteReplyPressed(_:)), for: .touchUpInside)
        cell.cancelBtn.tag = indexPath.row
        cell.cancelBtn.addTarget(self, action: #selector(cancelButtonAction(_:)), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
        //        }
        
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
////        let cell = replyTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0))
//        cell.replyLabel.alpha = 1.0
//        cell.editView.alpha = 0.0
        replyArray[sender.tag].isEdit = !(replyArray[sender.tag].isEdit ?? true)
        UIView.performWithoutAnimation {
            replyTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
        }
    }
    
    @IBAction func replyBtnAction(_ sender: UIButton){
        if NetworkStatus.shared.haveInternet() {
            let cell = replyTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ReplyHeaderTableViewCell
            if cell.editView.alpha == 1{
                //            cell.commentLabel.alpha = 1
                cell.editView.alpha = 0
                cell.editViewHeightConstraint.constant = 0
            } else{
                //            cell.commentLabel.alpha = 0
                cell.editView.alpha = 1
                cell.editViewHeightConstraint.constant = 30
            }
            //        cell.setNeedsLayout()
            //        cell.layoutIfNeeded()
            //        DispatchQueue.main.async {
            self.replyTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            //        }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton){
        //        replyIndexPath = IndexPath(row: sender.tag, section: 0)
        //        let cell = replyTableView.cellForRow(at: replyIndexPath) as! ReplyHeaderTableViewCell
        
        if replyTextView.validate() {
            replyTextView.resignFirstResponder()
            if USERID == "0" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                vc.isFromAction = true
                vc.delegate = self
                let nvc = UINavigationController(rootViewController: vc)
                self.present(nvc, animated: true, completion: nil)
            } else {
                self.addReply(with: replyTextView.text!)
            }
        } else {
            self.showAlert(message: NO_REPLY)
        }
    }
    
    @IBAction func replyBtnPressed(_ sender: UIButton){
        if NetworkStatus.shared.haveInternet() {
            replyIndexPath = IndexPath(row: sender.tag, section: 0)
            let cell = replyTableView.cellForRow(at: replyIndexPath) as! ReplyTableViewCell
            UIView.animate(withDuration: 0.3) {
                if cell.replyLabel.alpha == 0{
                    cell.replyLabel.alpha = 1
                    cell.editView.alpha = 0
                } else{
                    cell.editReplyTextField.text = cell.replyLabel.text
                    cell.editReplyTextField.becomeFirstResponder()
                    cell.replyLabel.alpha = 0
                    cell.editView.alpha = 1
                }
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    @IBAction func editReplyPressed(_ sender: UIButton){
        if NetworkStatus.shared.haveInternet() {
            let dict = replyArray[sender.tag]
            let cell = replyTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! ReplyTableViewCell
            if cell.editReplyTextField.validate(), let reply = cell.editReplyTextField.text{
                cell.editReplyTextField.text = ""
                cell.replyLabel.alpha = 1
                cell.editView.alpha = 0
                if let id = dict.id{
                    editReply(with: reply, replyID: id)
                } else {
                    self.showAlert(message: SOMETHING_WENT_WRONG)
                }
            } else {
                self.showAlert(message: "Reply can't be empty")
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    @IBAction func deleteReplyPressed(_ sender: UIButton){
        if NetworkStatus.shared.haveInternet() {
            let alert = UIAlertController(title: "Delete Reply", message: "Are you sure, you want to delete this reply?", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
                print("User click Delete button")
                let dict = self.replyArray[sender.tag]
                if let id = dict.id{
                    self.deleteReply(with: id)
                } else {
                    self.showAlert(message: SOMETHING_WENT_WRONG)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Dismiss button")
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func refreshCommentTextField() {
        let cell = replyTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ReplyHeaderTableViewCell
        cell.editCommentTextField.text = ""
        //        cell.isEdit = !cell.isEdit
        if cell.editView.alpha == 1{
            cell.editViewHeightConstraint.constant = 30
            //            cell.commentLabel.alpha = 1
            cell.editView.alpha = 0
        } else{
            cell.editViewHeightConstraint.constant = 0
            //            cell.commentLabel.alpha = 0
            cell.editView.alpha = 1
        }
        replyTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
}

extension ReplyViewController: LoginViewDelegate {
    func loginSuccessful() {
        self.addReply(with: replyTextView.text!)
    }
}
