//
//  NotificationViewController.swift
//  CrowdWisdom
//
//  Created by sunday on 12/31/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class NotificationViewController: NavigationBaseViewController {
    var offset = 0
    var notificationData = [NotificationData]()
    
    @IBOutlet weak var nodificationTableView: UITableView!
    
    struct menuImagesDrawer {
        let packagesIcon = "packges_Drawer"
        let predictionIcon = "card-prediction"
        let askQuestionsIcon = "card-ask-question"
        let yourVoiceIcon = "card-your-voice"
        let wallIcon = "card-discussion"
        let ratedArticleIcon = "card-rated-article"
    }
    
    enum NotificationType: String {
        case discussion = "Discussion"
        case prediction = "Prediction"
        case question = "Questions"
        case voice = "Voice"
        case web = "Web"
    }
    
    enum NotificationSubType: String {
        case comment = "Comment"
        case reply = "Reply"
        case add = "Add"
        case like = "Like"
        case dislike = "Dislike"
        case neutral = "Neutral"
        case vote = "Vote"
    }

    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

    lazy var hotTopicViewController = storyBoard.instantiateViewController(withIdentifier: "HotTopicViewController") as! HotTopicViewController

    var cardListViewController = CardMainViewViewController()
    lazy var cardDetailsViewController = storyBoard.instantiateViewController(withIdentifier: "CardDetailsViewController") as! CardDetailsViewController
    lazy var blogViewController = storyBoard.instantiateViewController(withIdentifier: "BlogViewController") as! BlogViewController
    lazy var playAndWinViewController = storyBoard.instantiateViewController(withIdentifier: "PlayAndWinViewController") as! PlayAndWinViewController
    lazy var gameDetailViewController = storyBoard.instantiateViewController(withIdentifier: "GameDetailViewController") as! GameDetailViewController


    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        nodificationTableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
        getNotificationListing()
        // Do any additional setup after loading the view.
    }

    func setUI() {
        self.setupLeftBarButton(isback: true)
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

extension NotificationViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        let dict = notificationData[indexPath.row]
        cell.notifiactionLabel.text = dict.title ?? ""
        let date = dict.createdDate ?? ""
        let dat = Common.shared.stringFromDateString(date: date, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "MMMM dd, yyyy HH:mm:ss", isUT: false)
        cell.dateTimeLabel.text = dat
        let type:String  = dict.type ?? ""
        if type == "Discussion" {
            cell.notificationTypeImage.image = UIImage(named: menuImagesDrawer().wallIcon)
        }else if type == "Prediction" {
            cell.notificationTypeImage?.image = UIImage(named: menuImagesDrawer().predictionIcon)
        }else if type == "Questions" {
            cell.notificationTypeImage.image = UIImage(named: menuImagesDrawer().askQuestionsIcon)
        }else if type == "Voice" {
            cell.notificationTypeImage.image = UIImage(named: menuImagesDrawer().yourVoiceIcon)
        }else if type == "Web" {
            cell.notificationTypeImage.image = UIImage(named: menuImagesDrawer().ratedArticleIcon)
        }
        return cell
    }
}

