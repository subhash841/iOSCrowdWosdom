//
//  CardMainViewViewController.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 10/8/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import Floaty
import TwicketSegmentedControl
import PopupDialog

class CardMainViewViewController: NavigationBaseViewController {
    
    @IBOutlet weak var floatingButton: UIButton!
    @IBOutlet weak var floatingIcon: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var optionsCollectionView: UICollectionView!
    
    @IBOutlet weak var predictionNBlogSegmentControl: TwicketSegmentedControl!
    
    var floaty = Floaty()
    
    var selectedCellIndex: Int?
    var type: CardType!
    var isAlreadyEmpty = false
    var selectedSegment = 0
    
    var cardList = CardListViewControler()
    var isFirstTimeLoad = false
    var isLoadingCardData = false
    var topMenuList = ["COMPETITIONS","PREDICTIONS", "QUESTIONS", "YOUR VOICE","DISCUSSIONS", "FROM THE WEB"]
    var imageList = ["card-play-and-win", "card-prediction", "card-ask-question", "card-your-voice", "card-discussion","card-rated-article"]
    
    var redirectionType: CardType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Common.shared.getUserPoints()
        cardList = storyboard?.instantiateViewController(withIdentifier: "CardListViewControler") as! CardListViewControler
        countLabel.isHidden = true
        cardList.type = type
        self.setUI()
        floatingButton.clipsToBounds = true
        floatingButton.layer.cornerRadius = floatingButton.frame.size.width/2
        hideFloatingButton()
        self.setupLeftBarButton(isback: true)
        self.emptyStateAction = {
            print("Retry Tapped")
            if self.cardList.delegate != nil{
                self.cardList.getListData(with: self.cardList.type, offset: 0)
            }
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        if let cardType = type{
            switch cardType {
            case .competition:
                selectedCellIndex = 0
            case .prediction:
                selectedCellIndex = 1
            case .askQuestion:
                selectedCellIndex = 2
            case .voice:
                selectedCellIndex = 3
            case .discussion:
                selectedCellIndex = 4
            case .ratedArticle:
                selectedCellIndex = 5

            }
            
        }
        
        optionsCollectionView.register(UINib(nibName: "CardOptionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "optionCell")
        
        predictionNBlogSegmentControl.setSegmentItems(["Predictions","Your Voice"])
        predictionNBlogSegmentControl.delegate = self
        predictionNBlogSegmentControl.sliderBackgroundColor = BLUE_COLOR
        predictionNBlogSegmentControl.font = Common.shared.getFont(type: .regular, size: 15)
        
        predictionNBlogSegmentControl.segmentsBackgroundColor = UIColor.white
        
        predictionNBlogSegmentControl.backgroundColor = UIColor.clear
        predictionNBlogSegmentControl.defaultTextColor = BLUE_COLOR
        predictionNBlogSegmentControl.isSliderShadowHidden = true
        hideFloatingButton()
    }
    
    @objc func appMovedToBackground() {
        floaty.close()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        optionsCollectionView.dropShadow()

        if let index = selectedCellIndex {
            optionsCollectionView.scrollToItem(at:IndexPath(item:index, section: 0), at: .centeredHorizontally, animated: false)
        }

        if !isFirstTimeLoad {
            isFirstTimeLoad = true
            cardList.getListData(with: type, offset: 0)
            setFloatingMenu()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        optionsCollectionView.scrollToItem(at:IndexPath(item:0, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        floaty.close()
    }
    
    func setFloatingMenu(fromTab: Bool = false) {
        
        
        floaty = Floaty(frame: CGRect(x: Device.SCREEN_WIDTH - 48, y: (Int(countLabel.frame.origin.y) + Int(countLabel.frame.height) - 40), width: 40, height: 40))
        if fromTab {
            floaty = Floaty(frame: CGRect(x: Device.SCREEN_WIDTH - 48, y: (Int(countLabel.frame.origin.y) + Int(countLabel.frame.height) - 60), width: 40, height: 40))
        }
        floaty.sticky = true
        floaty.buttonColor = BLUE_COLOR
        floaty.itemTitleColor = BLUE_COLOR
        floaty.plusColor = UIColor.white
        floaty.openAnimationType = .pop
        floaty.overlayColor = UIColor.black.withAlphaComponent(0.6)

        
        floaty.addItem("Make Prediction", icon: UIImage(named: "fab-make-predictions")) { (_) in
            //go to prediction
            print("Make Prediction Tapped")
            if USERID == "0"{
                self.redirectionType = CardType.prediction
                self.setLoginPage()
            } else {
                self.goToAddPrediction()
            }
        }
        
        floaty.addItem("Questions", icon: UIImage(named:"fab-ask-question")) { (_) in
            print("Ask Question Tapped")
            if USERID == "0"{
                self.redirectionType = CardType.askQuestion
                self.setLoginPage()
            } else {
                self.goToAddQuestion()
            }
        }
        floaty.addItem("Create Blog", icon: UIImage(named: "fab-create-voice")) {_ in
            
            if USERID == "0"{
                self.redirectionType = CardType.voice
                self.setLoginPage()
            } else {
                self.goToAddBlog()
            }
        }
        
        floaty.addItem("Post Article", icon: UIImage(named: "fab-post-article")) { (_) in
            //go to prediction
            if USERID == "0"{
                self.redirectionType = CardType.ratedArticle
                self.setLoginPage()
            } else {
                self.goToAddArticle()
            }
        }
        
        floaty.addItem("Start Discussion", icon: UIImage(named: "fab-start-discussion")) { (_) in
            //go to prediction
            if USERID == "0"{
                self.redirectionType = CardType.discussion
                self.setLoginPage()
            }else
            {
                self.goToAddWall()
            }
        }

        

        floaty.items.forEach {
            $0.titleLabel.font = Common.shared.getFont(type: .medium, size: 14)
            $0.titleLabel.textAlignment = .center
            $0.titleLabel.backgroundColor = UIColor.white
            $0.titleLabel.cornerRadius = 5
        }

        self.view.addSubview(floaty)
        self.view.bringSubviewToFront(floaty)
        if NetworkStatus.shared.haveInternet() {
            floaty.isHidden = false
        } else {
            floaty.isHidden = true
        }
    }
    
    func setUI(){
        cardList.cardRefreshDelegate = self
        cardList.view.frame = cardView.frame
        self.addChild(cardList)
        self.cardView.addSubview(cardList.view)
    }
    
    @IBAction func floatingButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateBlogViewController") as! CreateBlogViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func hideFloatingButton() {
        floatingButton.isHidden = true
        floatingIcon.isHidden = true
    }
    
    private func showFloatingButton() {
        floatingButton.isHidden = false
        floatingIcon.isHidden = false
    }
    
}


extension CardMainViewViewController:RefreshCardCountDelegate{
    
    func refreshCount(countString: NSAttributedString, listCount: Int, noInternet: Bool, error: Bool) {
        self.hideEmptyStateView()
        
        if !noInternet || !error {
            isLoadingCardData = false
        }
        if noInternet{
            self.floaty.isHidden = true
            self.setNoInternetInfo(with: getNoDataInfoFrame())
            self.view.bringSubviewToFront(floaty)
        } else if error {
            self.setNoDataInfo(with: getNoDataInfoFrame())
            self.view.bringSubviewToFront(floaty)

        } else {
            if listCount == 0 {
                self.setNoDataInfo(with: getNoDataInfoFrame())
                self.view.bringSubviewToFront(floaty)

                if self.isAlreadyEmpty {
        
                }
                self.isAlreadyEmpty = true
            } else {
                self.hideEmptyStateView()
                self.hideNoDataInfo()
            }
            self.floaty.isHidden = false
        }
        countLabel.attributedText = countString
    }
    
    func toggleCountLabelVisibility() {
        //countLabel.isHidden = !countLabel.isHidden
    }
    
    func enableTabs(enable: Bool){
        predictionNBlogSegmentControl.isUserInteractionEnabled = enable
    }
    
    private func getNoDataInfoFrame() -> CGRect {
        var frame = self.cardView.frame
        frame.origin.y = self.cardView.frame.origin.y + 60
        frame.size.height = self.cardView.frame.size.height - 75
        return frame
    }
}

extension CardMainViewViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoadingCardData { return }
        if selectedCellIndex != indexPath.row{
            countLabel.text = ""
            collectionView.reloadData()
            selectedCellIndex = indexPath.row
            if indexPath.row == 0 {
                cardList.type = .competition
            } else if indexPath.row == 1 {
                cardList.type = .prediction
            } else if indexPath.row == 2 {
                cardList.type = .askQuestion
            } else if indexPath.row == 3 {
                cardList.type = .voice
            } else if indexPath.row == 4{
                cardList.type = .discussion
            } else if indexPath.row == 5{
                cardList.type = .ratedArticle
            }
            
            if let index = selectedCellIndex {
                optionsCollectionView.scrollToItem(at:IndexPath(item:index, section: 0), at: .centeredHorizontally, animated: false)
            }
            Common.shared.cardTypeAtList = cardList.type
            isLoadingCardData = true
            cardList.getListData(with: cardList.type, offset: 0)
        }
    }
}

extension CardMainViewViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "optionCell", for: indexPath) as! CardOptionCollectionViewCell
        if indexPath.row == selectedCellIndex {
            cell.optionLabel.textColor = BLUE_COLOR
            cell.lineLable.isHidden = false
        }else {
            cell.lineLable.isHidden = true
            cell.optionLabel.textColor = UIColor.gray
        }
        cell.optionLabel.text = topMenuList[indexPath.row]
        cell.optionImageView.image = UIImage(named: imageList[indexPath.row])?.withRenderingMode(.alwaysOriginal)
        //cell.optionImageView.image = UIImage(named: imageList[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        //cell.optionImageView.tintColor = .white
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topMenuList.count
    }
}

