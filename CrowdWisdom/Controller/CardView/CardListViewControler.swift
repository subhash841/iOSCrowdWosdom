//
//  CardListViewControler.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 10/8/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import Kingfisher

@objc protocol RefreshCardCountDelegate {
    func refreshCount(countString:NSAttributedString, listCount: Int, noInternet: Bool, error: Bool)
    @objc func toggleCountLabelVisibility()
    @objc optional func enableTabs(enable: Bool)
}



enum CardType: String {
    case prediction = "Prediction"
    case askQuestion = "Ask Question"
    case ratedArticle = "Rated Article"
    case discussion = "Discussion"
    case voice = "Voice"
    case competition = "Competition"
}

class CardListViewControler: CardStackViewController {
    
    lazy var type: CardType = CardType.prediction
    
    //    fileprivate var countOfCards: Int = 0
    var cardList = [String : Any]()
    var selectedId = ""
    var listData = [ListData]()
    var isDataAvailable = String()
    var newCommentsAdded = Int()
    var newLikeAdded = Int()
    var topCardIndex = Int()
    
    var cardRefreshDelegate: RefreshCardCountDelegate?
    lazy var predictionCommentViewController = storyboard?.instantiateViewController(withIdentifier: "PredictionCommentViewController") as! PredictionCommentViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set size of cards
        let size = CGSize(width: view.bounds.width - 3 * CardConstants.padding, height: CardConstants.kHeight * view.bounds.height)
        setCardSize(size)
        
        delegate = self
        datasource = self
        /*let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
         statusBar.isHidden = false*/
        
        //configuration of stacks
        layout.topStackMaximumSize = CardConstants.topStackVisibleCardCount
        layout.bottomStackMaximumSize = CardConstants.bottomStackVisibleCardCount
        layout.bottomStackCardHeight = CardConstants.bottomStackCardHeight
        layout.collectionView?.removeGestureRecognizer((layout.collectionView?.panGestureRecognizer)!)
        
        //        self.collectionView.addObserver(self, forKeyPath: "contentSize", options: [.old, .new], context: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DLog(message: type)
        //        if let typ = type {
        //            getListData(with: typ, offset: 0)
        //
        //        }
    }
    //method to add new card
    @IBAction func addNewCards(_ sender: AnyObject) {
        //        countOfCards += 1
        newCardAdded()
    }
    
    
    @IBAction func moveUP(_ sender: AnyObject) {
        moveCardUp()
    }
    
    @IBAction func moveCardDown(_ sender: AnyObject) {
        moveCardDown()
    }
    
    @IBAction func deleteAction(_ sender: AnyObject) {
        //        countOfCards -= 1
        deleteCard()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cardDetailsSegue"{
            if let destinationVc = segue.destination as? CardDetailsViewController{
                destinationVc.type = type
                destinationVc.refreshDelegate = self
                destinationVc.index = layout.index
                destinationVc.cardId = selectedId
            }
        }
    }
}

extension CardListViewControler : CardStackDatasource {
    func numberOfCards(in cardStack: CardStackView) -> Int {
        return listData.count
    }
    
