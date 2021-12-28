//
//  RevisedCommentsViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 05/11/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import TransitionButton
import UITextView_Placeholder

@objc protocol RevisedCommentsViewDelegate {
    func updateViewFrame(height: CGFloat)
    @objc optional func updateComment(deleted: Bool)
}

protocol RefreshLabelCountDelegate {
    func refreshCommentLabel(index: Int, deleted: Bool)
}

protocol RefreshDataDelegate {
    func refreshData()
}

class RevisedCommentsViewController: NavigationBaseViewController {
    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentTextViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var commentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var viewMoreButton: TransitionButton!
    @IBOutlet weak var viewMoreButtonHeight: NSLayoutConstraint!
    
    var delegate: RevisedCommentsViewDelegate?
    var refreshCountLabelDelegate: RefreshLabelCountDelegate?
    
    var commentId = String()
    var isAvailable = String()
    var offset = 0
    var commentsArray = [CommentData]()
    var randomColors = [UIColor]()
    var isOnlyCommentsView = false
    var isAlreadyEmpty = false
    var type = CardType.prediction
    var showLoader = true
    var index = 0
    var refreshDataDelegate: RefreshDataDelegate?
    
    lazy var noCommmentLabel: UILabel = {
        let label = UILabel()
        label.center = self.view.center
        label.text = "No comments are added."
        label.font = Common.shared.getFont(type: .medium, size: 16)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emptyViewY = 0
        self.commentsTableView.contentInset = UIEdgeInsets.zero
        self.commentsTableView.tableFooterView = UIView()
        self.setupLeftBarButton(isback: true)
        self.emptyStateAction = {
            print("Retry Tapped")
            if self.isOnlyCommentsView { self.getComments(with: self.commentId) }
        }
        commentTextView.placeholder = "Write your comment here..."
        commentTextView.placeholderColor = UIColor.lightGray
        //        commentTextView.textColor = UIColor.lightGray
        commentTextView.delegate = self
        setUI()
        setObserver()
        commentsTableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentCell")
        if isOnlyCommentsView{
            offset = 0
            getComments(with: commentId)
            commentsTableView.isScrollEnabled = true
            viewMoreButton.isHidden = true
            viewMoreButtonHeight.constant = 0
            commentsTableView.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       handleViewMoreButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.commentTextView.resignFirstResponder()
        }
    }
    
    func setUI(){
        commentTextView.layer.borderWidth = 0.5
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        commentTextView.layer.cornerRadius = commentTextView.frame.height / 2
        
        randomColors = commentsArray.compactMap{ _ in return UIColor.random() }
        
        sendButton.roundCorners([.allCorners], radius: sendButton.frame.height / 2)
    }
    