extension NotificationViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = notificationData[indexPath.row]
        print(dict)
        guard let type:String = dict.type , let id:String = dict.id , let notificationType = NotificationType(rawValue: type), let subType:String = dict.subtype , let notificationSubType = NotificationSubType(rawValue: subType) else { return }
            
            Common.shared.isFromNotification = false
            switch notificationType {
                
            case .discussion:
                switch notificationSubType {
                    
                case .comment:
                    openCommentsView(type: .discussion, id: id)
                case .reply:
                    if let commentId = dict.commentId {
                        if let alias = Common.shared.notificationCommentAlias,let comment:String = dict.text {
                            openReplyView(type: .discussion, postId: dict.postId ?? "", commentId: commentId, alias: alias, comment: comment)
                        }
                    }
                default:
                    let vc = WallInfoViewController(nibName: "WallInfoViewController", bundle: nil)
                    vc.wallId = id
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .prediction:
                switch notificationSubType {
                    
                case .comment:
                    openCommentsView(type: .prediction, id: id)
                case .reply:
                    if let commentId = dict.commentId {
                        if let alias = Common.shared.notificationCommentAlias,let comment:String = dict.text {
                            openReplyView(type: .prediction, postId: dict.postId ?? "", commentId: commentId, alias: alias, comment: comment)
                        }

                    }
                default:
                    cardDetailsViewController.type = .prediction
                    cardDetailsViewController.cardId = id
                    cardDetailsViewController.getCardDetail(with: cardDetailsViewController.type ?? .prediction)
                    self.navigationController?.pushViewController(cardDetailsViewController, animated: true)
                }
            case .question:
                switch notificationSubType {
                    
                case .comment:
                    openCommentsView(type: .askQuestion, id: id)
                case .reply:
                    if let commentId = dict.commentId {
                        if let alias = Common.shared.notificationCommentAlias,let comment:String = dict.text {
                            openReplyView(type: .askQuestion, postId: dict.postId ?? "", commentId: commentId, alias: alias, comment: comment)
                        }
                    }
                default:
                    cardDetailsViewController.type = .askQuestion
                    cardDetailsViewController.cardId = id
                    cardDetailsViewController.getCardDetail(with: cardDetailsViewController.type ?? .askQuestion)
                    self.navigationController?.pushViewController(cardDetailsViewController, animated: true)
                }
            case .voice:
                switch notificationSubType {
                    
                case .comment:
                    openCommentsView(type: .voice, id: id)
                case .reply:
                    if let commentId = dict.commentId {
                        if let alias = Common.shared.notificationCommentAlias,let comment = Common.shared.notificationComment {
                            openReplyView(type: .voice, postId: dict.postId ?? "", commentId: commentId, alias: alias, comment: comment)
                        }
                    }
                default:
                    blogViewController.blogId = id
                    blogViewController.getBlogDetails()
                    self.navigationController?.pushViewController(blogViewController, animated: true)
                }
            case .web:
                switch notificationSubType {
                    
                case .comment:
                    openCommentsView(type: .ratedArticle, id: id)
                case .reply:
                    if let commentId = dict.commentId {
                        if let alias = Common.shared.notificationCommentAlias,let comment:String = dict.text {
                            openReplyView(type: .ratedArticle, postId: dict.postId ?? "", commentId: commentId, alias: alias, comment: comment)
                        }
                    }
                default:
                    let ratedDetailsVC = RatedArticleDetailsViewController(nibName:"RatedArticleDetailsViewController", bundle: nil)
                    ratedDetailsVC.articleID = id
                    self.navigationController?.pushViewController(ratedDetailsVC, animated: true)
                }
            }
        
    }
    
    func openCommentsView(type: CardType, id: String) {
        let vc = storyBoard.instantiateViewController(withIdentifier: "RevisedCommentsViewController") as! RevisedCommentsViewController
        vc.type = type
        vc.commentId = id
        vc.isOnlyCommentsView = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openReplyView(type: CardType, postId: String, commentId: String, alias: String, comment: String) {
        let replyVC = storyBoard.instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController
        
        let commentData = CommentData(comment: comment, alias: alias, id: commentId)
        
        replyVC.id = commentId
        replyVC.voiceId = postId
        replyVC.type = type
        replyVC.comment = commentData
        replyVC.isOnlyCommentsView = false
        self.navigationController?.pushViewController(replyVC, animated: true)
    }
}

extension NotificationViewController {
    func getNotificationListing() {
        
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            let params = ["user_id":USERID,"offset":"\(offset)"]
            Service.sharedInstance.request(api: API_NOTIFICATION_LIST, type: .post, parameters: params, complete: { (response) in
                do {
                    let notification = try decoder.decode(NoticicationList.self, from: response as! Data)
                    self.notificationData += notification.notificationData ?? [NotificationData]()
                    if self.notificationData .isEmpty{
                        self.setNoDataState()
                    }
                    self.nodificationTableView.reloadData()
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
//            self.showAlert(message: NO_INTERNET)
            self.setNoConnectionState()
        }
    }
}