    func card(_ cardStack: CardStackView, cardForItemAtIndex index: IndexPath) -> CardStackViewCell {
        let cell = cardStack.dequeueReusableCell(withReuseIdentifier: CardConstants.cellIndentifier, for: index) as! CardViewCell
        if let urlString = listData[index.row].image{
            cell.cardImageView.kf.indicatorType = .activity
//            cell.cardImageView.contentMode = .center
            cell.cardImageView.kf.setImage(with:  URL(string: urlString), placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: nil) { (image, error, cacheType, url) in
//                if image == nil{
//                    cell.cardImageView.contentMode = .center
//                } else{
//                    cell.cardImageView.contentMode = .scaleAspectFill
//                }
            }
            
            cell.cardImageView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            cell.cardImageView.layer.borderWidth = 1
        }
        
        let likeString = listData[index.row].total_likes == "0" || listData[index.row].total_likes == "1" ? "LIKE" : "LIKES"
        let ViewsString = listData[index.row].total_votes == "0" || listData[index.row].total_votes == "1" ? "VOTE" : "VOTES"
        

        if type == .ratedArticle {
            cell.cardQuestionLabel.text = ((listData[index.row].question ?? "").capitalizingFirstLetter()).handleApostrophe()
        }else if type == .competition {
            cell.cardQuestionLabel.text = ((listData[index.row].name ?? "").capitalizingFirstLetter()).handleApostrophe()
        }else
        {
            cell.cardQuestionLabel.text = ((listData[index.row].title ?? "").capitalizingFirstLetter()).handleApostrophe()
        }
        
        /*if let totalComment = Int(listData[index.row].total_comments ?? "0") {
            let commentString = totalComment == 0 || totalComment == 1  ? "COMMENT" : "COMMENTS"
            cell.commentCountLabel.text = "\(totalComment) \(commentString)"
        }*/
        
        if type == .voice{
            cell.voteNowButton.setTitle("READ NOW", for: .normal)
        } else if type == .prediction{
            cell.voteNowButton.setTitle("PREDICT NOW", for: .normal)
        }else if type == .competition{
            cell.voteNowButton.setTitle("PLAY NOW", for: .normal)
        } else if type == .discussion{
            cell.voteNowButton.setTitle("READ NOW", for: .normal)
        }else if type == .ratedArticle {
            cell.voteNowButton.setTitle("READ NOW", for: .normal)
        } else {
            cell.voteNowButton.setTitle("VOTE NOW", for: .normal)
        }
        cell.voteNowButton.isUserInteractionEnabled = false
        cell.shareButton.tag = index.item
        cell.shareButton.addTarget(self, action: #selector(shareButtonPressed(_:)), for: .touchUpInside)
        if index.row <= self.layout.index{
            cell.voteNowButton.isHidden = false
        } else{
            cell.voteNowButton.isHidden = true
        }
        
        if type == CardType.voice{
            let totalLikes = Common.shared.getCommentIntValue(string: listData[index.row].total_likes)
//            let totalViews = Common.shared.getCommentIntValue(string: listData[index.row].total_views)
            cell.commentCountLabel.text = "\(totalLikes)  \(totalLikes > 1 ? "LIKES": "LIKE")"
        } else if type == .discussion{
            let x = Int(listData[index.row].total_likes ?? "0") ?? 0
            let y = Int(listData[index.row].total_dislike ?? "0") ?? 0
            let z = Int(listData[index.row].total_neutral ?? "0") ?? 0
            
            let numberOfVotes = x + y + z
            
            cell.commentCountLabel.text = "\(numberOfVotes)  \(numberOfVotes > 1 ? "VOTES": "VOTE")"
        } else if type == .competition {
            cell.commentCountLabel.text = ""
            cell.votesUILabel.isHidden = true

        }else {
            cell.commentCountLabel.text = "\(listData[index.row].total_votes ?? "0")  \(ViewsString)"
        }
        cell.infoLabel.isHidden = true
        cell.voteNowButton.backgroundColor = BLUE_COLOR
        return cell
    }
    
    
    @objc func commentButtonAction(_ sender: UIButton) {
        //        predictionCommentViewController.id = sender.tag
        //        predictionCommentViewController.type = type
        let commentsViewController = storyboard?.instantiateViewController(withIdentifier: "RevisedCommentsViewController") as! RevisedCommentsViewController
        commentsViewController.commentId = "\(sender.tag)"
        commentsViewController.type = type
        commentsViewController.isOnlyCommentsView = true
        commentsViewController.refreshCountLabelDelegate = self
        commentsViewController.index = self.layout.index
        self.navigationController?.pushViewController(commentsViewController, animated: true)
        //        self.navigationController?.pushViewController(predictionCommentViewController, animated: true)
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton){
        let dict = listData[sender.tag]
        var shareLink = ""
        
        if let idTopic = dict.id {
            if type == .voice
            {
                shareLink = Common.shared.shareURL(id: idTopic, isVoice: 0)
            }else if type == .prediction
            {
                shareLink = Common.shared.shareURL(id: idTopic, isVoice: 1)
            }else if type == .discussion
            {
                shareLink = Common.shared.shareURL(id: idTopic, isVoice: 3)
            }else if type == .askQuestion
            {
                shareLink = Common.shared.shareURL(id: idTopic, isVoice: 4)
            } else if type == .ratedArticle {
                shareLink = Common.shared.shareURL(id: idTopic, isVoice: 7)
            } else if type == .competition {
                shareLink = Common.shared.shareURL(id: idTopic, isVoice: 5)

            }
            
            
            if let someText:String = dict.title ?? dict.question ?? dict.name {
                let objectsToShare = URL(string:shareLink)
                let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
                let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
                
            }
            
        }
        
        
        //        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter]
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        if let typ = type {
        if !NetworkStatus.shared.haveInternet() {
            self.showAlert(message: NO_INTERNET)
            return
        }
        switch type {
        case .competition:
            DLog(message: "Set Competition")
            let competitionVC = CompetitionInfoViewController.init(nibName: "CompetitionInfoViewController", bundle: nil)
            competitionVC.competitionID = listData[indexPath.row].id ?? ""
            self.navigationController?.pushViewController(competitionVC, animated: true)
        case .prediction:
            let selectedDict = listData[indexPath.row]
            selectedId = selectedDict.id ?? ""
            self.performSegue(withIdentifier: "cardDetailsSegue", sender: self)
        case .askQuestion:
            let selectedDict = listData[indexPath.row]
            selectedId = selectedDict.id ?? ""
            self.performSegue(withIdentifier: "cardDetailsSegue", sender: self)
            DLog(message: "Set Ask Question")
        case .voice:
            let blogViewController = storyboard?.instantiateViewController(withIdentifier: "BlogViewController") as! BlogViewController
            blogViewController.blogId = listData[indexPath.row].id ?? ""
            blogViewController.countDelegate = self
            self.navigationController?.pushViewController(blogViewController, animated: true)
            DLog(message: "Your Voice")
        case .ratedArticle:
            _ = listData[indexPath.row]
            let ratedDetailsVC = RatedArticleDetailsViewController(nibName:"RatedArticleDetailsViewController", bundle: nil)
            ratedDetailsVC.articleID = listData[indexPath.row].id ?? ""
            ratedDetailsVC.index = indexPath.row
            ratedDetailsVC.delegate = self
            self.navigationController?.pushViewController(ratedDetailsVC, animated: true)

            DLog(message: "Set Rated Article")
        case .discussion:
            DLog(message: "Set Discussion")
            let selectedDict = listData[indexPath.row]
            let wallInfoViewController = WallInfoViewController(nibName:"WallInfoViewController", bundle: nil)
            wallInfoViewController.wallId = selectedDict.id ?? ""
            wallInfoViewController.index = indexPath.row
            wallInfoViewController.delegate = self
            self.navigationController?.pushViewController(wallInfoViewController, animated: true)
        }
        Common.shared.cardTypeAtList = type
    }
}

extension CardListViewControler: CardStackDelegate {
    func cardDidChangeState(_ cardIndex: Int) {
        // Method to observe card postion changes
        print(cardIndex)
        topCardIndex = cardIndex
        if cardIndex >= 0 && cardIndex < listData.count {
            let cell = collectionView.cellForItem(at: IndexPath(item: cardIndex, section: 0)) as! CardViewCell
            cell.voteNowButton.isHidden = false
        }
        
        let indexString = "\(cardIndex + 1)"
        let indexStringAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black , NSAttributedString.Key.font: UIFont(name: "Roboto-Bold", size: 22.0)]
        let totalString = " / \(listData.count)"
        let totalStringAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont(name: "Roboto-Bold", size: 22.0)]
        
        let countAttributeString = NSMutableAttributedString(string: indexString, attributes: indexStringAttribute as [NSAttributedString.Key : Any])
        
        countAttributeString.append(NSAttributedString(string: totalString, attributes: totalStringAttribute as [NSAttributedString.Key : Any]))
        
        // set attributed text on a UILabel
        cardRefreshDelegate?.refreshCount(countString: countAttributeString, listCount: listData.count, noInternet: false,error: false)
        //        myLabel.attributedText = countAttributeString
        
        //        let nextCell = collectionView.cellForItem(at: IndexPath(item: cardIndex + 1, section: 0)) as! CardViewCell
        //        nextCell.voteNowButton.isHidden = true
        if cardIndex == listData.count - 2 && isDataAvailable == "1" {
            getListData(with: type, offset: listData.count)
            DLog(message: "lazy loading offset:- \(listData.count)")
        }
    }
    