    deinit {
        commentTextView.removeObserver(self, forKeyPath: "contentSize")
        commentsTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    func setObserver(){
        commentTextView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        commentsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if object as? UITextView == commentTextView {
            let tv:UITextView = object as! UITextView
            if let text = tv.text {
                if !text.isEmpty {
//                    var topCorrect = (tv.bounds.size.height - tv.contentSize.height - tv.contentSize.height * tv.zoomScale)/2.0
//                    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect )
//                    tv.contentOffset = CGPoint(x: 0, y: -topCorrect)
                    if tv.contentSize.height < 100 {
                        commentTextViewHeight.constant = tv.contentSize.height
                        commentViewHeight.constant = tv.contentSize.height + 8
                    } else {
                        commentViewHeight.constant = 100
                        commentViewHeight.constant = commentViewHeight.constant + 8
                    }
                } else {
                    //commentViewHeight.constant = 30
                }
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            tableViewHeight.constant = commentsTableView.contentSize.height
            commentsTableView.layoutIfNeeded()
            delegate?.updateViewFrame(height: tableViewHeight.constant + (viewMoreButton.isHidden == true ? 0 : 40))
        }
    }
    
    func removeArrayData() {
        self.commentsArray.removeAll()
        self.randomColors = self.commentsArray.compactMap{ _ in return UIColor.random() }
    }
    
    func handleViewMoreButton() {
        if !isOnlyCommentsView{
            if commentsArray.count < 2 {
                if isAvailable == "1" {
                    viewMoreButton.isHidden = false
                    viewMoreButtonHeight.constant = 30
                } else {
                    viewMoreButton.isHidden = true
                    viewMoreButtonHeight.constant = 0
                }
            } else {
                viewMoreButton.isHidden = false
                viewMoreButtonHeight.constant = 30
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                //                if NetworkStatus.shared.haveInternet() {
                //                    self.commentTextView.becomeFirstResponder()
                //                }
                self.viewMoreButton.isHidden = true
                self.viewMoreButtonHeight.constant = 0
            }
            
        }
    }
    
    func handleNoCommentLabel() {
        if self.isAvailable == "0" && self.commentsArray.count == 0 {
            //            noCommmentLabel.tag = 999
            self.view.addSubview(noCommmentLabel)
        } else {
            noCommmentLabel.removeFromSuperview()
        }
    }
    
    
    
    @IBAction func newCommentButtonTapped(_ sender: Any) {
        if commentTextView.validate() {
            commentTextView.resignFirstResponder()
            DLog(message: "Comment: \(commentTextView.text!)")
            if USERID == "0" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                vc.isFromAction = true
                vc.delegate = self
                let nvc = UINavigationController(rootViewController: vc)
                self.present(nvc, animated: true, completion: nil)
            } else {
                addNewComment(with: commentTextView.text!)
            }
        } else {
            self.showAlert(message: "Please enter comment")
        }
    }
    
    @IBAction func viewMoreCommentsTapped(_ sender: TransitionButton) {
        let commentsViewController = storyboard?.instantiateViewController(withIdentifier: "RevisedCommentsViewController") as! RevisedCommentsViewController
        commentsViewController.commentId = commentId
        commentsViewController.type = type
        commentsViewController.isOnlyCommentsView = true
        commentsViewController.refreshDataDelegate = self
//        commentsViewController.refreshCountLabelDelegate = self
        self.navigationController?.pushViewController(commentsViewController, animated: true)
        //        if NetworkStatus.shared.haveInternet() {
        //            if isAvailable == "1" {
        //                offset = commentsArray.count
        //                getComments(with: commentId)
        //            }
        //        } else {
        //            self.showAlert(message: NO_INTERNET)
        //        }
        
    }
    
    @objc func editSendTapped(_ sender: UIButton){
        
        let cell = commentsTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! CommentTableViewCell
        guard let comment = cell.editCommentTextField.text else {
            return
        }
        if comment.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            //            self.showAlert(message: "Please enter your comment.")
            self.showAlert(message: "Comment can't be empty.")
        } else{
            if NetworkStatus.shared.haveInternet() {
                cell.editCommentTextField.text = ""
                commentsArray[sender.tag].isEdit = !(commentsArray[sender.tag].isEdit ?? true)
                UIView.performWithoutAnimation {
                    commentsTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
                }
//                cell.isEdit = !cell.isEdit
                editComment(with: comment, commentID: commentsArray[sender.tag].id ?? "")
            } else {
                self.showAlert(message: NO_INTERNET)
            }
            
        }
    }
    
    @objc func replyButtonTapped(with sender: UIButton) {
        //send to reply view
        //        let dict = commentsArray[sender.tag]
        if NetworkStatus.shared.haveInternet() {
            let replyVC = storyboard?.instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController
            replyVC.id = commentsArray[sender.tag].id ?? ""
            replyVC.voiceId = commentId
            replyVC.type = type
            replyVC.comment = commentsArray[sender.tag]
            replyVC.isOnlyCommentsView = isOnlyCommentsView
            replyVC.refreshCommentDelegate = self
            self.navigationController?.pushViewController(replyVC, animated: true)
        } else {
            self.showAlert(message: NO_INTERNET)
        }
        
    }
    
    @objc func handleReplyTap(sender: UITapGestureRecognizer) {
        
        let touch = sender.location(in: commentsTableView)
        if let indexPath = commentsTableView.indexPathForRow(at: touch) {
            if NetworkStatus.shared.haveInternet() {
                let replyVC = storyboard?.instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController
                replyVC.id = commentsArray[indexPath.row].id ?? ""
                replyVC.voiceId = commentId
                replyVC.type = type
                replyVC.comment = commentsArray[indexPath.row]
                replyVC.isOnlyCommentsView = isOnlyCommentsView
                replyVC.refreshCommentDelegate = self
                self.navigationController?.pushViewController(replyVC, animated: true)
            } else {
                self.showAlert(message: NO_INTERNET)
            }
        }
    }
        
