//
//  RatedArticleDetailsViewController.swift
//  CrowdWisdom
//
//  Created by  user on 12/5/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import UICircularProgressRing

protocol RatedArticleDetailDelegate {
    func refreshVotesCount(index: Int, count: Int)
}

class RatedArticleDetailsViewController: NavigationBaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var articleImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dislikeLabel: UILabel!
    @IBOutlet weak var neutralLabel: UILabel!
    
    @IBOutlet weak var likePercentLabel: UILabel!
    @IBOutlet weak var dislikePercentLabel: UILabel!
    @IBOutlet weak var neutralPercentLabel: UILabel!
    
    @IBOutlet weak var likeProgressView: UICircularProgressRing!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dislikeProgressView: UICircularProgressRing!
    @IBOutlet weak var neutralProgressView: UICircularProgressRing!
    
    @IBOutlet var progressViews: [UICircularProgressRing]!
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareImageView: UIImageView!
    
    
    var commentsViewController : RevisedCommentsViewController!
    
    var articleDetails: RatedArticleDetails!
    var delegate: RatedArticleDetailDelegate?
    
    var index = Int()
    var articleID = ""
    
    var voteType: VoteType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isHidden = true
        setProgressView()
//        shareImageView.transform = .identity
//        shareImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//        shareImageView.image = shareImageView.image?.maskWithColor(color: UIColor.lightGray)
        shareButton.transform = .identity
        shareButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        shareButton.setImage(UIImage(named: "shareThreeDot")?.transform(withNewColor: UIColor.lightGray), for: .normal)

        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        commentsViewController = mainStoryboard.instantiateViewController(withIdentifier: "RevisedCommentsViewController") as? RevisedCommentsViewController
        
        setCommentsView()
        self.setupLeftBarButton(isback: true)
        callRatedArticlesDetails()
        self.addChild(commentsViewController)
        commentView.addSubview(commentsViewController.view)
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setCommentsView(){
        commentViewHeight.constant = commentsViewController.view.frame.height
        commentView.frame = commentsViewController.view.frame
        commentsViewController.delegate = self
        commentsViewController.type = CardType.ratedArticle
        commentsViewController.isOnlyCommentsView = false
    }
    
    func setProgressView() {
        likePercentLabel.textColor = GREEN_COLOR
        likeProgressView.delegate = self
        likeProgressView.shouldShowValueText = false
        likeProgressView.outerRingWidth = 1
        likeProgressView.outerRingColor = UIColor.lightGray
        likeProgressView.innerRingWidth = 3
        likeProgressView.startAngle = 90
        likeProgressView.isClockwise = true
        likeProgressView.maxValue = 100
        likeProgressView.minValue = 0
        
        likeProgressView.innerRingColor = GREEN_COLOR
        
        dislikePercentLabel.textColor = RED_COLOR
        dislikeProgressView.delegate = self
        dislikeProgressView.shouldShowValueText = false
        dislikeProgressView.outerRingWidth = 1
        dislikeProgressView.outerRingColor = UIColor.lightGray
        dislikeProgressView.innerRingWidth = 3
        dislikeProgressView.startAngle = 90
        dislikeProgressView.isClockwise = true
        dislikeProgressView.maxValue = 100
        dislikeProgressView.minValue = 0
        
        dislikeProgressView.innerRingColor = RED_COLOR
        
        neutralPercentLabel.textColor = BLUE_COLOR
        neutralProgressView.delegate = self
        neutralProgressView.shouldShowValueText = false
        neutralProgressView.outerRingWidth = 1
        neutralProgressView.outerRingColor = UIColor.lightGray
        neutralProgressView.innerRingWidth = 3
        neutralProgressView.startAngle = 90
        neutralProgressView.isClockwise = true
        neutralProgressView.maxValue = 100
        neutralProgressView.minValue = 0
        
        neutralProgressView.innerRingColor = BLUE_COLOR
        
    }
    
    func setDetails(){
        guard let articleData = articleDetails.data else { return }
        titleLabel.text = (articleData.title)?.handleApostrophe()
        descLabel.text = (articleData.description ?? "-").handleApostrophe()
        articleImageView.kf.setImage(with: URL(string: articleData.image ?? ""), placeholder: UIImage(named: "placeholder"))
        articleImageView.contentMode = .scaleAspectFit
        articleImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPreviewLink)))
        descLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPreviewLink)))

        titleLabel.isHidden = false
        
        if let date = articleData.createdDate, let alias = articleData.alias, let raisedBy = articleData.raisedByAdmin {
            let dat = Common.shared.stringFromDateString(date: date, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "MMMM dd, yyyy", isUT: false)

            if raisedBy == "1"{
                infoLabel.text = "By "
                infoLabel.addImage(imageName: "logo_red", afterLabel: true, afterText: "| \(dat)")
            } else {
                infoLabel.text = "By \(alias) | \(dat)"
            }
        }
        infoLabel.font = Common.shared.getFont(type: .medium, size: 12)
        infoLabel.textColor = UIColor.darkGray
        
        if !articleData.userActions.isEmpty, let isUserlike = Int(articleData.userActions[0].likes ?? "0"),
            let isUserDisLike = Int(articleData.userActions[0].dislikes ?? "0"),
            let isUserNeutral = Int(articleData.userActions[0].neutral ?? "0") {

            if isUserlike == 1 {
                likeLabel.textColor = GREEN_COLOR
                dislikeLabel.textColor = UIColor.darkGray
                neutralLabel.textColor = UIColor.darkGray
                animateProgressView()
            }

            if isUserDisLike == 1 {
                dislikeLabel.textColor = RED_COLOR
                likeLabel.textColor = UIColor.darkGray
                neutralLabel.textColor = UIColor.darkGray
                animateProgressView()

            }

            if isUserNeutral == 1 {
                neutralLabel.textColor = BLUE_COLOR
                dislikeLabel.textColor = UIColor.darkGray
                likeLabel.textColor = UIColor.darkGray
                animateProgressView()

            }
        }
        commentsViewController.commentId = articleData.id ?? ""
        let totalComment = Common.shared.getCommentIntValue(string: articleData.totalComments)
        commentButton.setTitle(totalComment > 1 ? "  \(totalComment) COMMENTS" : "  \(totalComment) COMMENT", for: .normal)

        commentsViewController.commentsArray = articleData.comments ?? [CommentData]()
        commentsViewController.isAvailable = articleData.moreComments ?? "0"
        commentsViewController.handleViewMoreButton()
        commentsViewController.commentsTableView.reloadData()
        Common.shared.assignColorToUser {
            userArray = Set(commentsViewController.commentsArray.compactMap{ $0.userID })

        }
        if articleData.moreComments == "1"{
            commentsViewController.isAvailable = "1"
            commentsViewController.viewMoreButton.isHidden = false
            commentsViewController.viewMoreButtonHeight.constant = 30
        }
        
        
    }
    
    //MARK:- Button action
    @objc func openPreviewLink() {
        if let articleData = articleDetails.data, let url = URL(string: articleData.data?.link ?? "") {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func descButtonTapped(_ sender: Any) {
        if let articleData = articleDetails.data, let url = URL(string: articleData.data?.link ?? "") {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func commentButtonTapped(_ sender: Any) {
        guard let articleData = articleDetails.data else { return }
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "RevisedCommentsViewController") as! RevisedCommentsViewController
        vc.type = CardType.ratedArticle
        vc.commentId = articleData.id ?? ""
        vc.isOnlyCommentsView = true
        vc.index = index
        vc.delegate = self
        vc.refreshDataDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func shareButtonTapped(_ sender: Any) {
        var shareLink = ""
        shareLink = Common.shared.shareURL(id: articleID, isVoice: 7)

        if let articleData = articleDetails.data, let someText:String = articleData.title {
//            let objectsToShare = URL(string:shareLink)
//            let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
//            let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
//            activityViewController.popoverPresentationController?.sourceView = self.view
//            self.present(activityViewController, animated: true, completion: nil)
            let objectsToShare = URL(string:shareLink)
            let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
            let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        voteType = .like
        checkLogin()
    }

    @IBAction func dislikeButtonTapped(_ sender: Any) {
        voteType = .dislike
        checkLogin()
    }

    @IBAction func neutralButtonTapped(_ sender: Any) {
        voteType = .neutral
        checkLogin()
    }
    
    func checkLogin() {
        if USERID == "0" {
            setLoginPage()
        } else {
            if let type = voteType {
                callLikeUnlikeWebservice(voteType: type)
            }
        }
    }
    
    func setLoginPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.isFromAction = true
        vc.delegate = self
        let nvc = UINavigationController(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
    }

}

//MARK:- Delegate - Circular Progress Ring

extension RatedArticleDetailsViewController: UICircularProgressRingDelegate {
    
    func animateProgressView() {
        guard let articleData = articleDetails.data else { return }
        let likeCount = CGFloat(Int(articleData.totalLike ?? "0") ?? 0)
        let dislikeCount = CGFloat(Int(articleData.totalDislike ?? "0") ?? 0)
        let neutralCount = CGFloat(Int(articleData.totalNeutral ?? "0") ?? 0)
        let totalCount = likeCount + dislikeCount + neutralCount
        delegate?.refreshVotesCount(index: index, count: Int(totalCount))
        let likePercent = round(likeCount/totalCount * 100)
        let dislikePercent = round(dislikeCount/totalCount * 100)
        let neutralPercent = round(neutralCount/totalCount * 100)
        
        likeProgressView.startProgress(to: likePercent, duration: 0.5) {
            self.dislikeProgressView.startProgress(to: dislikePercent, duration: 0.5, completion: {
                self.neutralProgressView.startProgress(to: neutralPercent, duration: 0.5, completion: nil)
            })
        }
        
    }
    
    func didUpdateProgressValue(for ring: UICircularProgressRing, to newValue: UICircularProgressRing.ProgressValue) {
        if ring == likeProgressView {
            likePercentLabel.text = "\(Int(newValue))%"
        } else if ring == dislikeProgressView {
            dislikePercentLabel.text = "\(Int(newValue))%"
        } else {
            neutralPercentLabel.text = "\(Int(newValue))%"
        }
    }
}

extension RatedArticleDetailsViewController: RevisedCommentsViewDelegate {

    func updateViewFrame(height: CGFloat) {
        commentViewHeight.constant = height + 60
    }

    func updateComment(deleted: Bool) {
//        delegate?.refreshCardCount(deleted: deleted, index: index)

        
        guard var articleData = articleDetails.data, let totalCommentString = articleData.totalComments, var totalComment = Int(totalCommentString) else { return }
        if deleted {
            totalComment -= 1
        } else {
            totalComment += 1
        }
        articleDetails.data?.totalComments = "\(totalComment)"
        commentButton.setTitle(totalComment > 1 ? "  \(totalComment) COMMENTS" : "  \(totalComment) COMMENT", for: .normal)

    }

}

extension RatedArticleDetailsViewController {
    
    func callLikeUnlikeWebservice(voteType: VoteType){

        Common.shared.loadInfo()
        if NetworkStatus.shared.haveInternet(){

            Loader.showAdded(to: self.view, animated: true)

            let params = ["id":articleID,
                          "type":voteType.rawValue,
                          "user_id":USERID]

            Service.sharedInstance.request(api: API_RATEDARTICLE_VOTE, type: .post, parameters: params as [String : Any], complete: { (response) in
                do {
                    let resp = try decoder.decode(StatusResponse.self, from: response as! Data)
                    //                    self.showAlert(message: resp.message ?? "")
                    self.callRatedArticlesDetails()
                    //                    self.showProgress = true

                } catch {
                    DLog(message: error)
                }
                Loader.hide(for: self.view, animated: true)
            }) { (error) in
                DLog(message: error)
                Loader.hide(for: self.view, animated: true)
            }
        } else{
            self.showAlert(message: NO_INTERNET)
            DLog(message: NO_INTERNET)
        }
    }
    
    func callRatedArticlesDetails(showLoader: Bool = true){
        
        let params = ["id" : articleID,
                      "user_id" : USERID]
        
        if NetworkStatus.shared.haveInternet(){
            if showLoader { Loader.showAdded(to: self.view, animated: true) }
            
            Service.sharedInstance.request(api: API_RATEDARTICLE_DETAIL, type: .post, parameters: params, complete: { (response) in
                
                do{
                    self.articleDetails = try decoder.decode(RatedArticleDetails.self, from: response as! Data)
                    
                    if self.articleDetails?.status ?? false {
                        self.setDetails()
                    }
                    self.hideEmptyStateView()
                    self.scrollView.isHidden = false
                    
                } catch{
                    self.setNoDataState()
                    DLog(message: "\(error)")
                }
                Loader.hide(for: self.view, animated: true)
                
            }) { (error) in
                DLog(message: "\(error)")
            }
            
        } else{
            DLog(message: "No internet.")
        }
    }
}

extension RatedArticleDetailsViewController: RefreshDataDelegate {
    func refreshData() {
        callRatedArticlesDetails(showLoader: false)
    }
}

extension RatedArticleDetailsViewController: LoginViewDelegate {
    func loginSuccessful() {
        if let type = voteType {
            callLikeUnlikeWebservice(voteType: type)
        }
    }
}
