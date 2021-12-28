//
//  HomeViewController.swift
//  CrowdWisdom
//
//  Created by  user on 7/24/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit


enum HotTopicSectionType: Int {
    case popularPredictions = 0
    case trendingQuestions = 1
    case playAndWin = 2
    case yourVoice = 3
    case topRatedArticles = 4
    case topDiscussions = 5
    
}
protocol HotTopicDetailsDelegate {
    func reloadTopicListData()
}

class HotTopicDetailViewController: NavigationSearchViewController, UINavigationControllerDelegate {
    
    //MARK:- Public Variables
    
    var hotTopicName = ""
    var topicId = ""
    var isFollow = false
    var delegate: HotTopicDetailsDelegate?
    var followButton = UIButton()
    //MARK:- Internal Outlets And Varibles
    
    //TODO: Outlets
    @IBOutlet weak var hotTopicDetailCollectionView: UICollectionView!
    
    //TODO: Lazy var
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
        cell.topicNameLabel.text = self.hotTopicName
        return cell.contentView
    }()
    
    //TODO: Priavte var
    private var layout = JEKScrollableSectionCollectionViewLayout()
    private var topRatedArticlesInsets = UIEdgeInsets()
    
    private var topicList = [TopicListModel]()
    private var predictionList = [PredictionListModel]()
    private var questionList = [QuestionListModel]()
    private var playAndWinList = [PlayAndWinListModel]()
    private var yourVoiceList = [YourVoiceListModel]()
    private var ratedArticleList = [RatedArticleListModel]()
    private var discussionList = [DiscussionListModel]()
    
    private let heightForView: CGFloat = 180.0
    private let imageView = UIImageView()
    private var collapsableView = UIView()
    private var buttonYAxis: CGFloat = 0.0
    private var labelYAxis: CGFloat = 0.0
    
    private var predictionView: UIView?
    private var questionView: UIView?
    private var yourVoiceView: UIView?
    private var discussionView: UIView?
    
    private lazy var collapsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Roboto-Medium", size: 15)
        return label
    }()
    
    private lazy var buttonView: UIView = {
        let view = UIView()
        return view
    }()
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set collection view
        setCollectionViewLayout()
        registerCells()
        hotTopicDetailCollectionView.isHidden = true
        //get data from Server
        getTopicData()
        emptyStateAction = {
            self.getTopicData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // set back button
        self.setupLeftBarButton(isback: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        getTopicData(showLoader: false)
        // seting the navigation bar
        addGradientTonavigationBar()
        
        /*if #available(iOS 11.0, *) {
            hotTopicDetailCollectionView.contentInsetAdjustmentBehavior = .automatic
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = true
        }*/
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    //MARK:-  Initial Setup
    private func setCollectionViewLayout() {
        layout = hotTopicDetailCollectionView.collectionViewLayout as! JEKScrollableSectionCollectionViewLayout
        layout.itemSize = CGSize(width: 300, height: 200)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        layout.footerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 15)
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.showsSectionBackgrounds = true
        //layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    private func registerCells(){
        hotTopicDetailCollectionView.register(UINib(nibName: "PredictionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "predictionCell")
        hotTopicDetailCollectionView.register(UINib(nibName: "TrendingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "trendingCell")
        hotTopicDetailCollectionView.register(UINib(nibName: "TopDiscussionCell", bundle: nil), forCellWithReuseIdentifier: "discussionCell")
        hotTopicDetailCollectionView.register(UINib(nibName: "PlayAndWinCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "playAndWinCell")
        hotTopicDetailCollectionView.register(UINib(nibName: "BasicCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "basicCell")
        hotTopicDetailCollectionView.register(UINib(nibName: "TopRatedArticlesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "articlesCell")
        hotTopicDetailCollectionView.register(UINib(nibName: "HomeHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "sectionView")
        hotTopicDetailCollectionView.register(UINib(nibName: "HomeBackgroundCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "JEKCollectionElementKindSectionBackground", withReuseIdentifier: "sectionBackgroundImageView")
        hotTopicDetailCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView")
        
    }
    
    //MARK:-  Collapsable View setup
    private func setUpCollapsableView() {
        hotTopicDetailCollectionView.contentInset = UIEdgeInsets(top: heightForView, left: 0, bottom: 0, right: 0)

        // remove before adding it again
        
        collapsableView.removeFromSuperview()
        
        collapsableView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: heightForView))
        collapsableView.backgroundColor = .groupTableViewBackground
        view.addSubview(collapsableView)
        
        addBackGorundImageToCollapsableView()
        addTopicNameToCollapsableView()
        addButtonsToCollapsView()
    }
    
    private func addBackGorundImageToCollapsableView() {
        
        imageView.removeFromSuperview()
        
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: heightForView - 25)
        imageView.image = UIImage.init(named: "hotTopicCollapsableBGImage")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        collapsableView.addSubview(imageView)
    }
    
    private func addTopicNameToCollapsableView() {
        collapsLabel.removeFromSuperview()
        collapsableView.addSubview(collapsLabel)
        
        let font = UIFont(name: "Roboto-Medium", size: 17)
        let ht = hotTopicName.height(withConstrainedWidth: UIScreen.main.bounds.size.width - 120, font: font!)
        collapsLabel.text = hotTopicName
        labelYAxis = ht > 45 ? 45:ht
        collapsLabel.frame = CGRect(x: 60, y: (labelYAxis+50)/2 + 10, width: UIScreen.main.bounds.size.width - 120, height: labelYAxis)
    }
    
    private func addButtonsToCollapsView() {
        buttonView.removeFromSuperview()
        
        var frame = collapsLabel.frame
        frame.origin.y = collapsLabel.frame.origin.y + collapsLabel.frame.size.height
        frame.origin.x = 0
        frame.size.width = UIScreen.main.bounds.width
        frame.size.height = 50
        buttonView.frame = frame
        //        buttonView.backgroundColor = .red
        collapsableView.addSubview(buttonView)
        buttonYAxis = collapsLabel.frame.origin.y + collapsLabel.frame.size.height
        addFollowShareButton()
    }
    
    private func addFollowShareButton() {
        let bgColor = UIColor(red: 255.0/255.0, green: 77.0/255.0, blue: 106.0/255.0, alpha: 1.0)
        
        followButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2 - 110, y: 10, width: 110, height: 30))
        followButton.layer.cornerRadius = 15
        followButton.layer.borderWidth = 0.5
        followButton.layer.borderColor = bgColor.cgColor
        followButton.backgroundColor = bgColor
        if isFollow {
            followButton.setTitle("✓ Following", for: .normal)
        }else{
            followButton.setTitle("+ Follow", for: .normal)
        }
        followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        followButton.setTitleColor(.white, for: .normal)
        followButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 15)
        buttonView.addSubview(followButton)
        
        let shareButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2 + 5, y: 10, width: 100, height: 30))
        shareButton.layer.cornerRadius = 15
        shareButton.layer.borderWidth = 0.5
        shareButton.layer.borderColor = bgColor.cgColor
        shareButton.backgroundColor = bgColor
        shareButton.setTitle("Share", for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtontapped), for: .touchUpInside)
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 15)
        buttonView.addSubview(shareButton)
    }
    
    //MARK:- API Call
    private func getTopicData(showLoader: Bool = true) {
        if NetworkStatus.shared.haveInternet() {
            if showLoader { Loader.showAdded(to: self.view, animated: true) }
            let params = ["user_id":USERID, "topic_id":topicId,"offset":"0"]
            print("Home param:\(params)")
            Service.sharedInstance.request(api: API_HOME_LIST, type: .post, parameters: params, complete: { (response) in
                
                do{
                    let homeResponse = try decoder.decode(HomeModel.self, from: response as! Data)
                    if let data = homeResponse.data {
                        self.removeAllPreviousData()
                        self.topicList += data.topic_list ?? [TopicListModel]()
                        self.predictionList += data.prediction_list ?? [PredictionListModel]()
                        self.questionList += data.question_list ?? [QuestionListModel]()
                        self.playAndWinList += data.competetion_list ?? [PlayAndWinListModel]()
                        self.yourVoiceList += data.your_voice_list ?? [YourVoiceListModel]()
                        self.ratedArticleList += data.rated_article_list ?? [RatedArticleListModel]()
                        self.discussionList += data.discussion_list ?? [DiscussionListModel]()
                        self.setData(response: homeResponse)
                        self.populateData()
                        self.setCollectionViewLayout()
                        self.hotTopicDetailCollectionView.reloadData()
                    }else {
                        self.setNoDataState()
                    }
                    Loader.hide(for: self.view, animated: true)
                }catch {
                    
                    self.setNoDataState()
                    Loader.hide(for: self.view, animated: true)
                }
            }) { (error) in
                self.setNoDataState()
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
    
    //MARK:- Button Action
    @IBAction func playNowButtonAction (_ sender: UIButton){
        let competitionVC = CompetitionInfoViewController.init(nibName: "CompetitionInfoViewController", bundle: nil)
        competitionVC.competitionID = playAndWinList [sender.tag].id ?? "0"
        self.navigationController?.pushViewController(competitionVC, animated: true)
    }
    
    @IBAction func viewMoreButtonTapped(_ sender: UIButton) {
        let cardListViewController = storyboard?.instantiateViewController(withIdentifier: "CardMainViewViewController") as! CardMainViewViewController
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
//                 let gameDetailViewController = storyboard?.instantiateViewController(withIdentifier: "GameDetailViewController") as! GameDetailViewController
//                self.navigationController?.pushViewController(gameDetailViewController, animated: true)
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
    
    @objc func followButtonTapped(sender: UIButton) {
        if USERID == "0" {
            self.setLoginPage()
        }else
        {
            isFollow = !isFollow
            followTopic(sender: sender)
        }
        print("follow button tapped")
    }
    
    @objc func shareButtontapped(sender: UIButton) {
        var shareLink = ""
            shareLink = Common.shared.shareURL(id: topicId, isVoice: 2)
        //gaurav commit
//        if let someText:String = hotTopicName {
//                let objectsToShare = URL(string:shareLink)
//                let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
//                let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
//                activityViewController.popoverPresentationController?.sourceView = self.view
//                self.present(activityViewController, animated: true, completion: nil)
//            }
        }
        
    func setLoginPage() {
        let vc = storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.isFromAction = true
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }

        //        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter]
        
    }

extension HotTopicDetailViewController:LoginViewDelegate{
    func loginSuccessful() {
        isFollow = !isFollow
        followTopic(sender: followButton)
    }
    

}
//MARK:-  Add Background view to sections
extension HotTopicDetailViewController {
    
    private func populateData() {
        // UI Update
        self.emptyView.removeFromSuperview()
        hotTopicDetailCollectionView.isHidden = false
        
        //check for no data
        let isData = checkForNoData()
        if isData {
            // collapsable view
            self.setUpCollapsableView()
            
            //self.addPredictionBgView()
            //self.addQuestionBgView()
//            self.addPlayAndWinBackgroundView()
            //self.addYourVoiceBackgroundView()
            //self.addRatedArticleBgView()
            //self.addDiscussionBackgroundView()
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
    
    private func setData(response: HomeModel) {
        hotTopicName = response.topic_name ?? ""
        isFollow = Bool(truncating: Int(response.is_follow ?? 0) as NSNumber)
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
        self.hotTopicDetailCollectionView.addSubview(predictionView!)
        dropShdowToView(view: predictionView!)
    }
    
    private func addQuestionBgView() {
        if questionList.count <= 0 {
            return
        }
        var Yaxis : CGFloat = 0.0
        if predictionList.count > 0 {
            // plus 250
            Yaxis = Yaxis + 250.0
            Yaxis = Yaxis + 20.0
        }
        if questionView != nil {
            questionView?.removeFromSuperview()
        }
        questionView = UIView(frame: CGRect(x: 0, y: Yaxis, width: UIScreen.main.bounds.width, height: 130))
        questionView?.backgroundColor = .white
        questionView?.isUserInteractionEnabled = false
        questionView?.layer.zPosition = -1
        self.hotTopicDetailCollectionView.addSubview(questionView!)
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
        
        yourVoiceBackgroundImageView.frame = CGRect(x: 0, y: Yaxis, width: UIScreen.main.bounds.width, height: 250)
        yourVoiceBackgroundImageView.isHidden = false
        yourVoiceBackgroundImageView.image = UIImage(named: "PlayAndWinBGImage")
        yourVoiceBackgroundImageView.layer.zPosition = -1
        self.hotTopicDetailCollectionView.addSubview(yourVoiceBackgroundImageView)
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
        yourVoiceView = UIView(frame: CGRect(x: 0, y: Yaxis, width: UIScreen.main.bounds.width, height: 250))
        yourVoiceView?.backgroundColor = .white
        yourVoiceView?.isUserInteractionEnabled = false
        yourVoiceView?.layer.zPosition = -1
        self.hotTopicDetailCollectionView.addSubview(yourVoiceView!)
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
        
        topRatedArticlesBackgroundImageView.frame = CGRect(x: 0, y: Yaxis, width: UIScreen.main.bounds.width, height: 180)
        topRatedArticlesBackgroundImageView.isHidden = false
        topRatedArticlesBackgroundImageView.image = UIImage(named: "TopRatedArticlesGradient")
        topRatedArticlesBackgroundImageView.layer.zPosition = -2
        self.hotTopicDetailCollectionView.addSubview(topRatedArticlesBackgroundImageView)
        
        topArticleView.frame = CGRect(x: 0, y: Yaxis, width: UIScreen.main.bounds.width / 2, height: 150)
        topArticleView.layer.zPosition = -1
        self.hotTopicDetailCollectionView.addSubview(topArticleView)
        
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
        self.hotTopicDetailCollectionView.addSubview(discussionView!)
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

//MARK:-  Collection view delegate, datasource and flow layout delegate
extension HotTopicDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section: HotTopicSectionType = HotTopicSectionType(rawValue: section) else { return 0 }
        switch section {
        case .popularPredictions:
            return predictionList.count
        case .trendingQuestions:
            return questionList.count
        case .playAndWin:
            return playAndWinList.count
        case .yourVoice:
            return yourVoiceList.count
        case .topRatedArticles:
            return ratedArticleList.count + 1
        case .topDiscussions:
            return discussionList.count
        }
        // return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section: HotTopicSectionType = HotTopicSectionType(rawValue: indexPath.section) else { return UICollectionViewCell() }
        switch section {
        case .popularPredictions:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "predictionCell", for: indexPath) as! PredictionCollectionViewCell
            if predictionList.count > indexPath.row{
                let dict = predictionList[indexPath.row]
                cell.predictionImageView.kf.setImage(with: URL(string: dict.image ?? ""), placeholder: UIImage(named: "placeholder"))
                cell.predictionNameLabel.text = (dict.title ?? "").handleApostrophe()
                let vote_count = Int(dict.total_votes ?? "")
                let comment_count = Int(dict.total_comments ?? "")
                let voteLabel = vote_count ?? 0 <= 1 ? "VOTE" : "VOTES"
                let commentLabel = comment_count ?? 0 <= 1 ? "COMMENT" : "COMMENTS"
                cell.predictionDetailLabel.text = "\(dict.total_votes ?? "0") \(voteLabel) \(dict.total_comments ?? "0") \(commentLabel)"
            }
            return cell
        case .trendingQuestions:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingCell", for: indexPath) as! TrendingCollectionViewCell
            if questionList.count > indexPath.row {
                let dict = questionList[indexPath.row]
                cell.questionInitialLabelBackgroundColor = UIColor.random()
                cell.questionImageView.kf.setImage(with: URL(string: dict.image ?? ""), placeholder: UIImage(named: "placeholder"))
                cell.isVoiceCell = false
                
                if let name = dict.alias {
                    cell.questionInitialLabel.text = "\(name.uppercased().first ?? "U")"
                    cell.questionInitialLabelBackgroundColor = UIColor.random()
                    cell.answerLabel.text = name

                } else {
                    cell.questionInitialLabel.text = "U"
                    cell.questionInitialLabelBackgroundColor = UIColor.random()
                    cell.answerLabel.text = ""
                }
                cell.questionLabel.text = (dict.question ?? "").handleApostrophe()
                let vote_count = Int(dict.total_votes ?? "0")
                let comment_count = Int(dict.total_comments ?? "0")
                let voteLabel = vote_count ?? 0 <= 1 ? "VOTE" : "VOTES"
                let commentLabel = comment_count ?? 0 <= 1 ? "COMMENT" : "COMMENTS"
                cell.infoLabel.text = "\(dict.total_votes ?? "0") \(voteLabel) \(dict.total_comments ?? "0") \(commentLabel)"
            }
            return cell
        case .playAndWin:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playAndWinCell", for: indexPath) as! PlayAndWinCollectionViewCell
            if playAndWinList.count > indexPath.row {
                let dict = playAndWinList[indexPath.row]
                if let image = dict.image {
                    cell.gameImageView.kf.setImage(with: URL(string: image), placeholder: UIImage(named: "placeholder"))
                } else {
                    cell.gameImageView.image = UIImage(named: "placeholder")
                }
                cell.gameNameLabel.text = (dict.name ?? "").handleApostrophe()
                cell.gameNameLabel.font = Common.shared.getFont(type: .medium, size: 14)
                cell.gameNameLabel.textColor = UIColor.black
                
                cell.playNowButtonTapped.addTarget(self, action: #selector(playNowButtonAction(_:)), for: .touchUpInside)
                cell.playNowButtonTapped.tag = indexPath.row
            }
            
            return cell
        case .yourVoice:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingCell", for: indexPath) as! TrendingCollectionViewCell
            cell.isVoiceCell = true
            if yourVoiceList.count > indexPath.row {
                let dict = yourVoiceList[indexPath.row]
                if let image = dict.image, let comments = dict.total_comments, let likes = dict.total_likes, let type = dict.type{
                    cell.questionImageView.kf.setImage(with: URL(string: image), placeholder: UIImage(named: "placeholder"))
                    cell.answerLabel.text = dict.alias ?? "U"
                    cell.questionLabel.text = (dict.title ?? "").handleApostrophe()
                    cell.typeLabel.text = type
                    cell.isVoiceCell = false
                    
                    if let name = dict.alias {
                        cell.questionInitialLabel.text = "\(name.uppercased().first ?? "U")"
                        cell.questionInitialLabelBackgroundColor = UIColor.random()
                    } else {
                        cell.questionInitialLabel.text = "U"
                        cell.questionInitialLabelBackgroundColor = UIColor.random()
                    }
                    
                    let like_count = Int(likes)
//                    let comment_count = Int(comments)
                    let likeLabel = like_count ?? 0 <= 1 ? "LIKE" : "LIKES"
                    let totalViews = Common.shared.getCommentIntValue(string: dict.total_views)
                    cell.infoLabel.text = "\(totalViews) \(totalViews > 1 ? "VIEWS":"VIEW") ● \(likes) \(likeLabel)" //● \(comments) \(commentLabel)"
//                    let commentLabel = comment_count ?? 0 <= 1 ? "COMMENT" : "COMMENTS"
//                    cell.infoLabel.text = "\(likes) \(likeLabel) \(comments) \(commentLabel)"
                    
                }
            }
            return cell
        case .topRatedArticles:
            if indexPath.row == 0 {
                let cell =  hotTopicDetailCollectionView.dequeueReusableCell(withReuseIdentifier: "basicCell", for: indexPath) as! BasicCollectionViewCell
                cell.viewMoreButton.borderWidth = 1
                cell.viewMoreButton.borderColor = UIColor.white
                cell.viewMoreButton.cornerRadius = cell.viewMoreButton.frame.height / 2
                cell.viewMoreButton.tag = indexPath.section
                cell.viewMoreButton.addTarget(self, action: #selector(viewMoreButtonTapped(_:)), for: .touchUpInside)
                return cell
                
            } else {
                let cell = hotTopicDetailCollectionView.dequeueReusableCell(withReuseIdentifier: "articlesCell", for: indexPath) as! TopRatedArticlesCollectionViewCell
                if let url = URL(string: ratedArticleList[indexPath.row - 1].image ?? "") {
                    cell.articleImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
                }
                cell.articleTitleLable.text = (ratedArticleList[indexPath.row - 1].question ?? "").handleApostrophe()
                
                let totalVotes = Common.shared.getCommentIntValue(string: ratedArticleList[indexPath.row - 1].total_like) + Common.shared.getCommentIntValue(string: ratedArticleList[indexPath.row - 1].total_neutral) + Common.shared.getCommentIntValue(string: ratedArticleList[indexPath.row - 1].total_dislike)
                cell.voteLabel.text = "\(totalVotes) \(totalVotes > 1 ? "VOTES" : "VOTE")"
                
                return cell
                
            }
        case .topDiscussions:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "discussionCell", for: indexPath) as! TopDiscussionCell
            if discussionList.count > indexPath.row {
                let dict = discussionList[indexPath.row]
                if let image = dict.image, let title = dict.title, let neutral = dict.total_neutral, let likes = dict.total_like, let dislike = dict.total_dislike  {
                    cell.answerLabel.text = dict.alias ?? "U"
                    cell.questionLabel.text = title.handleApostrophe()
                    cell.questionImageView.kf.setImage(with: URL(string: image))
                    cell.isVoiceCell = true
                    
                    if let name = dict.alias {
                        cell.questionInitialLabel.text = "\(name.uppercased().first ?? "U")"
                        cell.questionInitialLabelBackgroundColor = UIColor.random()
                    } else {
                        cell.questionInitialLabel.text = "U"
                        cell.questionInitialLabelBackgroundColor = UIColor.random()
                    }
                    
                    let like_count = Int(likes) ?? 0
                    let neutralCount = Int(neutral) ?? 0
                    let disLikeCount = Int(dislike) ?? 0
                    let neutralLabel = neutralCount ?? 0 <= 1 ? "NEUTRAL" : "NEUTRALS"
                    let dislikeLabel = disLikeCount ?? 0 <= 1 ? "DISLIKE" : "DISLIKES"
                    let totalVotes =  like_count + neutralCount + disLikeCount
                    let likeLabel = totalVotes ?? 0 <= 1 ? "VOTE" : "VOTES"
//                    cell.infoLabel.text = "\(likes) \(likeLabel) \(neutral) \(neutralLabel) \(dislike) \(dislikeLabel)"
                    cell.infoLabel.text = "\(totalVotes) \(likeLabel)"
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section: HotTopicSectionType = HotTopicSectionType(rawValue: indexPath.section) else { return }
        let cardDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "CardDetailsViewController") as! CardDetailsViewController
        switch section {
        case .playAndWin:
//            let gameDetailViewController = storyboard?.instantiateViewController(withIdentifier: "GameDetailViewController") as! GameDetailViewController
//            self.navigationController?.pushViewController(gameDetailViewController, animated: true)
            
            let competitionVC = CompetitionInfoViewController.init(nibName: "CompetitionInfoViewController", bundle: nil)
            competitionVC.competitionID = playAndWinList[indexPath.row].id ?? ""
            self.navigationController?.pushViewController(competitionVC, animated: true)
        case .popularPredictions:
            cardDetailsViewController.type = CardType.prediction
            let dict = predictionList[indexPath.row]
            cardDetailsViewController.type = .prediction
            cardDetailsViewController.cardId = dict.id ?? "0"
            cardDetailsViewController.index = indexPath.row
            cardDetailsViewController.section = indexPath.section
            cardDetailsViewController.refreshDelegate = self
            cardDetailsViewController.getCardDetail(with: cardDetailsViewController.type ?? .prediction)
            self.navigationController?.pushViewController(cardDetailsViewController, animated: true)
        case .trendingQuestions:
            
            let dict = questionList[indexPath.row]
            cardDetailsViewController.type = CardType.askQuestion
            cardDetailsViewController.cardId = dict.id ?? "0"
            cardDetailsViewController.index = indexPath.row
            cardDetailsViewController.section = indexPath.section
            cardDetailsViewController.refreshDelegate = self
            cardDetailsViewController.getCardDetail(with: cardDetailsViewController.type ?? .askQuestion)
            self.navigationController?.pushViewController(cardDetailsViewController, animated: true)
        case .yourVoice:
            let dict = yourVoiceList[indexPath.row]
            let blogViewController = storyboard?.instantiateViewController(withIdentifier: "BlogViewController") as! BlogViewController
            blogViewController.blogId = dict.id ?? "0"
            blogViewController.getBlogDetails()
            blogViewController.countDelegate = self
            self.navigationController?.pushViewController(blogViewController, animated: true)
        case .topRatedArticles:
            if indexPath.row == 0 { return }
            let ratedDetailsVC = RatedArticleDetailsViewController(nibName:"RatedArticleDetailsViewController", bundle: nil)
            ratedDetailsVC.delegate = self
            ratedDetailsVC.articleID = ratedArticleList[indexPath.row - 1].id ?? ""
            self.navigationController?.pushViewController(ratedDetailsVC, animated: true)
//            self.navigationController?.pushViewController(cardDetailsViewController, animated: true)
        case .topDiscussions:
            cardDetailsViewController.type = CardType.discussion
//            let wallViewController = storyboard?.instantiateViewController(withIdentifier: "WallViewController") as! WallViewController
//            wallViewController.wallId = discussionList[indexPath.row].id ?? ""
//            self.navigationController?.pushViewController(wallViewController, animated: true)
            let wallInfoViewController = WallInfoViewController(nibName:"WallInfoViewController", bundle: nil)
            wallInfoViewController.wallId = discussionList[indexPath.row].id ?? ""
            wallInfoViewController.delegate = self
            self.navigationController?.pushViewController(wallInfoViewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = HotTopicSectionType(rawValue: indexPath.section) else { return CGSize(width: UIScreen.main.bounds.width - 40, height: heightForView) }
        switch section {
        case .popularPredictions:
            if predictionList.count > 0 {
                return CGSize(width: UIScreen.main.bounds.width - 30, height: 200 )
            } else {
                return CGSize(width: 0, height: 0)
            }
        case .trendingQuestions:
            if questionList.count > 0 {
                return CGSize(width: 275, height: 250)
            } else {
                return CGSize(width: 0, height: 0)
            }
        case .playAndWin:
            if playAndWinList.count > 0 {
                return CGSize(width: 160, height: 180)
            } else {
                return CGSize(width: 0, height: 0)
            }
        case .yourVoice:
            if yourVoiceList.count > 0 {
                return CGSize(width: 250, height: 250)
            } else {
                return CGSize(width: 0, height: 0)
            }
        case .topRatedArticles:
            if ratedArticleList.count > 0 {
                if indexPath.row == 0 {
                    return CGSize(width: 130, height: 164)
                }
                return CGSize(width: 278, height: 164)
            } else {
                return CGSize(width: 0, height: 0)
            }
        case .topDiscussions:
            if discussionList.count > 0 {
                return CGSize(width: 260, height: 270)
            } else {
                return CGSize(width: 0 , height: 0)
            }
        }

        // return CGSize(width: UIScreen.main.bounds.size.width, height: heightForView)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //footerView
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let sectionView = hotTopicDetailCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionView", for: indexPath) as! HomeHeaderCollectionReusableView
            
//            let defaultSectionNames =  ["\(hotTopicName) Predictions","\(hotTopicName) Questions","Competition","\(hotTopicName) Voice","","\(hotTopicName) Discussions"]
            let boldSectionNames = ["Predictions", "Questions", "Competition", "Voice", "", "Discussions"]
            let defaultSectionNames = ["Popular Predictions","Trending Questions","Competition","Your Voice","","Top Discussions"]
            if let index = indexPath.first {
                sectionView.viewMoreButton.tag = index
                sectionView.viewMoreButton.addTarget(self, action: #selector(viewMoreButtonTapped(_:)), for: .touchUpInside)
                sectionView.headerLabel.attributedText = Common.shared.attributedText(withString: defaultSectionNames[index], boldString: boldSectionNames[index], font: Common.shared.getFont(type: .regular, size: 15))
                if let section: HotTopicSectionType = HotTopicSectionType(rawValue: index) {
                    switch section {
                    case .popularPredictions:
                        print("in case")
                        sectionView.headerLabel.textColor = .black
                        sectionView.viewMoreButton.borderColor = BLUE_COLOR
                        sectionView.viewMoreButton.setTitleColor(BLUE_COLOR, for: .normal)
                        
                    case .trendingQuestions:
                        print("in case")
                        sectionView.headerLabel.textColor = .black
                        sectionView.viewMoreButton.borderColor = BLUE_COLOR
                        sectionView.viewMoreButton.setTitleColor(BLUE_COLOR, for: .normal)
                        
                    case .playAndWin:
                        sectionView.headerLabel.textColor = UIColor.white
                        sectionView.viewMoreButton.borderColor = UIColor.white
                        sectionView.viewMoreButton.setTitleColor(UIColor.white, for: .normal)
                        
                    case .yourVoice:
                        sectionView.viewMoreButton.setTitle("VIEW MORE", for: .normal)
                        sectionView.headerLabel.textColor = .black
                        sectionView.viewMoreButton.borderColor = BLUE_COLOR
                        sectionView.viewMoreButton.setTitleColor(BLUE_COLOR, for: .normal)
                        
                    case .topRatedArticles:
                        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 0)
                        sectionView.frame.size.height = 0
                        sectionView.headerLabel.textColor = .black
                        sectionView.viewMoreButton.borderColor = BLUE_COLOR
                        sectionView.viewMoreButton.setTitleColor(BLUE_COLOR, for: .normal)
                        
                    case .topDiscussions:
                        sectionView.viewMoreButton.setTitle("VIEW MORE", for: .normal)
                        sectionView.headerLabel.textColor = .black
                        sectionView.viewMoreButton.borderColor = BLUE_COLOR
                        sectionView.viewMoreButton.setTitleColor(BLUE_COLOR, for: .normal)
                        
                    }
                }
            }
            return sectionView
        case JEKCollectionElementKindSectionBackground:
            DLog(message: "set background for section")
            let backgroundView = hotTopicDetailCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionBackgroundImageView", for: indexPath) as! HomeBackgroundCollectionReusableView
            if let index = indexPath.first {
                if let section: HomeSectionType = HomeSectionType(rawValue: index) {
                    switch section {
                    case .playAndWin:
                        backgroundView.backgroundImageView.image = UIImage(named: "PlayAndWinBGImage")
                    case .topRatedArticles:
                        if ratedArticleList.isEmpty {
                            backgroundView.backgroundImageView.image = nil
                        } else {
                            backgroundView.backgroundImageView.image = UIImage(named: "TopRatedArticlesGradient")
                        }
                        
//                        backgroundView.backgroundImageView.image = UIImage(named: "TopRatedArticlesGradient")
                    default:
                        backgroundView.backgroundImageView.image = nil
                    }
                }
            }
            return backgroundView
            
        default:
            let footerView = hotTopicDetailCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerView", for: indexPath)
            footerView.backgroundColor = UIColor.groupTableViewBackground
            //footerView.backgroundColor = .blue
            return footerView
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let section = HotTopicSectionType(rawValue: section) else { return layout.sectionInset }
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
        guard let section = HotTopicSectionType(rawValue: section) else { return CGSize(width: 0, height: 0) }
        switch section {
        case .popularPredictions:
            return layout.headerReferenceSize
            /*if predictionList.count > 0 {
                return layout.headerReferenceSize
            } else {
                return CGSize(width: 0, height: 0)
            }*/
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
        guard let section = HotTopicSectionType(rawValue: section) else { return CGSize(width: 0, height: 0) }
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = heightForView - (scrollView.contentOffset.y + heightForView)
        let height = min(max(y, 0), 400)
       // let height = min(max(y, 60), 400)  this is for when navigation bar is translucent

        collapsableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height - 25)

        var frame = collapsLabel.frame
        frame.origin.y = height - heightForView + labelYAxis + 25
        collapsLabel.frame = frame
        
        var frame1 = buttonView.frame
        //frame1.origin.y = height - heightForView + buttonYAxis
        frame1.origin.y = collapsLabel.frame.origin.y + collapsLabel.frame.size.height
        buttonView.frame = frame1
        
        // this is for when navigation bar is translucent
        
        /*if height < 72 {
            imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        } else {
            imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height - 25)
        }*/
        
    }
}

//MARK :- APIs
extension HotTopicDetailViewController {
//    "user_id:5149
//    topic_id:1
//    is_follow:1/0"
    func followTopic(sender: UIButton) {
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            let params = ["user_id": USERID,
                          "topic_id":topicId,
                          "is_follow":isFollow ? 1 : 0] as [String : Any]
            Service.sharedInstance.request(api: API_COMMON_FOLLOW_TOPIC, type: .post, parameters: params, complete: { (response) in
                do {
                    let resp = try decoder.decode(StatusResponse.self, from: response as! Data)
                    if resp.status ?? false {
                        Loader.hide(for: self.view, animated: true)
                        if self.isFollow {
                            sender.setTitle("Following", for: .normal)
                        } else {
                            sender.setTitle("Follow", for: .normal)
                        }
                        if let delegate = self.delegate {
                            delegate.reloadTopicListData()
                        }
                        self.getTopicData()
                        self.hotTopicDetailCollectionView.reloadData()
                    } else {
                        Loader.hide(for: self.view, animated: true)
                        self.showAlert(message: "Something went wrong.")
                    }
                } catch {
                    Loader.hide(for: self.view, animated: true)
                    DLog(message: "\(error.localizedDescription)")
                    self.showAlert(message: error.localizedDescription)
                }
            }) { (error) in
                Loader.hide(for: self.view, animated: true)
                DLog(message: "\(error)")
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
}

//MARK:- Refresh Delegates

//for prediction and questions
extension HotTopicDetailViewController: RefreshCounts {
    func refreshComments(index: Int, isDelete: Bool, section: Int) {
        guard let type: HotTopicSectionType = HotTopicSectionType(rawValue: section) else { return }
        switch type {
        case .popularPredictions:
            let cell = hotTopicDetailCollectionView.cellForItem(at: IndexPath(item: index, section: section)) as! PredictionCollectionViewCell
            let totalVotes = Common.shared.getCommentIntValue(string: predictionList[index].total_votes)
            var totalComments = Common.shared.getCommentIntValue(string: predictionList[index].total_comments)
            
            totalComments = isDelete ? totalComments - 1 : totalComments + 1
            
            predictionList[index].total_comments = "\(totalComments)"
            cell.predictionDetailLabel.text = "\(totalVotes) \(totalVotes > 1 ? "VOTES" : "VOTE") \(totalComments) \(totalComments > 1 ? "COMMENT" : "COMMENTS" )"
            
        case .trendingQuestions:
            
            let cell = hotTopicDetailCollectionView.cellForItem(at: IndexPath(item: index, section: section)) as! TrendingCollectionViewCell
            
            let totalVotes = Common.shared.getCommentIntValue(string: questionList[index].total_votes)
            var totalComments = Common.shared.getCommentIntValue(string: questionList[index].total_comments)
            
            totalComments = isDelete ? totalComments - 1 : totalComments + 1
            questionList[index].total_comments = "\(totalComments)"
            
            cell.infoLabel.text = "\(totalVotes) \(totalVotes > 1 ? "VOTES" : "VOTE") \(totalComments) \(totalComments > 1 ? "COMMENT" : "COMMENTS" )"
        default:
            DLog(message: "no case")
        }
    }
    
    func refreshVotes(index: Int, section: Int) {
        guard let type: HotTopicSectionType = HotTopicSectionType(rawValue: section) else { return }
        switch type {
        case .popularPredictions:
            let cell = hotTopicDetailCollectionView.cellForItem(at: IndexPath(item: index, section: section)) as! PredictionCollectionViewCell
            var totalVotes = Common.shared.getCommentIntValue(string: predictionList[index].total_votes)
            totalVotes += 1
            predictionList[index].total_votes = "\(totalVotes)"
            
            let totalComments = Common.shared.getCommentIntValue(string: predictionList[index].total_comments)
            
            cell.predictionDetailLabel.text = "\(totalVotes) \(totalVotes > 1 ? "VOTES" : "VOTE") \(totalComments) \(totalComments > 1 ? "COMMENT" : "COMMENTS" )"
            
        case .trendingQuestions:
            let cell = hotTopicDetailCollectionView.cellForItem(at: IndexPath(item: index, section: section)) as! TrendingCollectionViewCell
            
            var totalVotes = Common.shared.getCommentIntValue(string: questionList[index].total_votes)
            totalVotes += 1
            questionList[index].total_votes = "\(totalVotes)"
            
            let totalComments = Common.shared.getCommentIntValue(string: questionList[index].total_comments)
            cell.infoLabel.text = "\(totalVotes) \(totalVotes > 1 ? "VOTES" : "VOTE") \(totalComments) \(totalComments > 1 ? "COMMENT" : "COMMENTS" )"
        default:
            DLog(message: "no case")
        }
    }
    
    
}

extension HotTopicDetailViewController: WallDelegate {
    func refreshCardCount(deleted: Bool, index: Int) {
        
    }
    
    func refreshVoteCount(index: Int, totalVotes: Int) {
        getTopicData()
        let indexPath = IndexPath(item: index, section: 5)
        hotTopicDetailCollectionView.cellForItem(at: indexPath)

//        let cell = hotTopicDetailCollectionView.cellForItem(at: IndexPath(item: index, section: 5)) as! TrendingCollectionViewCell
//        let indexPath = NSIndexPath()
//        cell.infoLabel.text = "\(totalVotes) \(totalVotes > 1 ? "VOTES" : "VOTE")"
    }
}

extension HotTopicDetailViewController: RatedArticleDetailDelegate{
    
    func refreshVotesCount(index: Int, count: Int) {
        setCollectionViewLayout()
        registerCells()
        getTopicData()
    }
}
extension HotTopicDetailViewController: BlogRefreshCountDelegate{
    func refreshCommentCount(commentCount: Int) {
        setCollectionViewLayout()
        registerCells()
        getTopicData()
    }
    
    func refreshLikeCount(likesCount: Int) {
        setCollectionViewLayout()
        registerCells()
        getTopicData()
    }
    
    
}
