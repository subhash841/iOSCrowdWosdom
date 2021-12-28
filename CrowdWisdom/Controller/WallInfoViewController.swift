//
//  WallInfoViewController.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 12/4/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import UICircularProgressRing

protocol WallDelegate{
    func refreshCardCount(deleted: Bool, index: Int)
    func refreshVoteCount(index: Int, totalVotes: Int)
}

enum VoteType: String {
    case like = "like"
    case dislike = "dislike"
    case neutral = "neutral"
}

class WallInfoViewController: NavigationBaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var wallImageView: UIImageView!
    
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
    @IBOutlet weak var dislikeProgressView: UICircularProgressRing!
    @IBOutlet weak var neutralProgressView: UICircularProgressRing!
    
    @IBOutlet var progressViews: [UICircularProgressRing]!
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var shareImageView: UIImageView!
    
    @IBOutlet weak var neutralImageView: UIImageView!
    
    var commentsViewController : RevisedCommentsViewController!
    
    var wallDetails: WallDetails!
    var delegate: WallDelegate?

    var index = Int()
    var wallId = ""

    var voteType: VoteType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isHidden = true
        setProgressView()
        emptyStateAction = {
            self.callWallDetails()
        }
        shareImageView.image = shareImageView.image?.transform(withNewColor: UIColor.lightGray)
        shareImageView.transform = shareImageView.transform.rotated(by: CGFloat(Double.pi))
        neutralImageView.image = neutralImageView.image?.maskWithColor(color: BLUE_COLOR)

        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        commentsViewController = mainStoryboard.instantiateViewController(withIdentifier: "RevisedCommentsViewController") as? RevisedCommentsViewController
        
        setCommentsView()
        self.setupLeftBarButton(isback: true)
        callWallDetails()
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
        commentsViewController.refreshDataDelegate = self
        commentsViewController.type = CardType.discussion
    }
    
    func setProgressView() {
        
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
        
        wallImageView.kf.setImage(with: URL(string: wallDetails.data.image ?? ""), placeholder: UIImage(named: "placeholder"))
        wallImageView.contentMode = .scaleAspectFit
//        let tap = UITapGestureRecognizer(target: self, action: #selector(openImageView))
//        wallImageView.addGestureRecognizer(tap)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        wallImageView.isUserInteractionEnabled = true
        wallImageView.addGestureRecognizer(tapGestureRecognizer)

        titleLabel.isHidden = false
        titleLabel.text = (wallDetails.data.title ?? "").handleApostrophe()
        if let date = wallDetails.data.createdDate, let alias = wallDetails.data.alias, let raisedBy = wallDetails.data.raisedByAdmin {
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
        
        if let isUserlike = Int(wallDetails.data.isUserLike ?? "0"),
           let isUserDisLike = Int(wallDetails.data.isUserDislike ?? "0"),
           let isUserNeutral = Int(wallDetails.data.isUserNeutral ?? "0") {
            
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
        
        commentsViewController.commentId = wallDetails.data.id ?? ""
        let totalComment = Common.shared.getCommentIntValue(string: wallDetails.data.totalComments)
        commentButton.setTitle(totalComment > 1 ? "  \(totalComment) COMMENTS" : "  \(totalComment) COMMENT", for: .normal)
        commentsViewController.commentsArray = wallDetails.data.comments
        commentsViewController.isAvailable = wallDetails.data.moreComments ?? "0"
        commentsViewController.handleViewMoreButton()
        commentsViewController.commentsTableView.reloadData()
        Common.shared.assignColorToUser {
            userArray = Set(commentsViewController.commentsArray.compactMap{ $0.userID })

        }
        if let moreComments = wallDetails.data.moreComments, moreComments == "1"{
            commentsViewController.isAvailable = moreComments
            commentsViewController.viewMoreButton.isHidden = false
            commentsViewController.viewMoreButtonHeight.constant = 30
        }
        
        delegate?.refreshVoteCount(index: index, totalVotes: Common.shared.getCommentIntValue(string: wallDetails.data.totalLike) + Common.shared.getCommentIntValue(string: wallDetails.data.totalNeutral) + Common.shared.getCommentIntValue(string: wallDetails.data.totalDislike))
    }
    
    //MARK:- Button action
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
//        let storyboard = UIStoryboard(name: "Main", bundle: .main)
//        let termsVC = storyboard.instantiateViewController(withIdentifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
//        termsVC.str = wallDetails.data.image ?? ""
//        termsVC.type = getURL.ImageView
//        termsVC.isImageView = true
//        self.navigationController?.pushViewController(termsVC, animated: false)
        self.isImageViewLoad = true
        let imageVC = ImageViewController(nibName: "ImageViewController", bundle: nil)
        imageVC.imageURL = wallDetails.data.image ?? ""
        self.navigationController?.pushViewController(imageVC, animated: true)
    }
    @IBAction func commentButtonTapped(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "RevisedCommentsViewController") as! RevisedCommentsViewController
        vc.type = CardType.discussion
        vc.commentId = wallDetails.data.id ?? ""
        vc.isOnlyCommentsView = true
        vc.refreshDataDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        var shareLink = ""
        shareLink = Common.shared.shareURL(id: wallId, isVoice: 3)
        
        if let someText:String = wallDetails.data.title {
            let objectsToShare = URL(string:shareLink)
            let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
            let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        voteType = VoteType.like
        checkLogin()
    }
    
    @IBAction func dislikeButtonTapped(_ sender: Any) {
        voteType = VoteType.dislike
        checkLogin()
    }
    
    @IBAction func neutralButtonTapped(_ sender: Any) {
        voteType = VoteType.neutral
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

extension WallInfoViewController: UICircularProgressRingDelegate {
    
    func animateProgressView() {
        let likeCount = CGFloat(Int(wallDetails?.data.totalLike ?? "0") ?? 0)
        let dislikeCount = CGFloat(Int(wallDetails?.data.totalDislike ?? "0") ?? 0)
        let neutralCount = CGFloat(Int(wallDetails?.data.totalNeutral ?? "0") ?? 0)
        let totalCount = likeCount + dislikeCount + neutralCount
        
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

extension WallInfoViewController: RevisedCommentsViewDelegate {
    
    func updateViewFrame(height: CGFloat) {
        commentViewHeight.constant = height + 60
    }
    
    func updateComment(deleted: Bool) {
        delegate?.refreshCardCount(deleted: deleted, index: index)
        
        guard let totalCommentString = wallDetails.data.totalComments, var totalComment = Int(totalCommentString) else { return }
        if deleted {
            totalComment -= 1
        } else {
            totalComment += 1
        }
        wallDetails.data.totalComments = "\(totalComment)"
        commentButton.setTitle(totalComment > 1 ? "  \(totalComment) COMMENTS" : "  \(totalComment) COMMENT", for: .normal)

    }
    
}
extension WallInfoViewController {
    
    func callLikeUnlikeWebservice(voteType: VoteType){
        
        Common.shared.loadInfo()
        if NetworkStatus.shared.haveInternet(){
            
            Loader.showAdded(to: self.view, animated: true)
            
            let params = ["id":wallId,
                          "type":voteType.rawValue,
                          "user_id":USERID]
            
            Service.sharedInstance.request(api: API_DISSCUSSION_VOTE, type: .post, parameters: params as [String : Any], complete: { (response) in
                do {
                    let resp = try decoder.decode(StatusResponse.self, from: response as! Data)
                    //                    self.showAlert(message: resp.message ?? "")
                    self.callWallDetails()
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
    
    func callWallDetails(showLoader: Bool = true){
        
        let params = ["id" : wallId,
                      "user_id" : USERID]
        
        if NetworkStatus.shared.haveInternet(){
            if showLoader {Loader.showAdded(to: self.view, animated: true)}
            
            Service.sharedInstance.request(api: API_DISCUSSION_DETAIL, type: .post, parameters: params, complete: { (response) in
                
                do{
                    
                    self.wallDetails = try decoder.decode(WallDetails.self, from: response as! Data)
                    if self.wallDetails.status ?? false{
                        self.setDetails()
                    }
                    self.hideEmptyStateView()
                    self.scrollView.isHidden = false
                    
                } catch{
                    DLog(message: "\(error)")
                }
                Loader.hide(for: self.view, animated: true)
                
            }) { (error) in
                DLog(message: "\(error)")
            }
            
        } else{
            self.setNoConnectionState()
            DLog(message: "No internet.")
        }
    }
}

extension WallInfoViewController: RefreshDataDelegate {
    func refreshData() {
//        callWallDetails(showLoader: false)
    }
}

extension WallInfoViewController: LoginViewDelegate {
    func loginSuccessful() {
        if let type = voteType {
            callLikeUnlikeWebservice(voteType: type)
        }
    }
}