    func cardWillChangeState(_ cardIndex: Int) {
        if cardIndex >= 0 && cardIndex < listData.count{
            if let cell = collectionView.cellForItem(at: IndexPath(item: cardIndex, section: 0)) as? CardViewCell{
                cell.voteNowButton.isHidden = true
            }
        }
    }
}
//MARK:- API
extension CardListViewControler {
    func getListData(with type: CardType , offset: Int) {
        self.cardRefreshDelegate?.enableTabs!(enable: false)
        newCommentsAdded = 0
        newLikeAdded = 0
        var api = String()
        switch type {
        case .competition:
            api = API_COMPETITION_LIST
        case .prediction:
            api = API_PREDICTIONS_LIST
        case .askQuestion:
            api = API_ASKQUESTIONS_LIST
        case .voice:
            api = API_VOICE_LIST
        case .ratedArticle:
            api = API_RATEDARTICLE_LIST
        case .discussion:
            api = API_DISCUSSION_LIST
        }
        
        if offset == 0{
            listData.removeAll()
            self.collectionView.reloadData()
            layout.index = 0
        }
        
        if NetworkStatus.shared.haveInternet() {
            //            self.cardRefreshDelegate?.toggleCountLabelVisibility()
            Loader.showAdded(to: self.view, animated: true)
            var params = [String : Any]()
            if type == .voice || type == .discussion || type == .ratedArticle{
                params = ["offset":offset, "notin":0,"user_id":USERID,"topic_id":"0"]
            }else if type == .competition {
                params = ["offset":offset, "user_id":USERID]
            }else {
                params = ["offset":offset]
            }
            Service.sharedInstance.request(api: api, type: .post, parameters: params, complete: { (response) in
                do {
                    let prediction = try decoder.decode(ListType.self, from: response as! Data)
                    self.isDataAvailable = prediction.is_available ?? ""
                    self.listData += prediction.data ?? [ListData]()
                    // self.countOfCards = self.listData.count
                    self.collectionView.reloadData()
                    if self.listData.count > 0{
                        let initialCount = NSMutableAttributedString(string: "\(self.layout.index + 1)", attributes: [ NSAttributedString.Key.foregroundColor: UIColor.black , NSAttributedString.Key.font: UIFont(name: "Roboto-Bold", size: 22.0)!])
                        initialCount.append(NSAttributedString(string: " / \(self.listData.count)", attributes: [ NSAttributedString.Key.foregroundColor: UIColor.lightGray , NSAttributedString.Key.font: UIFont(name: "Roboto-Bold", size: 22.0)!]))
                        self.cardRefreshDelegate?.refreshCount(countString: initialCount, listCount: self.listData.count, noInternet: false, error: false)
                        
                    } else{
                        self.cardRefreshDelegate?.refreshCount(countString: NSAttributedString(string: ""), listCount: self.listData.count, noInternet: false, error: false)
                    }
                } catch {
                    DLog(message: error)
                    self.showAlert(message: error.localizedDescription)
                    self.cardRefreshDelegate?.refreshCount(countString: NSAttributedString(string: ""), listCount: self.listData.count, noInternet: false, error: true)
                }
                Loader.hide(for: self.view, animated: true)
                self.cardRefreshDelegate?.enableTabs!(enable: true)
                
            }) { (error) in
                DLog(message: error)
                Loader.hide(for: self.view, animated: true)
                self.cardRefreshDelegate?.refreshCount(countString: NSAttributedString(string: ""), listCount: self.listData.count, noInternet: false, error: true)
                self.cardRefreshDelegate?.enableTabs!(enable: true)
            }
        } else {
            //self.showAlert(message: NO_INTERNET)
            self.cardRefreshDelegate?.refreshCount(countString: NSAttributedString(string: ""), listCount: self.listData.count, noInternet: true, error: false)
            self.cardRefreshDelegate?.enableTabs!(enable: true)
            
        }
    }
}