extension CardMainViewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let typeString = topMenuList[indexPath.row]
        let width = Common.shared.sizeOfString(string: typeString, constrainedToWidth: 150, font: UIFont(name: "Roboto-Medium", size: 13)!).width
        return CGSize(width: width + 10 , height: 65)
    }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellCount = CGFloat(topMenuList.count)
        
        //If the cell count is zero, there is no point in calculating anything.
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
            
            //20.00 was just extra spacing I wanted to add to my cell.
            let totalCellWidth = cellWidth*cellCount + 10.00 * (cellCount-1)
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
            
            if (totalCellWidth < contentWidth) {
                //If the number of cells that exists take up less room than the
                //collection view width... then there is an actual point to centering them.
                
                //Calculate the right amount of padding to center the cells.
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
            } else {
                //Pretty much if the number of cells that exist take up
                //more room than the actual collectionView width, there is no
                // point in trying to center them. So we leave the default behavior.
                return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            }
        }
        
        return UIEdgeInsets.zero
    }*/
    
}

extension CardMainViewViewController: TwicketSegmentedControlDelegate {
    
    func didSelect(_ segmentIndex: Int) {
        hideNoDataInfo()
        countLabel.attributedText = NSAttributedString(string: "")
        if selectedSegment != segmentIndex{
            hideNoDataInfo()
            selectedSegment = segmentIndex
            if segmentIndex == 0 {
                cardList.type = .prediction
                cardList.getListData(with: .prediction, offset: 0)
                hideFloatingButton()
            } else {
                cardList.type = .voice
                cardList.getListData(with: .voice, offset: 0)
                showFloatingButton()
            }
        }
    }
    
    
}