    @objc func deleteButtonTapped(with sender: UIButton) {
        if NetworkStatus.shared.haveInternet() {
            let alert = UIAlertController(title: "Delete Comment", message: "Are you sure, you want to delete this comment?", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
                print("User click Delete button")
                self.deleteComment(with: self.commentsArray[sender.tag].id ?? "0", index: sender.tag)
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                print("User click Dismiss button")
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    @objc func editCommentTapped(with sender: UIButton) {
        if NetworkStatus.shared.haveInternet() {
            let cell = commentsTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! CommentTableViewCell
            UIView.animate(withDuration: 0.3) {
                self.commentsArray[sender.tag].isEdit = !(self.commentsArray[sender.tag].isEdit ?? true)
                cell.editCommentTextField.text = cell.commentLabel.text
                UIView.performWithoutAnimation {
                    self.commentsTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
                }
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
        
    }
}

extension RevisedCommentsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        //        if textView.textColor == UIColor.lightGray {
        //            textView.text = nil
        //            textView.textColor = UIColor.black
        //        }
    }
}
//
//extension UITableView {
//    func updateHeight(heightConstraint: NSLayoutConstraint) {
//        heightConstraint.constant = self.contentSize.height
//
//    }
//}

extension RevisedCommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        cell.aliasLabel.text = commentsArray[indexPath.row].alias == "" ? commentsArray[indexPath.row].alise?.capitalizingFirstLetter() : commentsArray[indexPath.row].alias?.capitalizingFirstLetter()
        cell.commentLabel.text = commentsArray[indexPath.row].comment
        if let replyCount = Int(commentsArray[indexPath.row].totalReplies ?? "0") {
            if replyCount == 1 {
                cell.numberOfRepliesLabel.text = "1 Reply"
            } else if replyCount == 0 {
                cell.numberOfRepliesLabel.text = ""
            } else {
                cell.numberOfRepliesLabel.text = "\(replyCount) Replies"
            }
        }
        
        cell.editCommentTextField.delegate = self
        //        let repliesCount  = Int(commentsArray[indexPath.row].totalReplies ?? "0") ?? 0
        //
        //        if repliesCount > 0  {
        //            cell.numberOfRepliesLabel.text = "\(repliesCount) Replies"
        //        }
        
        cell.userInitialLabel.text = "\(cell.aliasLabel.text?.first ?? "U")"
        cell.userInitialBackgroundColor = colorDictionary[commentsArray[indexPath.row].userID ?? "nil"]
        
        if commentsArray[indexPath.row].userID == USERID{
            cell.editButto.isHidden = false
            cell.deleteButton.isHidden = false
            for view in cell.decorationViews{
                view.isHidden = false
                
            }
        } else{
            cell.editButto.isHidden = true
            cell.deleteButton.isHidden = true
            for view in cell.decorationViews{
                view.isHidden = true
                
            }
        }
        
        cell.replyButton.addTarget(self, action: #selector(replyButtonTapped(with:)), for: .touchUpInside)
        cell.editButto.addTarget(self, action: #selector(editCommentTapped(with:)), for: .touchUpInside)
        cell.editCommentSendButton.addTarget(self, action: #selector(editSendTapped(_:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(with:)), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleReplyTap(sender:)))
        cell.numberOfRepliesLabel.addGestureRecognizer(tap)
        cell.numberOfRepliesLabel.isUserInteractionEnabled = true
        (cell.replyButton.tag, cell.editButto.tag, cell.deleteButton.tag, cell.editCommentSendButton.tag ) = (indexPath.row, indexPath.row, indexPath.row, indexPath.row)
        
        //        UIView.animate(withDuration: 0.5) {
        //                self.editCommentTextField.text = ""
        if self.commentsArray[indexPath.row].isEdit ?? false {
            cell.deleteButton.isHidden = true
            cell.editCommentTextField.becomeFirstResponder()
            cell.commentLabel.alpha = 0.0
            cell.editView.alpha = 1.0
        } else {
            cell.deleteButton.isHidden = false
            cell.editCommentTextField.resignFirstResponder()
            cell.commentLabel.alpha = 1.0
            cell.editView.alpha = 0.0
            
        }
        
        cell.editCommentTextField.text = commentsArray[indexPath.row].comment
        
        if commentsArray[indexPath.row].userID == USERID{
            cell.editButto.isHidden = false
            cell.deleteButton.isHidden = false
            for view in cell.decorationViews{
                view.isHidden = false
                
            }
        } else{
            cell.editButto.isHidden = true
            cell.deleteButton.isHidden = true
            for view in cell.decorationViews{
                view.isHidden = true
                
            }
        }
        
        cell.editCancelButton.tag = indexPath.row
        
        cell.editCancelButton.addTarget(self, action: #selector(editCancelButton(_:)), for: .touchUpInside)
        //        }
        
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    @IBAction func editCancelButton(_ sender: UIButton) {
        commentsArray[sender.tag].isEdit = !(commentsArray[sender.tag].isEdit ?? true)
        UIView.performWithoutAnimation {
            commentsTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
        }
        
    }
    
}

extension RevisedCommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == commentsArray.count - 2 &&  isAvailable == "1" && isOnlyCommentsView{
            offset = commentsArray.count
            getComments(with: commentId)
            DLog(message: "Lazy loading: \(offset)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let replyVC = storyboard?.instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController
//        replyVC.id = commentsArray[indexPath.row].id ?? ""
//        replyVC.voiceId = commentId
//        replyVC.type = type
//        replyVC.comment = commentsArray[indexPath.row]
//        replyVC.isOnlyCommentsView = isOnlyCommentsView
//        replyVC.refreshCommentDelegate = self
//
//        self.navigationController?.pushViewController(replyVC, animated: true)
    }
}

//MARK:- API
extension RevisedCommentsViewController {
    //TODO:- Edit APIs
    func getComments(with id: String, scrollToTop: Bool = false) {
        
        var api = String()
        var id_key = String()
        //        api = API_VOICE_COMMENT
        //        guard let typ = type else { return }
        
        switch type {
        case .competition:
            api = API_VOICE_COMMENT
            id_key = "voice_id"
        case .prediction:
            api = API_PREDICTIONS_LIST_COMMENT
            id_key = "id"
        case .askQuestion:
            api = API_ASKQUESTIONS_COMMENT
            id_key = "id"
        case .voice:
            api = API_VOICE_COMMENT
            id_key = "voice_id"
        case .ratedArticle:
            api = API_RATEDARTICLE_COMMENT
            id_key = "id"
        case .discussion:
            api = API_DISSCUSSION_COMMENT
            id_key = "id"
        
        }
        DLog(message: "[id_key:\(id), offset:\(offset)], api: \(api)")
        if Int(offset) == 0 {
            removeArrayData()
        }
        
        if NetworkStatus.shared.haveInternet() {
            hideNoDataInfo()
            if isOnlyCommentsView && !self.commentTextView.isFirstResponder {
                Common.shared.showLoader(isEmpty: self.isEmptyState, view: self.view)
            } else {
                //viewMoreButton.startAnimation()
            }
            
            Service.sharedInstance.request(api: api, type: .post, parameters: [id_key:id, "offset":offset], complete: { (response) in
                do {
                    
                    let comment = try decoder.decode(Comment.self, from: response as! Data)
                    self.isAvailable = comment.isAvailable ?? "0"
                    self.commentsArray += comment.data ?? [CommentData]()
                    
                    //self.replyArray += [Reply?](repeating: Reply(data: Data()), count: self.commentsArray.count)
                    //                    self.replyArray = self.commentsArray.compactMap{ _ in return Reply() }
                    //self.sectionArray += [Bool](repeating: false, count: self.commentsArray.count)
                    self.randomColors += self.commentsArray.compactMap{ _ in return UIColor.random() }
                    Common.shared.assignColorToUser(completion: {
                        userArray = userArray.union(Set(self.commentsArray.compactMap{ $0.userID }))
                    })
                    
                    
                    self.commentsTableView.reloadData()
                    self.commentsTableView.isHidden = false
                    if scrollToTop { self.commentsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)}
                    self.commentTextView.text = ""
                    self.offset = self.commentsArray.count
                    
                    //                    if !self.isOnlyCommentsView {
                    //                        self.viewMoreButton.isHidden = comment.isAvailable == "0" ? true : false
                    //                        self.viewMoreButtonHeight.constant = comment.isAvailable == "0" ? 0 : 30
                    //                    }
                    if !self.isOnlyCommentsView{
                        if self.commentsArray.count <= 2 {
                            self.viewMoreButton.isHidden = true
                            self.viewMoreButtonHeight.constant = 0
                        } else {
                            self.viewMoreButton.isHidden = false
                            self.viewMoreButtonHeight.constant = 30
                        }
                    } else {
                        self.viewMoreButton.isHidden = true
                        self.viewMoreButtonHeight.constant = 0
                    }
                    
                    if self.commentsArray.isEmpty {
                        
                        if self.isOnlyCommentsView {
                            //                        self.commentsTableView.isHidden = true
                            
                            self.isEmptyState = true
                            self.emptyViewY = self.commentViewHeight.constant
//                            self.setNoCommentState()
//                            self.setNoDataState()
                            self.commentsTableView.isHidden = true
                            self.setNoDataInfo(with: CGRect(x: 0, y: Int(self.commentTextViewHeight.constant + 5), width: Device.SCREEN_WIDTH, height: Device.SCREEN_HEIGHT-200), image: "no-comment", text: "No Comments Available", sendToBack: true)
                            
                            if self.isAlreadyEmpty {
                                self.stopAnimationEmptyState()
                            }
                            self.isAlreadyEmpty = true
                        } else {
//                            self.viewMoreButton.isHidden = true
//                            self.viewMoreButtonHeight.constant = 0
                        }
                    }else {
                        self.commentsTableView.isHidden = false
//                        if !self.isOnlyCommentsView {
//                            self.viewMoreButton.isHidden = false
//                            self.viewMoreButtonHeight.constant = 30
//                        }
                        self.hideNoDataInfo()
                    }
                    
                    self.showLoader = false
                    Loader.hide(for: self.view, animated: true)
                } catch {
                    DLog(message: error)
                    self.showAlert(message: error.localizedDescription)
                    Loader.hide(for: self.view, animated: true)
                }
                //self.viewMoreButton.stopAnimation()
                
            }) { (error) in
                DLog(message: error)
                self.commentsTableView.isHidden = false
                //self.viewMoreButton.stopAnimation()
            }
        } else {
            self.setNoInternetInfo(with: self.view.frame, backgroungColor: .white)
            //self.showAlert(message: NO_INTERNET)
        }
    }
    
    func addNewComment(with comment: String) {
        var api = String()
        var id_key = String()
        switch type {
        case .competition:
            api = API_VOICE_ADDCOMMENT
            id_key = "voice_id"
        case .prediction:
            api = API_PREDICTIONS_ADD_COMMENT
            id_key = "id"
        case .askQuestion:
            api = API_ASKQUESTIONS_ADDCOMMENT
            id_key = "id"
        case .voice:
            api = API_VOICE_ADDCOMMENT
            id_key = "voice_id"
        case .ratedArticle:
            api = API_RATEDARTICLE_ADD_COMMENT
            id_key = "id"
            
        case .discussion:
            api = API_DISSCUSSION_ADDCOMMENT
            id_key = "id"
        
        }
        
        //        "id:180
        //        comment_id:0
        //        user_id:3420
        //        comment:this is second app comment"
        
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            
            let params = [id_key: commentId, "comment": comment, "user_id":USERID, "comment_id" : "0"]
            
            Service.sharedInstance.request(api: api, type: .post, parameters: params as [String : Any], complete: { (response) in
                do {
                    let newComment = try decoder.decode(NewVoiceComment.self , from: response as! Data)
                    //self.showAlert(message: "\(newComment.message ?? "")")
                    // notification center
                    NotificationCenter.default.post(name: Notification.Name(UpdateCommentNotification), object: nil)
                    self.offset = 0
                    self.getComments(with: self.commentId, scrollToTop: true)
                    self.delegate?.updateComment!(deleted: false)
                    self.refreshCountLabelDelegate?.refreshCommentLabel(index: self.index, deleted: false)
                    self.refreshDataDelegate?.refreshData()
                    self.commentViewHeight.constant = 35
                    self.view.endEditing(true)
                } catch {
                    DLog(message: error)
                    self.showAlert(message: SOMETHING_WENT_WRONG)
                }
                Loader.hide(for: self.view, animated: true)
            }) { (error) in
                self.showAlert(message: SOMETHING_WENT_WRONG)
                DLog(message: error)
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func deleteComment(with commentID: String, index: Int = 0) {
        var api = String()
        var idKey = String()
        switch type {
        case .competition:
            idKey = "voice_id"
            api = API_VOICE_DELETE_COMMENT
        case .prediction:
            api = API_PREDICTIONS_DELETE_COMMENT
            idKey = "id"
        case .askQuestion:
            api = API_ASKQUESTIONS_DELETE_COMMENT
            idKey = "id"
        case .voice:
            idKey = "voice_id"
            api = API_VOICE_DELETE_COMMENT
        case .ratedArticle:
            api = API_RATEDARTICLE_DELETE_COMMENT
            idKey = "id"
        case .discussion:
            api = API_DISSCUSSION_DELETE_COMMENT
            idKey = "id"
        
        }
        DLog(message: "[idKey: \(commentId), comment_id:\(commentID), user_id : 2]")
        //        "id:191
        //        user_id:5149
        //        comment_id:237"
        
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            Service.sharedInstance.request(api: api, type: .post, parameters: [idKey: commentId, "comment_id":commentID, "user_id" : USERID] as [String : Any], complete: { (response) in
                do {
                    let resp = try decoder.decode(NewVoiceComment.self, from: response as! Data)
                    
                    //self.showAlert(message: resp.message ?? "")
                    
                    self.offset = 0
                    // notification center
                    NotificationCenter.default.post(name: Notification.Name(UpdateCommentNotification), object: nil)
                    if self.isOnlyCommentsView {
                        self.getComments(with: self.commentId)
                    } else {
                        self.commentsArray.remove(at: index)
                        self.commentsTableView.reloadData()
                    }
                    self.refreshDataDelegate?.refreshData()
                    self.delegate?.updateComment!(deleted: true)
                    self.handleViewMoreButton()
                    self.refreshCountLabelDelegate?.refreshCommentLabel(index: self.index, deleted: true)

                } catch {
                    DLog(message: error)
                    self.showAlert(message: SOMETHING_WENT_WRONG)
//                    self.showAlert(message: error.localizedDescription)
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
    
    func editComment(with comment:String, commentID: String) {
        var api = String()
        var idKey = String()
        switch type {
        case .competition:
            api = API_VOICE_UPDATE_COMMENT
            idKey = "voice_id"
        case .prediction:
            api = API_PREDICTIONS_UPDATE_COMMENT
            idKey = "id"
        case .askQuestion:
            api = API_ASKQUESTIONS_UPDATE_COMMENT
            idKey = "id"
        case .voice:
            api = API_VOICE_UPDATE_COMMENT
            idKey = "voice_id"
        case .ratedArticle:
            api = API_RATEDARTICLE_UPDATE_COMMENT
            idKey = "id"
        case .discussion:
            api = API_DISSCUSSION_UPDATE_COMMENT
            idKey = "id"
        
        }
        
        
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            Service.sharedInstance.request(api: api, type: .post, parameters: [idKey: commentId, "comment": comment, "user_id":USERID, "comment_id":commentID] as [String : Any], complete: { (response) in
                do {
                    let editComment = try decoder.decode(NewComment.self , from: response as! Data)
                    //self.showAlert(message: editComment.message)
                    self.offset = 0
                    self.refreshDataDelegate?.refreshData()
                    self.getComments(with: self.commentId)
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
}

extension RevisedCommentsViewController: RefreshCommentsDelegate {
    func callService() {
        offset = 0
        getComments(with: commentId)
        if isOnlyCommentsView{
            commentsTableView.isScrollEnabled = true
            viewMoreButton.isHidden = true
            viewMoreButtonHeight.constant = 0
        } else {
            viewMoreButton.isHidden = false
            viewMoreButtonHeight.constant = 30
        }
    }
}

extension RevisedCommentsViewController: RefreshDataDelegate {
    func refreshData() {
        offset = 0
        getComments(with: commentId)
    }
}

extension RevisedCommentsViewController: LoginViewDelegate {
    func loginSuccessful() {
        addNewComment(with: commentTextView.text!)
    }
}