extension CardListViewControler: RefreshLabelCountDelegate {
    func refreshCommentLabel(index: Int, deleted: Bool) {
        guard let commentsCount = listData[index].total_comments , let comments = Int(commentsCount) else{
            return
        }
        if deleted{
            listData[index].total_comments = "\(comments - 1)"
        } else{
            listData[index].total_comments = "\(comments + 1)"
        }
        
        self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
}

extension CardListViewControler: BlogRefreshCountDelegate {
    func refreshCommentCount(commentCount: Int) {
//        newCommentsAdded = commentCount
//        let cell = self.layout.collectionView?.cellForItem(at: IndexPath(item: topCardIndex, section: 0)) as! CardViewCell
//        let commentString = newCommentsAdded == 0 || newCommentsAdded == 1 ? "Comment" : "Comments"
//
//        cell.commentCountLabel.text = "\(newCommentsAdded) \(commentString)"

    }
    
    func refreshLikeCount(likesCount: Int) {
        let cell = self.layout.collectionView?.cellForItem(at: IndexPath(item: topCardIndex, section: 0)) as! CardViewCell
        if type == CardType.voice{
            cell.commentCountLabel.text = "\(likesCount)  \(likesCount > 1 ? "LIKES": "LIKE")"
        } else{
            cell.commentCountLabel.text = "\(likesCount)  \(likesCount > 1 ? "VOTES": "VOTE")"
        }
    }
}

extension CardListViewControler: RefreshCounts{
    func refreshComments(index: Int, isDelete: Bool, section: Int) {
        guard let commentsCount = listData[index].total_comments , let comments = Int(commentsCount) else{
            return
        }
        if isDelete{
            listData[index].total_comments = "\(comments - 1)"
        } else{
            listData[index].total_comments = "\(comments + 1)"
        }
        self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
    
    func refreshVotes(index: Int, section: Int) {
        
        guard let votesCount = listData[index].total_votes , let votes = Int(votesCount) else{
            return
        }
        
        listData[index].total_votes = "\(votes + 1)"
        self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
}

extension CardListViewControler: WallDelegate{
    func refreshVoteCount(index: Int, totalVotes: Int) {
        let cell = self.layout.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as! CardViewCell
        cell.commentCountLabel.text = "\(totalVotes)  \(totalVotes > 1 ? "VOTES" : "VOTE")"

    }
    
    func refreshCardCount(deleted: Bool, index: Int) {
        guard let commentsCount = listData[index].total_comments , let comments = Int(commentsCount) else{
            return
        }
        if deleted{
            listData[index].total_comments = "\(comments - 1)"
        } else{
            listData[index].total_comments = "\(comments + 1)"
        }
        self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
}

extension CardListViewControler: RatedArticleDetailDelegate {
    func refreshVotesCount(index: Int, count: Int) {
        let cell = self.layout.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as! CardViewCell
        cell.commentCountLabel.text = "\(count)  \(count > 1 ? "VOTES" : "VOTE")"
    }
    
//    func refreshVoteCount(index: Int, count: Int) {
//    }
}
