//
//  HomeViewController.swift
//  CrowdWisdom
//
//  Created by  user on 7/24/18.
//  Copyright © 2018 Nooralam Shaikh. All rights reserved.
//

import UIKit

enum HomeSectionType: Int {
    case popularPredictions = 0
    case trendingQuestions = 1
    case playAndWin = 2
    case yourVoice = 3
    case topRatedArticles = 4
    case topDiscussions = 5
    
}

enum HotTopicDetailSection: Int {
    
    case popularPredictions = 0
    case trendingQuestions = 1
    case yourVoice = 2
    case topRatedArticles = 3
    case topDiscussions = 4
    
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

class HomeViewController: NavigationSearchViewController {
    
    @IBOutlet weak var homeScrollView: UIScrollView!
    @IBOutlet weak var hotTopicView: UIView!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var hotTopicViewHeight: NSLayoutConstraint!
    
    lazy var hotTopicViewController = storyboard?.instantiateViewController(withIdentifier: "HotTopicViewController") as! HotTopicViewController
    
    var cardListViewController = CardMainViewViewController()
    
    lazy var cardDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "CardDetailsViewController") as! CardDetailsViewController
    lazy var blogViewController = storyboard?.instantiateViewController(withIdentifier: "BlogViewController") as! BlogViewController
    lazy var playAndWinViewController = storyboard?.instantiateViewController(withIdentifier: "PlayAndWinViewController") as! PlayAndWinViewController
    lazy var gameDetailViewController = storyboard?.instantiateViewController(withIdentifier: "GameDetailViewController") as! GameDetailViewController
    
