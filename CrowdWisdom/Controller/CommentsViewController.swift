//
//  CommentsViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 09/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

protocol CommentsViewDelegate {
    func updateViewFrame(height: CGFloat)
}
class CommentsViewController: NavigationBaseViewController {
    
    @IBOutlet weak var newCommentTextView: UITextView!
    @IBOutlet weak var newCommentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var newCommentTextField: UITextField!
    @IBOutlet weak var newCommentTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commentScrollView: UIScrollView!
    @IBOutlet weak var newCommentView: UIView!
    
    var delegate: CommentsViewDelegate?
    
    var type: CardType?
    var id = Int()
    var isAvailable = "1"
    var offset = 0
    var commentsArray = [CommentData]()
    var replyArray = [Reply?]()
    
    var sectionArray = [Bool](repeating: false, count: 1)
    var randomColors = [UIColor]()
    
    lazy var noCommmentLabel: UILabel = {
        let label = UILabel()
        label.center = self.view.center
        label.text = "No comments are added."
        label.font = Common.shared.getFont(type: .medium, size: 16)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setUI()
        self.setupLeftBarButton(isback: true)
        newCommentTextView.text = "Enter your comment."
        newCommentTextView.textColor = UIColor.lightGray
        newCommentTextView.delegate = self
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        offset = 0
        getComments(with: id)
    }
    
    override func viewDidLayoutSubviews() {
        
        
        //        tableViewHeight.constant = newCommentTableView.contentSize.height
    }
    
