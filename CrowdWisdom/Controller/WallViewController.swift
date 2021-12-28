//
//  WallDetailViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 30/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

//protocol WallDelegate{
//    func refreshCardCount(deleted: Bool, index: Int)
//}

class WallViewController: NavigationBaseViewController {
    
    @IBOutlet weak var wallImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var wallCollectionView: UICollectionView!
    
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commenLabel: UILabel!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var commentsViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var shareImageView: UIImageView!
    var wallDetails: WallDetails!
    var delegate: WallDelegate?
    
    var commentsViewController : RevisedCommentsViewController!
    
    var voteIndex = -1
    
    var showProgress = false {
        didSet {
            if showProgress {
                wallCollectionView.reloadData()
            }
        }
    }
    
    var wallId = ""
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isHidden = true
        shareImageView.image = shareImageView.image?.transform(withNewColor: UIColor.lightGray)
        shareImageView.transform = shareImageView.transform.rotated(by: CGFloat(Double.pi))
        wallCollectionView.register(UINib(nibName: "WallCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "wallCell")
        wallCollectionView.dataSource = self
        commentsViewController = storyboard?.instantiateViewController(withIdentifier: "RevisedCommentsViewController") as? RevisedCommentsViewController
        
        self.setupLeftBarButton(isback: true)
        callWallDetails()
        setCommentsView()
        self.addChild(commentsViewController)
        commentsView.addSubview(commentsViewController.view)
        self.view.layoutIfNeeded()

        // Do any additional setup after loading the view.
    }
    
    
    func setCommentsView(){
        commentsViewHeight.constant = commentsViewController.view.frame.height
        commentsView.frame = commentsViewController.view.frame
        commentsViewController.delegate = self
        commentsViewController.type = CardType.discussion
        
    }
    
    func setDetails(){
        

        wallImageView.kf.setImage(with: URL(string: wallDetails.data.image ?? ""), placeholder: UIImage(named: "placeholder"))
        titleLabel.isHidden = false
        titleLabel.text = wallDetails.data.title ?? ""
        if let date = wallDetails.data.createdDate, let alias = wallDetails.data.alias, let raisedBy = wallDetails.data.raisedByAdmin {
            let dat = Common.shared.stringFromDateString(date: date, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "MMMM dd, yyyy", isUT: false)
            
            if raisedBy == "1"{
                authorLabel.text = "By "
                authorLabel.addImage(imageName: "logo_red", afterLabel: true, afterText: "| \(dat)")
            } else {
                authorLabel.text = "By \(alias) | \(dat)"
            }
        }
        
        if let isUserlike = Int(wallDetails.data.isUserLike ?? "0"),
            let isUserDisLike = Int(wallDetails.data.isUserDislike ?? "0"),
            let isUserNeutral = Int(wallDetails.data.isUserNeutral ?? "0") {
            let list = [isUserlike, isUserDisLike, isUserNeutral]
            for index in 0..<list.count {
                if list[index] == 1 { voteIndex = index }
            }
        }
        commentsViewController.commentId = wallDetails.data.id ?? ""
        let totalComment = Common.shared.getCommentIntValue(string: wallDetails.data.totalComments)
        commentButton.setTitle(totalComment > 1 ? "  \(totalComment) COMMENTS" : "  \(totalComment) COMMENT", for: .normal)
        commenLabel.text = totalComment > 1 ? "\(totalComment) COMMENTS" : "\(totalComment) COMMENT"
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
        self.wallCollectionView.reloadData()
        
//        commentsViewController.commentsTableView.reloadData()

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
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RevisedCommentsViewController") as! RevisedCommentsViewController
        vc.type = CardType.discussion
        vc.commentId = wallDetails.data.id ?? ""
        vc.isOnlyCommentsView = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension WallViewController: RevisedCommentsViewDelegate {
    
    func updateViewFrame(height: CGFloat) {
        commentsViewHeight.constant = height + 60
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
        commenLabel.text = totalComment > 1 ? "\(totalComment) Comments" : "\(totalComment) Comment"
    }
    
}

extension WallViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wallCell", for: indexPath) as! WallCollectionViewCell
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(buttonTappedAtCell), for: .touchUpInside)
        
        let likeCount = CGFloat(Int(wallDetails?.data.totalLike ?? "0") ?? 0)
        let dislikeCount = CGFloat(Int(wallDetails?.data.totalDislike ?? "0") ?? 0)
        let neutralCount = CGFloat(Int(wallDetails?.data.totalNeutral ?? "0") ?? 0)
        let totalCount = likeCount + dislikeCount + neutralCount
        
        switch indexPath.row {
        case 0:
            cell.cellType = .like
            if totalCount == 0{
                cell.progress = 0
            } else{
                cell.progress = round(likeCount/totalCount * 100)
            }
        case 1:
            cell.cellType = .dislike
            if totalCount == 0{
                cell.progress = 0
            } else{
                cell.progress = round(dislikeCount/totalCount * 100)
            }
        case 2:
            cell.cellType = .neutral
            if totalCount == 0{
                cell.progress = 0
            } else{
                cell.progress = round(neutralCount/totalCount * 100)
            }
        default:
            DLog(message: "")
//            cell.cellType = .like
//            cell.progress = 0
        }
        if indexPath.row == voteIndex {
            cell.label.textColor = indexPath.row == 0 ? GREEN_COLOR : (indexPath.row == 1 ? RED_COLOR : BLUE_COLOR)
        } else {
            cell.label.textColor = UIColor.darkGray
        }
        if wallDetails != nil{
            DLog(message: "Wall Details not nil")
            if !(wallDetails.data.isUserLike?.toBool() ?? true) && !(wallDetails.data.isUserDislike?.toBool() ?? true) && !(wallDetails.data.isUserNeutral?.toBool() ?? true){
                cell.progressLabel.isHidden = true
                cell.progress = 0
            } else{
                DLog(message: "Wall Details nil")
                cell.progressLabel.isHidden = false
            }
        } else{
            cell.progress = 0
            cell.progressLabel.isHidden = false
        }
        cell.showProgress = true
        return cell
    }
    
}

extension WallViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let wallCell = cell as! WallCollectionViewCell
        wallCell.showProgress = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 80)
    }
}

extension WallViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalCellWidth = 80 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)
        
        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        
    }
}

extension WallViewController {
    @objc func buttonTappedAtCell(_ sender: UIButton) {
        let type = sender.tag == 0 ? VoteType.like : sender.tag == 1 ? VoteType.dislike : VoteType.neutral
        if voteIndex == -1 || voteIndex != sender.tag{
            voteIndex = sender.tag
            callLikeUnlikeWebservice(voteType: type)
        }
    }
    
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
            DLog(message: NO_INTERNET)
        }
    }
    
    func callWallDetails(){
        
        let params = ["id" : wallId,
                      "user_id" : USERID]
        
        if NetworkStatus.shared.haveInternet(){
            Loader.showAdded(to: self.view, animated: true)
            
            Service.sharedInstance.request(api: API_DISCUSSION_DETAIL, type: .post, parameters: params, complete: { (response) in
                
                do{
                    self.wallDetails = try decoder.decode(WallDetails.self, from: response as! Data)
                    if self.wallDetails.status ?? false{
                        self.setDetails()
                    }
                    self.scrollView.isHidden = false

                } catch{
                    DLog(message: "\(error)")
                }
                Loader.hide(for: self.view, animated: true)
                
            }) { (error) in
                DLog(message: "\(error)")
            }
            
        } else{
            self.setNoInternetInfo(with: self.view.frame, backgroungColor: .white)
            DLog(message: "No internet.")
        }
        
        
    }
    
}