    lazy var yourVoiceBackgroundImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.isHidden = true
        return imgView
    }()
    lazy var topRatedArticlesBackgroundImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.isHidden = true
        return imgView
    }()
    lazy var topArticleView: UIView = {
        let cell =  UINib(nibName: "BasicCollectionViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BasicCollectionViewCell
        cell.viewMoreButton.borderWidth = 1
        cell.viewMoreButton.borderColor = UIColor.white
        cell.viewMoreButton.cornerRadius = cell.viewMoreButton.frame.height / 2
        if isHotTopicDetailView { cell.topicNameLabel.text = self.hotTopicName }
        return cell.contentView
    }()
    
    private var predictionView: UIView?
    private var questionView: UIView?
    private var yourVoiceView: UIView?
    private var discussionView: UIView?
    
    var layout = JEKScrollableSectionCollectionViewLayout()
    var topRatedArticlesInsets = UIEdgeInsets()
    
    var isHotTopicDetailView = false
    var hotTopicName = String()
    
    private var topicList = [TopicListModel]()
    private var predictionList = [PredictionListModel]()
    private var questionList = [QuestionListModel]()
    private var playAndWinList = [PlayAndWinListModel]()
    private var yourVoiceList = [YourVoiceListModel]()
    private var ratedArticleList = [RatedArticleListModel]()
    private var discussionList = [DiscussionListModel]()
    
    var refresher = UIRefreshControl()
    var hotTopicHeight = CGFloat()
    var loadOneTime = false
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        updateDeviceAPNs()
        if Common.shared.isFromNotification { handleNotification() }
        if isHotTopicDetailView { hotTopicViewHeight.constant = 0 } else { setHotTopicView() }
        setCollectionViewLayout()
        setCollectionView()
        //setupCollectionViewBackgroundImage()
        homeCollectionView.isHidden = true
        
        // setup pull to refresh
        pullToRefreshSetUp()
        
        //get trending list
        getTrendingData(isShow: true)
        emptyStateAction = {
            self.getTrendingData(isShow: true)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getTrendingData(isShow: false)

        // seting the navigation bar
        addGradientTonavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func handleNotification() {
        guard let type = Common.shared.notificationType, let id = Common.shared.notificationPostId, let notificationType = NotificationType(rawValue: type), let subType = Common.shared.notificationSubType, let notificationSubType = NotificationSubType(rawValue: subType) else { return }
        
        Common.shared.isFromNotification = false
        switch notificationType {

        case .discussion:
            switch notificationSubType {
                
            case .comment:
                openCommentsView(type: .discussion, id: id)
            case .reply:
                if let commentId = Common.shared.notificationCommentId, let alias = Common.shared.notificationCommentAlias, let comment = Common.shared.notificationComment {
                    openReplyView(type: .discussion, postId: id, commentId: commentId, alias: alias, comment: comment)
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
                if let commentId = Common.shared.notificationCommentId, let alias = Common.shared.notificationCommentAlias, let comment = Common.shared.notificationComment {
                    openReplyView(type: .prediction, postId: id, commentId: commentId, alias: alias, comment: comment)
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
                if let commentId = Common.shared.notificationCommentId, let alias = Common.shared.notificationCommentAlias, let comment = Common.shared.notificationComment {
                    openReplyView(type: .askQuestion, postId: id, commentId: commentId, alias: alias, comment: comment)
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
                if let commentId = Common.shared.notificationCommentId, let alias = Common.shared.notificationCommentAlias, let comment = Common.shared.notificationComment {
                    openReplyView(type: .voice, postId: id, commentId: commentId, alias: alias, comment: comment)
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
                if let commentId = Common.shared.notificationCommentId, let alias = Common.shared.notificationCommentAlias, let comment = Common.shared.notificationComment {
                    openReplyView(type: .ratedArticle, postId: id, commentId: commentId, alias: alias, comment: comment)
                }
            default:
                let ratedDetailsVC = RatedArticleDetailsViewController(nibName:"RatedArticleDetailsViewController", bundle: nil)
                ratedDetailsVC.articleID = id
                self.navigationController?.pushViewController(ratedDetailsVC, animated: true)
            }
        }
    }
    
    func openCommentsView(type: CardType, id: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RevisedCommentsViewController") as! RevisedCommentsViewController
        vc.type = type
        vc.commentId = id
        vc.isOnlyCommentsView = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openReplyView(type: CardType, postId: String, commentId: String, alias: String, comment: String) {
        let replyVC = storyboard?.instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController
        
        let commentData = CommentData(comment: comment, alias: alias, id: commentId)
        
        replyVC.id = commentId
        replyVC.voiceId = postId
        replyVC.type = type
        replyVC.comment = commentData
        replyVC.isOnlyCommentsView = false
        self.navigationController?.pushViewController(replyVC, animated: true)
    }
    //MARK:-  Initial Setup
    
    private func pullToRefreshSetUp() {
        
        refresher.tintColor = BLUE_COLOR
        homeScrollView.addSubview(refresher)
        
        homeScrollView.isScrollEnabled = true
        homeScrollView.alwaysBounceVertical = true

        refresher.addTarget(self, action: #selector(refreshHomeData(_:)), for: .valueChanged)
    }
    
    private func setupCollectionViewBackgroundImage() {
        var height: CGFloat = 200
        if !isHotTopicDetailView {
            height = 400
            yourVoiceBackgroundImageView.frame = CGRect(x: 0, y: 100 + height + 25, width: UIScreen.main.bounds.width, height: 190)
            yourVoiceBackgroundImageView.isHidden = false
            yourVoiceBackgroundImageView.image = UIImage(named: "gradientCrowdwisdom")
            yourVoiceBackgroundImageView.layer.zPosition = -1
            self.homeCollectionView.addSubview(yourVoiceBackgroundImageView)
        }
        topRatedArticlesBackgroundImageView.frame = CGRect(x: 0, y: 100 + height + 25 + 450, width: UIScreen.main.bounds.width, height: 150)
        topRatedArticlesBackgroundImageView.isHidden = false
        topRatedArticlesBackgroundImageView.image = UIImage(named: "TopRatedArticlesGradient")
        topRatedArticlesBackgroundImageView.layer.zPosition = -2
        
        self.homeCollectionView.addSubview(topRatedArticlesBackgroundImageView)
        topArticleView.frame = CGRect(x: 0, y: 100 + height + 25 + 450, width: UIScreen.main.bounds.width / 2, height: 150)
        topArticleView.layer.zPosition = -1
        self.homeCollectionView.addSubview(topArticleView)
        
        topRatedArticlesInsets = UIEdgeInsets(top: 5, left: CGFloat(Device.SCREEN_WIDTH/2), bottom: 10, right: 5)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        collectionViewHeight.constant = homeCollectionView.contentSize.height
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
//        homeCollectionView.removeObserver(self, forKeyPath: "contentSize")
        
    }
    
    func setHotTopicView() {
        
        hotTopicViewController.view.frame = CGRect(x: 0, y: 0, width: hotTopicView.frame.width + 25, height: hotTopicView.frame.height)
        hotTopicViewController.type = .hotTopic
        hotTopicViewController.delegate = self
        self.addChild(hotTopicViewController)
        hotTopicView.addSubview(hotTopicViewController.view)//(, at: 0)
        hotTopicViewController.didMove(toParent: self)
        
        //        view.layoutSubviews()
    }
    
    func setCollectionView(){
        homeCollectionView.register(UINib(nibName: "NewPredictionCell", bundle: nil), forCellWithReuseIdentifier: "newPredictionCell")
        homeCollectionView.register(UINib(nibName: "TrendingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "trendingCell")
        homeCollectionView.register(UINib(nibName: "TopDiscussionCell", bundle: nil), forCellWithReuseIdentifier: "discussionCell")
        homeCollectionView.register(UINib(nibName: "PlayAndWinCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "playAndWinCell")
        homeCollectionView.register(UINib(nibName: "BasicCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "basicCell")
        homeCollectionView.register(UINib(nibName: "TopRatedArticlesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "articlesCell")
        
        homeCollectionView.register(UINib(nibName: "HomeHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "sectionView")
        
        homeCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView")
        
        homeCollectionView.register(UINib(nibName: "HomeBackgroundCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "JEKCollectionElementKindSectionBackground", withReuseIdentifier: "sectionBackgroundImageView")
        homeCollectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func setCollectionViewLayout() {
        layout = homeCollectionView.collectionViewLayout as! JEKScrollableSectionCollectionViewLayout
        layout.itemSize = CGSize(width: 300, height: 200)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        layout.footerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 15)
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.showsSectionBackgrounds = true
    }
    
    //MARK:- API Call
    @objc private func refreshHomeData(_ sender: Any) {
        // Fetch Weather Data
        print("refresh")
        hotTopicViewController.reloadTopicData()
        getTrendingData(isShow: false)

    }
    
    private func getTrendingData(isShow: Bool) {
        // first check net
        if NetworkStatus.shared.haveInternet() {
            let appVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
            print("version String:%@",appVersionString as Any)
            if isShow { Loader.showAdded(to: self.view, animated: true) }
            let params = ["user_id":USERID, "topic_id":"0","offset":"0","device_type":"Ios","app_version":appVersionString]
            print("Home param:\(params)")
            Service.sharedInstance.request(api: API_HOME_LIST, type: .post, parameters: params as [String : Any], complete: { (response) in
                do{
                    
                    let homeResponse = try decoder.decode(HomeModel.self, from: response as! Data)
                   if let code = homeResponse.versionCode , code == "401"
                   {
                        let alert1 = UIAlertController(title: "App Update", message: "Kindly update CrowdWisdom app for better experience and latest features.", preferredStyle: .alert)
                        let yesAction1 = UIAlertAction(title: "Go to App Store", style: .default) { (_) in
                            if let url = NSURL(string: "https://itunes.apple.com/in/app/crowdwisdom360-experts-app/id1446894568?mt=8"){
                                UIApplication.shared.openURL(url as URL)
                            }
                            self.present(alert1, animated: true, completion: nil)
                        }
                    alert1.addAction(yesAction1)
                    self.present(alert1, animated: true, completion: nil)
                   }else
                    {
                        if let data = homeResponse.data {
                            self.removeAllPreviousData()
                            
                            
                            self.topicList += data.topic_list ?? [TopicListModel]()
                            self.predictionList += data.prediction_list ?? [PredictionListModel]()
                            self.questionList += data.question_list ?? [QuestionListModel]()
                            self.playAndWinList += data.competetion_list ?? [PlayAndWinListModel]()
                            self.yourVoiceList += data.your_voice_list ?? [YourVoiceListModel]()
                            self.ratedArticleList += data.rated_article_list ?? [RatedArticleListModel]()
                            self.discussionList += data.discussion_list ?? [DiscussionListModel]()
                            self.populateData()
                            self.homeCollectionView.reloadData()
                            self.refresher.endRefreshing()
                        }
                        
                        self.emptyView.removeFromSuperview()
                        Loader.hide(for: self.view, animated: true)
                        self.homeCollectionView.isHidden = false
                    }
                }catch {
                    print(error)
                    Loader.hide(for: self.view, animated: true)
                }
                Loader.hide(for: self.view, animated: true)
            }) { (error) in
                Loader.hide(for: self.view, animated: true)
            }
        } else {
            setNoConnectionState()
        }
    }
    
    private func removeAllPreviousData() {
        self.topicList.removeAll()
        self.predictionList.removeAll()
        self.questionList.removeAll()
        self.playAndWinList.removeAll()
        self.yourVoiceList.removeAll()
        self.ratedArticleList.removeAll()
        self.discussionList.removeAll()
    }
    
    //MARK:- Button Actions
    @IBAction func playNowButtonAction (_ sender: UIButton){
        let competitionVC = CompetitionInfoViewController.init(nibName: "CompetitionInfoViewController", bundle: nil)
        competitionVC.competitionID = playAndWinList [sender.tag].id ?? "0"
        self.navigationController?.pushViewController(competitionVC, animated: true)
    }
    
    @IBAction func viewMoreButtonTapped(_ sender: UIButton) {
        cardListViewController = storyboard?.instantiateViewController(withIdentifier: "CardMainViewViewController") as! CardMainViewViewController
        if let sectionType = HomeSectionType(rawValue: sender.tag) {
            switch sectionType {
            case .popularPredictions:
                cardListViewController.type = CardType.prediction
                self.navigationController?.pushViewController(cardListViewController, animated: true)
            case .trendingQuestions:
                cardListViewController.type = CardType.askQuestion
                self.navigationController?.pushViewController(cardListViewController, animated: true)
            case .playAndWin:
                cardListViewController.type = CardType.competition
                self.navigationController?.pushViewController(cardListViewController, animated: true)
            case .yourVoice:
                cardListViewController.type = CardType.voice
                self.navigationController?.pushViewController(cardListViewController, animated: true)
            case .topRatedArticles:
                cardListViewController.type = CardType.ratedArticle
                self.navigationController?.pushViewController(cardListViewController, animated: true)
            case .topDiscussions:
                cardListViewController.type = CardType.discussion
                self.navigationController?.pushViewController(cardListViewController, animated: true)
                
            }
        }
    }
    
}

//MARK:- Collection View Delegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*if isHotTopicDetailView && section == 2{
         return 0
         }*/
        guard let section: HomeSectionType = HomeSectionType(rawValue: section) else { return 0 }
        switch section {
        case .popularPredictions:
            return predictionList.count
        case .playAndWin:
            return playAndWinList.count
        case .topDiscussions:
            return discussionList.count
        case .topRatedArticles:
            return ratedArticleList.count
        case .trendingQuestions:
            return questionList.count
        case .yourVoice:
            return yourVoiceList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section: HomeSectionType = HomeSectionType(rawValue: indexPath.section) else { return UICollectionViewCell() }
        switch section {
        case .popularPredictions:
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "newPredictionCell", for: indexPath) as! NewPredictionCell
            cell.makeAPredictionButton.isHidden = false
            cell.predictionDetailLabel.isHidden = false
            cell.makePredictionButtonHeightConstraints.constant = 24.0
            if predictionList.count > indexPath.row{
                let dict = predictionList[indexPath.row]
                cell.predictionImageView.kf.setImage(with: URL(string: dict.image ?? ""), placeholder: UIImage(named: "placeholder"))
                cell.predictionNameLabel.text = (dict.title ?? "").replacingOccurrences(of: "&#39;", with: "'")
                let vote_count = Int(dict.total_votes ?? "")
                let comment_count = Int(dict.total_comments ?? "")
                let voteLabel = vote_count ?? 0 <= 1 ? "VOTE" : "VOTES"
                let commentLabel = comment_count ?? 0 <= 1 ? "COMMENT" : "COMMENTS"
                cell.predictionDetailLabel.text = "\(dict.total_votes ?? "0") \(voteLabel)  ●  \(dict.total_comments ?? "0") \(commentLabel)"
            }
            return cell
        case .trendingQuestions:
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "newPredictionCell", for: indexPath) as! NewPredictionCell
            let dict = questionList[indexPath.row]
//            cell.questionInitialLabelBackgroundColor = UIColor.random()
            cell.predictionImageView.kf.setImage(with: URL(string: dict.image ?? ""), placeholder: UIImage(named: "placeholder"))
            cell.makePredictionButtonHeightConstraints.constant = 0.0
            cell.makeAPredictionButton.isHidden = true
            cell.predictionDetailLabel.isHidden = false
//            cell.isVoiceCell = false
//            cell.answerLabel.isHidden = true
//            cell.questionInitialLabel.isHidden = true
//            cell.tintImageView.isHidden = true
            
//            if let name = dict.alias {
//                cell.questionInitialLabel.text = "\(name.uppercased().first ?? "C")"
//                cell.questionInitialLabelBackgroundColor = UIColor.random()
//                cell.answerLabel.text = name
//            } else {
//                cell.questionInitialLabel.text = "C"
//                cell.questionInitialLabelBackgroundColor = UIColor.random()
//                cell.answerLabel.text = "Crowdwisdom"
//            }
            
            cell.predictionNameLabel.text = (dict.question ?? "").handleApostrophe()
            let vote_count = Int(dict.total_votes ?? "0")
            let comment_count = Int(dict.total_comments ?? "0")
            let voteLabel = vote_count ?? 0 <= 1 ? "VOTE" : "VOTES"
            let commentLabel = comment_count ?? 0 <= 1 ? "COMMENT" : "COMMENTS"
            cell.predictionDetailLabel.text = "\(dict.total_votes ?? "0") \(voteLabel)  ●  \(dict.total_comments ?? "0") \(commentLabel)"
            return cell
        case .playAndWin:
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "newPredictionCell", for: indexPath) as! NewPredictionCell
            cell.makeAPredictionButton.isHidden = false
            cell.makeAPredictionButton.setTitle("PLAY NOW", for: .normal)
            cell.makePredictionButtonHeightConstraints.constant = 24.0
            cell.predictionDetailLabel.isHidden = true
            if playAndWinList.count > indexPath.row {
                let dict = playAndWinList[indexPath.row]
                if let image = dict.image {
                    cell.predictionImageView.kf.setImage(with: URL(string: image), placeholder: UIImage(named: "placeholder"))
                } else {
                    cell.predictionImageView.image = UIImage(named: "placeholder")
                }
                cell.predictionNameLabel.text = dict.name ?? ""
//                cell.gameNameLabel.font = Common.shared.getFont(type: .medium, size: 14)
//                cell.gameNameLabel.textColor = UIColor.black
                
            }
            cell.makeAPredictionButton.addTarget(self, action: #selector(playNowButtonAction(_:)), for: .touchUpInside)
            cell.makeAPredictionButton.tag = indexPath.row
            return cell
        case .yourVoice:
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "newPredictionCell", for: indexPath) as! NewPredictionCell
            cell.makePredictionButtonHeightConstraints.constant = 0.0
            cell.makeAPredictionButton.isHidden = true
            cell.predictionDetailLabel.isHidden = false

//            cell.isVoiceCell = true
//            cell.questionInitialLabelBackgroundColor = UIColor.random()
            let dict = yourVoiceList[indexPath.row]
            if let image = dict.image, let comments = dict.total_comments, let likes = dict.total_likes, let type = dict.type{
                cell.predictionImageView.kf.setImage(with: URL(string: image), placeholder: UIImage(named: "placeholder"))
//                cell.answerLabel.isHidden = true
//                cell.questionInitialLabel.isHidden = true
//                cell.tintImageView.isHidden = true

//                cell.answerLabel.text = dict.alias ?? "Crowdwisdom"
                cell.predictionNameLabel.text = (dict.title ?? "").handleApostrophe()
//                cell.typeLabel.text = type
//                cell.isVoiceCell = false

//                if let name = dict.alias {
//                    cell.questionInitialLabel.text = "\(name.uppercased().first ?? "C")"
//                    cell.questionInitialLabelBackgroundColor = UIColor.random()
//                } else {
//                    cell.questionInitialLabel.text = "C"
//                    cell.questionInitialLabelBackgroundColor = UIColor.random()
//                }
                
                let like_count = Int(likes)
//                let comment_count = Int(comments)
                let likeLabel = like_count ?? 0 <= 1 ? "LIKE" : "LIKES"
                let totalViews = Common.shared.getCommentIntValue(string: dict.total_views)
//                let commentLabel = comment_count ?? 0 <= 1 ? "COMMENT" : "COMMENTS"
                cell.predictionDetailLabel.text = "\(totalViews) \(totalViews > 1 ? "VIEWS":"VIEW")  ●  \(likes) \(likeLabel)" //● \(comments) \(commentLabel)"
            }
            
            
            return cell
        case .topRatedArticles:
//            if indexPath.row == 0 {
//                let cell =  homeCollectionView.dequeueReusableCell(withReuseIdentifier: "basicCell", for: indexPath) as! BasicCollectionViewCell
//                cell.viewMoreButton.borderWidth = 1
//                cell.viewMoreButton.borderColor = UIColor.white
//                cell.viewMoreButton.cornerRadius = cell.viewMoreButton.frame.height / 2
//                cell.viewMoreButton.tag = indexPath.section
//                cell.viewMoreButton.addTarget(self, action: #selector(viewMoreButtonTapped(_:)), for: .touchUpInside)
//                return cell
//
//            } else {
                let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "articlesCell", for: indexPath) as! TopRatedArticlesCollectionViewCell
                if let url = URL(string: ratedArticleList[indexPath.row].image ?? "") {
                    cell.articleImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
                }
                cell.articleTitleLable.text = (ratedArticleList[indexPath.row].question ?? "").handleApostrophe()
                
                let totalVotes = Common.shared.getCommentIntValue(string: ratedArticleList[indexPath.row].total_like) + Common.shared.getCommentIntValue(string: ratedArticleList[indexPath.row].total_neutral) + Common.shared.getCommentIntValue(string: ratedArticleList[indexPath.row].total_dislike)
                cell.voteLabel.text = "\(totalVotes) \(totalVotes > 1 ? "VOTES" : "VOTE")"
                return cell

//            }
        case .topDiscussions:
            let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "newPredictionCell", for: indexPath) as! NewPredictionCell
            cell.makePredictionButtonHeightConstraints.constant = 0.0
            cell.makeAPredictionButton.isHidden = true
            cell.predictionDetailLabel.isHidden = false
            let dict = discussionList[indexPath.row]
            if let image = dict.image, let title = dict.title, let neutral = dict.total_neutral, let likes = dict.total_like, let dislike = dict.total_dislike  {
//                cell.answerLabel.isHidden = true
//                cell.questionInitialLabel.isHidden = true
//                cell.tintImageView.isHidden = true
//                cell.answerLabel.text = dict.alias ?? "Crowdwisdom"
                cell.predictionNameLabel.text = title.handleApostrophe()
                cell.predictionImageView.kf.setImage(with: URL(string: image))
//                cell.isVoiceCell = true
//                cell.typeLabel.text = ""
//                if let name = dict.alias {
//                    cell.questionInitialLabel.text = "\(name.uppercased().first ?? "C")"
//                    cell.questionInitialLabelBackgroundColor = UIColor.random()
//                } else {
//                    cell.questionInitialLabel.text = "C"
//                    cell.questionInitialLabelBackgroundColor = UIColor.random()
//                }
                
                let like_count = Int(likes) ?? 0
                let neutralCount = Int(neutral) ?? 0
                let disLikeCount = Int(dislike) ?? 0
//                let likeLabel = like_count ?? 0 <= 1 ? "LIKE" : "LIKES"
//                let neutralLabel = neutralCount ?? 0 <= 1 ? "NEUTRAL" : "NEUTRALS"
//                let dislikeLabel = disLikeCount ?? 0 <= 1 ? "DISLIKE" : "DISLIKES"
                let totalVotes =  like_count + neutralCount + disLikeCount
                let likeLabel = totalVotes <= 1 ? "VOTE" : "VOTES"

                cell.predictionDetailLabel.text = "\(totalVotes) \(likeLabel)"
                
                cell.predictionImageView.cornerRadius = 5
                cell.predictionImageView.borderColor = .gray
                cell.predictionImageView.borderWidth = 0.0
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let section: HomeSectionType = HomeSectionType(rawValue: indexPath.section) else { return }
        switch section {
        case .playAndWin:
            let competitionVC = CompetitionInfoViewController.init(nibName: "CompetitionInfoViewController", bundle: nil)
            competitionVC.competitionID = playAndWinList[indexPath.row].id ?? ""
            self.navigationController?.pushViewController(competitionVC, animated: true)
            //self.navigationController?.pushViewController(gameDetailViewController, animated: true)
        case .popularPredictions:
            let cardDetailsVC = storyboard?.instantiateViewController(withIdentifier: "CardDetailsViewController") as! CardDetailsViewController
            cardDetailsVC.type = CardType.prediction
            let dict = predictionList[indexPath.row]
            cardDetailsVC.type = .prediction
            cardDetailsVC.cardId = dict.id ?? "0"
            cardDetailsVC.getCardDetail(with: cardDetailsVC.type ?? .prediction)
            cardDetailsVC.isFromCardList = false
            self.navigationController?.pushViewController(cardDetailsVC, animated: true)
        case .trendingQuestions:
            let cardDetailsVC = storyboard?.instantiateViewController(withIdentifier: "CardDetailsViewController") as! CardDetailsViewController
            let dict = questionList[indexPath.row]
            cardDetailsVC.type = CardType.askQuestion
            cardDetailsVC.cardId = dict.id ?? "0"
            cardDetailsVC.isFromCardList = false
            cardDetailsVC.getCardDetail(with: cardDetailsVC.type ?? .askQuestion)
            self.navigationController?.pushViewController(cardDetailsVC, animated: true)
        case .yourVoice:
            let blogViewController1 = storyboard?.instantiateViewController(withIdentifier: "BlogViewController") as! BlogViewController
            let dict = yourVoiceList[indexPath.row]
            blogViewController1.blogId = dict.id ?? "0"
            blogViewController1.getBlogDetails()
            self.navigationController?.pushViewController(blogViewController1, animated: true)
        case .topRatedArticles:
//            if indexPath.row == 0 { return }
            let ratedDetailsVC = RatedArticleDetailsViewController(nibName:"RatedArticleDetailsViewController", bundle: nil)
            ratedDetailsVC.articleID = ratedArticleList[indexPath.row].id ?? ""
            self.navigationController?.pushViewController(ratedDetailsVC, animated: true)
        case .topDiscussions:
            
            cardDetailsViewController.type = CardType.discussion
//            let wallViewController = storyboard?.instantiateViewController(withIdentifier: "WallViewController") as! WallViewController
//            wallViewController.wallId = discussionList[indexPath.row].id ?? ""
//            self.navigationController?.pushViewController(wallViewController, animated: true)

            let wallInfoViewController = WallInfoViewController(nibName:"WallInfoViewController", bundle: nil)
            wallInfoViewController.wallId = discussionList[indexPath.row].id ?? ""
            self.navigationController?.pushViewController(wallInfoViewController, animated: true)
        }
    }
    
    //TODO:- set Collection View Cells UI

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = HomeSectionType(rawValue: indexPath.section) else { return CGSize(width: UIScreen.main.bounds.width - 40, height: 200) }
        switch section {
        case .popularPredictions:
            if predictionList.count > 0 {
                return CGSize(width: UIScreen.main.bounds.width - 30, height: 350 )
            } else {
                return CGSize(width: 0, height: 0)
            }
        case .trendingQuestions:
            if questionList.count > 0 {
                return CGSize(width: UIScreen.main.bounds.width - 70, height: 320)
            } else {
                return CGSize(width: 0, height: 0)
            }
        case .playAndWin:
            if playAndWinList.count > 0 {
                return CGSize(width: UIScreen.main.bounds.width - 30, height: 320)
            } else {
                return CGSize(width: 0, height: 0)
            }
        case .yourVoice:
            if yourVoiceList.count > 0 {
                return CGSize(width: UIScreen.main.bounds.width - 30, height: 320)
            } else {
                return CGSize(width: 0, height: 0)
            }
        case .topRatedArticles:
            if ratedArticleList.count > 0 {
//                return CGSize(width: UIScreen.main.bounds.width - 30, height: 320)
//                if indexPath.row == 0 {
//                  return CGSize(width: 130, height: 164)
//                }
                return CGSize(width: UIScreen.main.bounds.width - 30, height: 190)
            } else {
                return CGSize(width: 0, height: 0)
            }
        case .topDiscussions:
            if discussionList.count > 0 {
                return CGSize(width: UIScreen.main.bounds.width - 30, height: 320)
            } else {
                return CGSize(width: 0 , height: 0)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let sectionView = homeCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionView", for: indexPath) as! HomeHeaderCollectionReusableView
            
            let boldSectionNames = ["Predictions", "Questions", "Competition", "Voice", "", "Discussions"]
            let defaultSectionNames = isHotTopicDetailView ? boldSectionNames.compactMap{ return hotTopicName + " " + $0 } : ["Popular Predictions","Trending Questions","Competition","Your Voice","","Top Discussions"]
            if let index = indexPath.first {
                sectionView.viewMoreButton.tag = index
                sectionView.viewMoreButton.addTarget(self, action: #selector(viewMoreButtonTapped(_:)), for: .touchUpInside)
                sectionView.headerLabel.attributedText = Common.shared.attributedText(withString: defaultSectionNames[index], boldString: boldSectionNames[index], font: Common.shared.getFont(type: .regular, size: 15))
                if let section: HomeSectionType = HomeSectionType(rawValue: index) {
                    switch section {
                    case .popularPredictions:
                        print("in case")
                        sectionView.headerLabel.textColor = .black
                        sectionView.viewMoreButton.borderColor = BLUE_COLOR
                        sectionView.viewMoreButton.setTitleColor(BLUE_COLOR, for: .normal)
                        sectionView.viewMoreButton.isHidden = false
                        
                    case .trendingQuestions:
                        print("in case")
                        sectionView.headerLabel.textColor = .black
                        sectionView.viewMoreButton.borderColor = BLUE_COLOR
                        sectionView.viewMoreButton.setTitleColor(BLUE_COLOR, for: .normal)
                        sectionView.viewMoreButton.isHidden = false
                        
                    case .playAndWin:
                        sectionView.headerLabel.textColor = UIColor.white
                        sectionView.viewMoreButton.borderColor = UIColor.white
                        sectionView.viewMoreButton.setTitleColor(UIColor.white, for: .normal)
                        sectionView.viewMoreButton.isHidden = false

                        
                    case .yourVoice:
                        sectionView.viewMoreButton.setTitle("VIEW MORE", for: .normal)
                        sectionView.headerLabel.textColor = .black
                        sectionView.viewMoreButton.borderColor = BLUE_COLOR
                        sectionView.viewMoreButton.setTitleColor(BLUE_COLOR, for: .normal)
                        sectionView.viewMoreButton.isHidden = false

                    case .topRatedArticles:
                        //layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 0)
                        //sectionView.frame.size.height = 0
                        sectionView.headerLabel.textColor = .black
                        sectionView.viewMoreButton.isHidden = true
                        /*sectionView.viewMoreButton.borderColor = UIColor.white
                        sectionView.viewMoreButton.setTitleColor(UIColor.white, for: .normal)*/
                        
                    case .topDiscussions:
                        sectionView.viewMoreButton.setTitle("VIEW MORE", for: .normal)
                        sectionView.headerLabel.textColor = .black
                        sectionView.viewMoreButton.borderColor = BLUE_COLOR
                        sectionView.viewMoreButton.setTitleColor(BLUE_COLOR, for: .normal)
                        sectionView.viewMoreButton.isHidden = false

                        
                    }
                }
            }
            return sectionView
        case JEKCollectionElementKindSectionBackground:
            DLog(message: "set background for section")
            let backgroundView = homeCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionBackgroundImageView", for: indexPath) as! HomeBackgroundCollectionReusableView
            if let index = indexPath.first {
                if let section: HomeSectionType = HomeSectionType(rawValue: index) {
                    switch section {
                    case .popularPredictions:
                        DLog(message: "background for popularPredictions")
                        backgroundView.backgroundImageView.image = UIImage()

                    case .trendingQuestions:
                        DLog(message: "background for trendingQuestions")
                        backgroundView.backgroundImageView.image = UIImage()
                        
                    case .playAndWin:
                        DLog(message: "background for playAndWin")
                        backgroundView.backgroundImageView.image = UIImage(named: "PlayAndWinBGImage")
                    case .yourVoice:
                        DLog(message: "background for yourVoice")
                        backgroundView.backgroundImageView.image = UIImage()

                    case .topRatedArticles:
                        if ratedArticleList.isEmpty {
                            backgroundView.backgroundImageView.image = nil
                        } else {
                            backgroundView.backgroundImageView.image = UIImage(named: "TopRatedArticlesGradient")
                        }
                        DLog(message: "background for topRatedArticles")

                    case .topDiscussions:
                        backgroundView.backgroundImageView.image = UIImage()

                        DLog(message: "background for topDiscussions")

                    }
                }
            }
            return backgroundView
        default:
            let footerView = homeCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerView", for: indexPath)
            footerView.backgroundColor = UIColor.groupTableViewBackground
            //footerView.backgroundColor = .blue
            return footerView
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let section = HomeSectionType(rawValue: section) else { return layout.sectionInset }
        switch section {
        case .topRatedArticles:
            return layout.sectionInset
//            return topRatedArticlesInsets
        case .playAndWin:
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        default:
            return layout.sectionInset
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let section = HomeSectionType(rawValue: section) else { return CGSize(width: 0, height: 0) }
        switch section {
        case .popularPredictions:
            if predictionList.count > 0 {
                return layout.headerReferenceSize
            } else {
                return CGSize(width: 0, height: 0)
            }
        case .trendingQuestions:
            if questionList.count > 0 {
                return layout.headerReferenceSize
            }else {
                return CGSize(width: 0, height: 0)
            }
        case .playAndWin:
            if playAndWinList.count > 0 {
                return layout.headerReferenceSize
            }else{
                return CGSize(width: 0, height: 0)
            }
        case .yourVoice:
            if yourVoiceList.count > 0 {
                return layout.headerReferenceSize
            }else {
                return CGSize(width: 0, height: 0)
            }
        case .topRatedArticles:
            if ratedArticleList.count > 0 {
                return CGSize(width: 0, height: 10)

//                return layout.headerReferenceSize
            }else {
                return CGSize(width: 0, height: 0)
            }
        case .topDiscussions:
            if discussionList.count > 0 {
                return layout.headerReferenceSize
            }else {
                return CGSize(width: 0, height: 0)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let section = HomeSectionType(rawValue: section) else { return CGSize(width: 0, height: 0) }
        switch section {
        case .popularPredictions:
            if predictionList.count > 0 {
                return layout.footerReferenceSize
            } else {
                return CGSize(width: 0, height: 0)
            }
        case .trendingQuestions:
            if questionList.count > 0 {
                return layout.footerReferenceSize
            }else {
                return CGSize(width: 0, height: 0)
            }
        case .playAndWin:
            if playAndWinList.count > 0 {
                return layout.footerReferenceSize
            }else{
                return CGSize(width: 0, height: 0)
            }
        case .yourVoice:
            if yourVoiceList.count > 0 {
                return layout.footerReferenceSize
            }else {
                return CGSize(width: 0, height: 0)
            }
        case .topRatedArticles:
            if ratedArticleList.count > 0 {
                return layout.footerReferenceSize
            }else {
                return CGSize(width: 0, height: 0)
            }
        case .topDiscussions:
            if discussionList.count > 0 {
                return layout.footerReferenceSize
            }else {
                return CGSize(width: 0, height: 0)
            }
        }
    }
    
}

/*extension HomeViewController:JEKCollectionViewDelegateScrollableSectionLayout{
    func collectionView(_ collectionView: UICollectionView!, layout: JEKScrollableSectionCollectionViewLayout!, section: UInt, didScrollToOffset horizontalOffset: CGFloat) {
        if section == 4{
            
            if Int(horizontalOffset) > (Device.SCREEN_WIDTH)/4{
                UIView.animate(withDuration: 0.5) {
                    self.topArticleView.alpha = 0
                }
            } else{
                UIView.animate(withDuration: 0.5) {
                    self.topArticleView.alpha = 1
                }
            }
        }
    }
}*/

//MARK:-  Add Background view to sections
extension HomeViewController {
    
    private func populateData() {
        
        //check for no data
        let isData = checkForNoData()
        if isData {
            
//            self.addPredictionBgView()
//            self.addQuestionBgView()
//            self.addPlayAndWinBackgroundView()
//            self.addYourVoiceBackgroundView()
//            self.addRatedArticleBgView()
//            self.addDiscussionBackgroundView()
        } else {
            setNoDataState()
        }
    }
    
    private func checkForNoData() -> Bool {
        if predictionList.count <= 0, questionList.count <= 0, playAndWinList.count <= 0, yourVoiceList.count <= 0, ratedArticleList.count <= 0, discussionList.count <= 0 {
            return false
        }
        return true
    }
    private func addPredictionBgView() {
        if predictionList.count <= 0 {
            return
        }
        
        if predictionView != nil {
            predictionView?.removeFromSuperview()
        }
        
        predictionView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 260))
        predictionView?.backgroundColor = .white
        predictionView?.isUserInteractionEnabled = false
        predictionView?.layer.zPosition = -1
        self.homeCollectionView.addSubview(predictionView!)
        dropShdowToView(view: predictionView!)
    }
    
    private func addQuestionBgView() {
        if questionList.count <= 0 {
            return
        }
        if questionView != nil {
            questionView?.removeFromSuperview()
        }
        
        var Yaxis : CGFloat = 0.0
        if predictionList.count > 0 {
            // plus 250
            Yaxis = Yaxis + 250.0
            Yaxis = Yaxis + 20.0
        }
        
        questionView = UIView(frame: CGRect(x: 0, y: Yaxis, width: UIScreen.main.bounds.width, height: 250))
        questionView?.backgroundColor = .white
        questionView?.isUserInteractionEnabled = false
        questionView?.layer.zPosition = -1
        self.homeCollectionView.addSubview(questionView!)
    }
    
    private func addPlayAndWinBackgroundView() {
        if playAndWinList.count <= 0 {
            return
        }
        var Yaxis : CGFloat = 0.0
        if predictionList.count > 0 {
            // plus 250
            Yaxis = Yaxis + 250.0
            // spacing in the cell
            Yaxis = Yaxis + 20.0
        }
        if questionList.count > 0 {
            // plus 250
            Yaxis = Yaxis + 250.0
            Yaxis = Yaxis > 250 ? Yaxis + 15.0:Yaxis + 20.0
        }
        
        yourVoiceBackgroundImageView.frame = CGRect(x: 0, y: Yaxis + 50, width: UIScreen.main.bounds.width, height: 245)
        yourVoiceBackgroundImageView.isHidden = false
        yourVoiceBackgroundImageView.image = UIImage(named: "PlayAndWinBGImage")
        yourVoiceBackgroundImageView.layer.zPosition = -1
        self.homeCollectionView.addSubview(yourVoiceBackgroundImageView)
    }
    
    private func addYourVoiceBackgroundView() {
        if yourVoiceList.count <= 0 {
            return
        }
        var Yaxis : CGFloat = 0.0
        if predictionList.count > 0 {
            // plus 250
            Yaxis = Yaxis + 250.0
            // spacing in the cell
            Yaxis = Yaxis + 20.0
        }
        if questionList.count > 0 {
            // plus 250
            Yaxis = Yaxis + 250.0
            Yaxis = Yaxis > 250 ? Yaxis + 15.0:Yaxis + 20.0
        }
        if playAndWinList.count > 0 {
            // plus 250
            Yaxis = Yaxis + 190.0
            Yaxis = Yaxis > 250 ? Yaxis + 15.0:Yaxis + 20.0
        }
        if yourVoiceView != nil {
            yourVoiceView?.removeFromSuperview()
        }
        
        yourVoiceView = UIView(frame: CGRect(x: 0, y: Yaxis + 50, width: UIScreen.main.bounds.width + 50, height: 250))
        yourVoiceView?.backgroundColor = .white
        yourVoiceView?.isUserInteractionEnabled = false
        yourVoiceView?.layer.zPosition = -1
        self.homeCollectionView.addSubview(yourVoiceView!)
        dropShdowToView(view: yourVoiceView!)
    }
    
    private func addRatedArticleBgView() {
        if ratedArticleList.count <= 0 {
            return
        }
        
        var Yaxis : CGFloat = 0.0
        if predictionList.count > 0 {
            // plus 250
            Yaxis = Yaxis + 250.0
            Yaxis = Yaxis + 20.0
        }
        if questionList.count > 0 {
            // plus 250
            Yaxis = Yaxis + 250.0
            Yaxis = Yaxis > 250 ? Yaxis + 15.0:Yaxis + 20.0
        }
        if playAndWinList.count > 0 {
            // plus 250
            Yaxis = Yaxis + 190.0
            Yaxis = Yaxis > 250 ? Yaxis + 15.0:Yaxis + 20.0
        }
        if yourVoiceList.count > 0 {
            // plus 250
            Yaxis = Yaxis + 250.0
            Yaxis = Yaxis > 250 ? Yaxis + 15.0:Yaxis + 20.0
        }
        
        topRatedArticlesBackgroundImageView.frame = CGRect(x: 0, y: Yaxis + 100, width: UIScreen.main.bounds.width, height: 210)
        topRatedArticlesBackgroundImageView.isHidden = false
        topRatedArticlesBackgroundImageView.image = UIImage(named: "TopRatedArticlesGradient")
        topRatedArticlesBackgroundImageView.layer.zPosition = -2
        self.homeCollectionView.addSubview(topRatedArticlesBackgroundImageView)
        
        topArticleView.frame = CGRect(x: 0, y: Yaxis + 100, width: UIScreen.main.bounds.width / 2, height: 210)
        topArticleView.layer.zPosition = -1
        self.homeCollectionView.addSubview(topArticleView)
        
        topRatedArticlesInsets = UIEdgeInsets(top: 5, left: CGFloat(Device.SCREEN_WIDTH/2), bottom: 5, right: 5)
    }
    
    private func addDiscussionBackgroundView() {
        if discussionList.count <= 0 {
            return
        }
        var Yaxis : CGFloat = 0.0
        if predictionList.count > 0 {
            // plus 250
            Yaxis = Yaxis + 250.0
            // spacing in the cell
            Yaxis = Yaxis + 20.0
        }
        if questionList.count > 0 {
            // plus 250
            Yaxis = Yaxis + 250.0
            Yaxis = Yaxis > 250 ? Yaxis + 15.0:Yaxis + 20.0
        }
        if playAndWinList.count > 0 {
            // plus 250
            Yaxis = Yaxis + 190.0
            Yaxis = Yaxis > 250 ? Yaxis + 15.0:Yaxis + 20.0
        }
        if yourVoiceList.count > 0 {
            // plus 250
            Yaxis = Yaxis + 250.0
            Yaxis = Yaxis > 250 ? Yaxis + 15.0:Yaxis + 20.0
        }
        if ratedArticleList.count > 0 {
            // plus 250
            Yaxis = Yaxis + 180.0
            Yaxis = Yaxis > 250 ? Yaxis + 15.0:Yaxis + 20.0
        }
        if discussionView != nil {
            discussionView?.removeFromSuperview()
        }
        
        discussionView = UIView(frame: CGRect(x: 0, y: Yaxis, width: UIScreen.main.bounds.width, height: 260))
        discussionView?.backgroundColor = .white
        discussionView?.isUserInteractionEnabled = false
        discussionView?.layer.zPosition = -1
        self.homeCollectionView.addSubview(discussionView!)
        dropShdowToView(view: discussionView!)
    }
    
    private func dropShdowToView(view: UIView) {
        let shadowPath = UIBezierPath(rect: view.frame)
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowPath = shadowPath.cgPath
    }
    
}

extension HomeViewController: HotTopicDelegate {
    func showTopicView() {
        if loadOneTime {
            loadOneTime = false
            hotTopicViewController.reloadTopicData()
        }
        UIView.animate(withDuration: 0.2) {
            self.hotTopicViewHeight.constant = 250
        }
    }
    
    func hideTopicView() {
        loadOneTime = true
        hotTopicHeight = hotTopicViewHeight.constant
        hotTopicViewHeight.constant = 0
    }
    
}
//MARK:- APNs Update API
extension HomeViewController {
//    "user_id:5149
//    device_token:abd
//    device_type:Android/Ios"
    func updateDeviceAPNs() {
        if NetworkStatus.shared.haveInternet() {
            guard let deviceAPNsToken = Common.shared.getDeviceAPNsToken() else { return }
            let params = ["user_id": USERID, "device_token":deviceAPNsToken, "device_type": "Ios"]
            Service.sharedInstance.request(api: API_UPDATE_DEVICE_TOKEN, type: .post, parameters: params, complete: { (response) in
                do {
                    let responseData = try decoder.decode(StatusResponse.self, from: response as! Data)
                    DLog(message: "\(responseData)")
                } catch {
                    DLog(message: "\(error)")
                }
                DLog(message: "\(response)")
            }) { (error) in
                DLog(message: "\(error)")
            }
        }
    }
}
/*
 /*let json = try JSONSerialization.jsonObject(with: response as! Data, options: .mutableLeaves)
 guard let idk = json as? [Dictionary<String, Any>] else {return}
 print(idk)*/
 */