extension CardMainViewViewController: AddQuestionDelegate {
    func refreshCardList() {
        if type == CardType.askQuestion {
            cardList.getListData(with: CardType.askQuestion, offset: 0)
        }
    }
}
extension CardMainViewViewController: AddWallDelegate {
    func refreshWallList() {
        if type == CardType.discussion {
            cardList.getListData(with: CardType.discussion, offset: 0)
        }
    }
}
extension CardMainViewViewController: AddArticleDelegate {
    func refreshArticleList() {
        if type == CardType.ratedArticle {
            cardList.getListData(with: CardType.ratedArticle, offset: 0)
        }
    }
    
}

//FIXME:- Add Delegate
extension CardMainViewViewController: CreateBlogDelegate {
    func createBlog() {
        self.dismiss(animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateBlogViewController") as! CreateBlogViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CardMainViewViewController: LoginViewDelegate {
    func loginSuccessful() {
        guard let type = redirectionType else { return }
        
        switch type {
        case .prediction:
            goToAddPrediction()
        case .askQuestion:
            goToAddQuestion()
        case .ratedArticle:
            goToAddArticle()
        case .discussion:
            goToAddWall()
        case .voice:
            goToAddBlog()
        case .competition:
            DLog(message: "No case")
        }
    }
}

//MARK:- Redirection Methods

extension CardMainViewViewController {
    
    func setLoginPage() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.isFromAction = true
        vc.delegate = self
        let nvc = UINavigationController(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
    }
    
    func goToAddPrediction() {
        let questionVC = self.storyboard?.instantiateViewController(withIdentifier: "AddQuestionViewController") as! AddQuestionViewController
        questionVC.isMakePreduction = true
        //            questionVC.questionDelegate = self
        //            questionVC.type = CardType.askQuestion
        self.navigationController?.pushViewController(questionVC, animated: true)
    }
    
    func goToAddQuestion() {
        let questionVC = self.storyboard?.instantiateViewController(withIdentifier: "AddQuestionViewController") as! AddQuestionViewController
        questionVC.questionDelegate = self
        questionVC.isMakePreduction = false
        questionVC.type = CardType.askQuestion
        self.navigationController?.pushViewController(questionVC, animated: true)
    }
    
    func goToAddBlog() {
        Common.shared.getUserPoints()
//        let competitionPopup = CompetitionPopupViewController(nibName: "CompetitionPopupViewController", bundle: nil)
//        competitionPopup.delegate = self
//        competitionPopup.type = CardType.voice
//        competitionPopup.requiredPoints = 25
        
        let voicePopup = VoicePopUpViewController(nibName: "VoicePopUpViewController", bundle: nil)
        voicePopup.delegate = self
        let popup = PopupDialog(viewController: voicePopup,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        self.present(popup, animated: true, completion: nil)
    }
    
    func goToAddArticle() {
        let vc = CreateArticleViewController(nibName: "CreateArticleViewController", bundle: nil)
        vc.articleDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToAddWall() {
        let vc = CreateWallViewController(nibName: "CreateWallViewController", bundle: nil)
        vc.wallDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        print("Start Discussion Tapped")
    }
}