    deinit {
        newCommentTableView.removeObserver(self, forKeyPath: "contentSize")
        newCommentTextView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    func setTableView(){
        newCommentTextView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        newCommentTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        newCommentTableView.register(UINib(nibName: "ReplyTableViewCell", bundle: nil), forCellReuseIdentifier: "replyCell")
        newCommentTableView.register(UINib(nibName: "CommentHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "commentHeader")
    }
    
    func setUI(){
        newCommentTextView.layer.borderWidth = 1
        newCommentTextView.layer.borderColor = UIColor.lightGray.cgColor
        newCommentTextView.layer.cornerRadius = newCommentTextView.frame.height / 2
        
        randomColors = sectionArray.compactMap{ _ in return UIColor.random() }
        
        sendButton.roundCorners([.bottomRight, .topRight], radius: sendButton.frame.height / 2)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if object as? UITextView == newCommentTextView {
            let tv:UITextView = object as! UITextView
            var topCorrect = (tv.bounds.size.height - tv.contentSize.height - tv.contentSize.height * tv.zoomScale)/2.0
            topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect )
            tv.contentOffset = CGPoint(x: 0, y: -topCorrect)
            if tv.contentSize.height < 120 {
                newCommentViewHeight.constant = tv.contentSize.height
                commentViewHeight.constant = tv.contentSize.height + 8
            } else {
                newCommentViewHeight.constant = 120
                commentViewHeight.constant = newCommentViewHeight.constant + 8
            }
            
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        } else {
            tableViewHeight.constant = newCommentTableView.contentSize.height
            newCommentTableView.layoutIfNeeded()
            delegate?.updateViewFrame(height: tableViewHeight.constant)
        }
    }
    
    func removeArrayData() {
        self.commentsArray = [CommentData]()
        self.replyArray = [Reply?](repeating: Reply(data: Data()), count: self.commentsArray.count)
        self.sectionArray = [Bool](repeating: false, count: self.commentsArray.count)
        self.randomColors = self.sectionArray.compactMap{ _ in return UIColor.random() }
    }
    
    @IBAction func addNewCommentTapped(_ sender: UIButton) {
        
        guard let commentText = newCommentTextView.text else { return }
        if commentText.isEmpty{
            self.showAlert(message:NO_VALID)
        } else {
            offset = 0
            removeArrayData()
            addNewComment(with: commentText)
        }
    }
    
}


extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: CommentHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "commentHeader") as! CommentHeaderView
        headerView.replyButton.addTarget(self, action: #selector(replyButtonTapped(at:)), for: .touchUpInside)
        headerView.replyButton.tag = section
        headerView.editButton.addTarget(self, action: #selector(commentEditTapped(at:)), for: .touchUpInside)
        headerView.editButton.tag = section
        headerView.userInitialBackgroundColor = randomColors[section]
        headerView.editedCommentSaveButton.addTarget(self, action: #selector(editedCommentSaveButtonAction(at:)), for: .touchUpInside)
        headerView.editedCommentSaveButton.tag = section
        headerView.newReplyButton.addTarget(self, action: #selector(newReplyButtonAction(at:)), for: .touchUpInside)
        headerView.newReplyButton.tag = section
        
        if sectionArray[section] {
            headerView.newReplyButton.isHidden = false
            headerView.replyStackHeight.constant = 30
        } else {
            headerView.newReplyButton.isHidden = true
            headerView.replyStackHeight.constant = 0
        }
        
        headerView.userNameLabel.text = commentsArray[section].alias
        headerView.commentLabel.text = commentsArray[section].comment
        headerView.numberOfRepliesLabel.text = "\(commentsArray[section].totalReplies) Replies"
        headerView.userInitialLabel.text = "\(commentsArray[section].alias?.first ?? "A")"
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //        guard let index = sectionArray[section] else { return 100 }
        if sectionArray[section] {
            return 150
        } else {
            return 100
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionArray[section] {
            guard let replyData = replyArray[section] else { return 0 }
            return replyData.data.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReplyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! ReplyTableViewCell
        cell.editButton.addTarget(self, action: #selector(editButtonTapped(at:)), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(at:)), for: .touchUpInside)
        cell.editReplySendButton.addTarget(self, action: #selector(editReplySendButtonAction(at:)), for: .touchUpInside)
        cell.firstTimeLoad = false
        
        guard let replyData = replyArray[indexPath.section] else { return cell }
        cell.replyLabel.text = replyData.data[indexPath.row].reply
        cell.userNameLabel.text = replyData.data[indexPath.row].alias
        cell.userInitialLabel.text = "\(replyData.data[indexPath.row].alias?.first ?? "U")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == commentsArray.count - 2 && isAvailable == "1" {
            
            getComments(with: id)
        }
    }
    
}

extension CommentsViewController {
    @objc func replyButtonTapped(at button: UIButton) {
        
        //TO DO:- Take Data from sections
        let section = button.tag
        if sectionArray[section]{
            self.sectionArray[section] = !self.sectionArray[section]
        } else {
            getRepliesOfComment(with: commentsArray[button.tag].id ?? "", index: button.tag)
        }
        //        let sectionView = newCommentTableView.headerView(forSection: section) as! CommentHeaderView
        //        print(sectionView.newReplyTextField.text)
        //        delegate?.updateViewFrame()
        
        //        newCommentTableView.updateHeight(heightConstraint: tableViewHeight)
        //        self.view.layoutSubviews()
        
    }
    
    @objc func commentEditTapped(at button: UIButton) {
        guard let headerView: CommentHeaderView = button.superview?.superview as? CommentHeaderView else { return }
        headerView.isEdit = !headerView.isEdit
        headerView.editedCommentTextField.text = headerView.commentLabel.text
    }
    
    @objc func editButtonTapped(at button: UIButton) {
        guard let cell = button.superview?.superview as? ReplyTableViewCell else { return }
//        cell.isEdit = !cell.isEdit
        cell.editReplyTextField.text = cell.replyLabel.text
        
    }
    
    @objc func deleteButtonTapped(at button: UIButton) {
        //        let buttonPosition = button.convert(button.bounds.origin, to: newCommentTableView)
        //        if let indexPath = newCommentTableView.indexPathForRow(at: buttonPosition) {
        //
        //
        //            newCommentTableView.reloadRows(at: [indexPath], with: .automatic)
        //        }
    }
    
    @objc func editReplySendButtonAction(at button: UIButton) {
        
        
    }
    
    @objc func editedCommentSaveButtonAction(at button: UIButton) {
        let index = button.tag
        let commentView = newCommentTableView.headerView(forSection: index) as! CommentHeaderView
        guard let editedComment = commentView.editedCommentTextField.text else { return }
        commentView.isEdit = !commentView.isEdit
        editComment(with: editedComment, commentID: commentsArray[index].commentID ?? "")
    }
    
    @objc func newReplyButtonAction(at button: UIButton) {
        let index = button.tag
        let commentView = newCommentTableView.headerView(forSection: index) as! CommentHeaderView
        guard let newReply = commentView.newReplyTextField.text else { return }
        addReply(with: newReply, commentID: commentsArray[index].commentID ?? "", index: index)
    }
    
    func handleNoCommentLabel() {
        if self.isAvailable == "0" && self.commentsArray.count == 0 {
            //            noCommmentLabel.tag = 999
            self.view.addSubview(noCommmentLabel)
        } else {
            noCommmentLabel.removeFromSuperview()
        }
    }
}
extension CommentsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
}
extension UITableView {
    func updateHeight(heightConstraint: NSLayoutConstraint) {
        heightConstraint.constant = self.contentSize.height
        
    }
}

//MARK:- API
extension CommentsViewController {
    //TODO:- Edit APIs
    func getComments(with id: Int) {
        
        var api = String()
        guard let typ = type else { return }
        switch typ {
        case .competition:
            api = API_ASKQUESTIONS_LIST
        case .prediction:
            api = API_PREDICTIONS_LIST_COMMENT
        case .askQuestion:
            api = API_ASKQUESTIONS_LIST
        case .voice:
            api = API_ASKQUESTIONS_LIST
        case .ratedArticle:
            api = API_RATEDARTICLE_LIST
        case .discussion:
            api = API_ASKQUESTIONS_LIST
        
        }
        if offset == 0 {
            removeArrayData()
        }
        if NetworkStatus.shared.haveInternet() {
            Service.sharedInstance.request(api: api, type: .post, parameters: ["id":id, "offset":offset], complete: { (response) in
                do {
                    let comment = try decoder.decode(Comment.self, from: response as! Data)
                    self.isAvailable = comment.isAvailable ?? "0"
                    self.commentsArray += comment.data ?? [CommentData]()
                    self.replyArray += [Reply?](repeating: Reply(data: Data()), count: self.commentsArray.count)
                    //                    self.replyArray = self.commentsArray.compactMap{ _ in return Reply() }
                    self.sectionArray += [Bool](repeating: false, count: self.commentsArray.count)
                    self.randomColors += self.sectionArray.compactMap{ _ in return UIColor.random() }
                    
                    self.newCommentTableView.reloadData()
                    self.newCommentTextView.text = ""
                    self.offset = self.commentsArray.count
                    
                    self.handleNoCommentLabel()
                } catch {
                    DLog(message: error)
                    self.showAlert(message: error.localizedDescription)
                }
            }) { (error) in
                DLog(message: error)
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func getRepliesOfComment(with commentID: String, index: Int) {
        var api = String()
        DLog(message: "offset: \(offset)")
        guard let typ = type else { return }
        
        switch typ {
        case .competition:
            api = API_VOICE_LIST
        case .prediction:
            api = API_PREDICTIONS_REPLY_OF_COMMENT
        case .askQuestion:
            api = API_ASKQUESTIONS_LIST
        case .voice:
            api = API_VOICE_LIST
        case .ratedArticle:
            api = API_RATEDARTICLE_LIST
        case .discussion:
            api = API_ASKQUESTIONS_LIST
        
        }
        
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            Service.sharedInstance.request(api: api, type: .post, parameters: ["offset":0, "id": id, "comment_id": commentID] as [String : Any], complete: { (response) in
                do {
                    let reply = try decoder.decode(Reply.self, from: response as! Data)
                    self.replyArray[index] = reply
                    self.sectionArray[index] = !self.sectionArray[index]
                    
                    self.newCommentTableView.reloadSections(IndexSet(integer: index), with: .automatic)
                    
                } catch {
                    DLog(message: error)
                    self.showAlert(message: "\(error)")
                }
                Loader.hide(for: self.view, animated: true)
            }) { (error) in
                DLog(message: error)
                self.showAlert(message: "\(error)")
                Loader.hide(for: self.view, animated: true)
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func addNewComment(with comment: String) {
        var api = String()
        api = API_PREDICTIONS_ADD_COMMENT
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            Service.sharedInstance.request(api: api, type: .post, parameters: ["id": id, "comment": comment, "user_id":USERID, "comment_id":0] as [String : Any], complete: { (response) in
                do {
                    let newComment = try decoder.decode(NewComment.self , from: response as! Data)
                    self.showAlert(message: newComment.message)
                    self.getComments(with: self.id)
                } catch {
                    DLog(message: error)
                    self.showAlert(message: error.localizedDescription)
                    
                    
                }
                Loader.hide(for: self.view, animated: true)
            }) { (error) in
                DLog(message: error)
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func editComment(with comment:String, commentID: String) {
        let api = API_PREDICTIONS_UPDATE_COMMENT
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            Service.sharedInstance.request(api: api, type: .post, parameters: ["id": id, "comment": comment, "user_id":USERID, "comment_id":commentID] as [String : Any], complete: { (response) in
                do {
                    let editComment = try decoder.decode(NewComment.self , from: response as! Data)
                    self.showAlert(message: editComment.message)
                    self.getComments(with: self.id)
                } catch {
                    DLog(message: error)
                    self.showAlert(message: error.localizedDescription)
                }
                Loader.hide(for: self.view, animated: true)
            }) { (error) in
                DLog(message: error)
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func deleteComment(with commentID: String) {
        let api = API_PREDICTIONS_DELETE_COMMENT
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            Service.sharedInstance.request(api: api, type: .post, parameters: ["id": id, "comment_id":commentID] as [String : Any], complete: { (response) in
                do {
                    
                } catch {
                    DLog(message: error)
                    self.showAlert(message: error.localizedDescription)
                }
                Loader.hide(for: self.view, animated: true)
            }) { (error) in
                DLog(message: error)
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func addReply(with reply: String, commentID: String, index: Int) {
        let api = API_PREDICTIONS_ADD_COMMENT_REPLY
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            Service.sharedInstance.request(api: api, type: .post, parameters: ["id": id, "comment_reply": reply, "comment_id":commentID, "user_id":USERID, "comment_reply_id":0] as [String : Any], complete: { (response) in
                do {
                    let newReply = try decoder.decode(NewReply.self, from: response as! Data)
                    self.showAlert(message: newReply.message)
                    self.getRepliesOfComment(with: newReply.data?.commentID ?? "", index: index)
                } catch {
                    DLog(message: error)
                    self.showAlert(message: error.localizedDescription)
                }
                Loader.hide(for: self.view, animated: true)
            }) { (error) in
                DLog(message: error)
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func editReply(with reply: String, replyID: String, commentID: String) {
        let api = API_PREDICTIONS_UPDATE_REPLY
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            Service.sharedInstance.request(api: api, type: .post, parameters: ["id": id, "comment_reply": reply, "comment_id":commentID, "comment_reply_id": replyID] as [String : Any], complete: { (response) in
                do {
                    
                } catch {
                    DLog(message: error)
                    self.showAlert(message: error.localizedDescription)
                }
                Loader.hide(for: self.view, animated: true)
            }) { (error) in
                DLog(message: error)
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func deleteReply(with replyID: String, commentID: String) {
        let api = API_PREDICTIONS_DELETE_REPLY
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            Service.sharedInstance.request(api: api, type: .post, parameters: ["id": id, "comment_reply_id":replyID , "comment_id":commentID] as [String : Any], complete: { (response) in
                do {
                    let status = try decoder.decode(StatusResponse.self, from: response as! Data)
                    self.showAlert(message: status.message ?? "Something went wrong.")
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
