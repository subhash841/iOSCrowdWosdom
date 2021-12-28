//
//  CompetitionDetailViewController.swift
//  CrowdWisdom
//
//  Created by sunday on 12/5/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class CompetitionDetailViewController: NavigationBaseViewController {

    //var tempIDs = ["10","8","7","5","4"]

    @IBOutlet weak var questionNumberLbl: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextPreviousView: UIView!
    @IBOutlet weak var competitonCollectionView: UICollectionView!

    var currentPage: Int?
    var competitionId: String?
    var questionIds = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLeftBarButton(isback: true)
        competitonCollectionView.register(UINib(nibName: "CompetitionDetailCell", bundle: nil), forCellWithReuseIdentifier: "CompetitionDetailCell")
        setUI()
    }
    
    private func setUI() {
        currentPage = 0
        
        if questionIds.count > 1{
            questionNumberLbl.text = "Question 1/\(questionIds.count)"
            previousButton.isHidden = true
            nextButton.isHidden = false
        } else if questionIds.count == 1 {
            questionNumberLbl.text = "Question 1/\(questionIds.count)"
            previousButton.isHidden = true
            nextButton.isHidden = true
        } else {
            questionNumberLbl.text = ""
            previousButton.isHidden = true
            nextButton.isHidden = true
        }
        nextPreviousView.addGradientToView()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCommentCount),
            name: NSNotification.Name(rawValue: UpdateCommentNotification),
            object: nil)
    }
    
    //MARK:- Notification center
    
    @objc func updateCommentCount(notification: NSNotification){
        //do stuff
        competitonCollectionView.reloadData()
    }
    
    //MARK:- Button Actions
    
    @IBAction func previousButtonAction(_ sender: Any) {
        if let currentIndex = currentPage,  currentIndex >= 1 {
            let indexpath = IndexPath(item: currentIndex - 1, section: 0)
            competitonCollectionView.scrollToItem(at: indexpath, at: .left, animated: true)
            competitonCollectionView.reloadItems(at: [indexpath])
        }
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        if let currentIndex = currentPage,  currentIndex < questionIds.count - 1 {
            let indexpath = IndexPath(item: currentIndex + 1, section: 0)
            competitonCollectionView.scrollToItem(at: indexpath, at: .right, animated: true)
            competitonCollectionView.reloadItems(at: [indexpath])
        }
    }
    
}

//MARK:-  CollectioView Delegate and Datasource

extension CompetitionDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if questionIds.count > 0 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if questionIds.count > 0 {
            return questionIds.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompetitionDetailCell", for: indexPath) as! CompetitionDetailCell
        cell.registerCell()
        cell.delegate = self
        cell.competitionId = competitionId
        cell.getDetailsData(for: questionIds[indexPath.row])
        cell.scrollToTop()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-(80+35))
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setPageNumber(for: scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        setPageNumber(for: scrollView)
    }
    
    private func setPageNumber(for scrollView: UIScrollView) {
        
        var page: Int = Int(scrollView.contentOffset.x/competitonCollectionView.frame.size.width)
        currentPage = page
        page = page + 1
        questionNumberLbl.text = "Question \(page)/\(questionIds.count)"
        if page == 1 && questionIds.count > 1 {
            previousButton.isHidden = true
            nextButton.isHidden = false
        } else if Int(page) == questionIds.count {
            previousButton.isHidden = false
            nextButton.isHidden = true
        } else if page == 1 && questionIds.count == 1{
            previousButton.isHidden = true
            nextButton.isHidden = true
        } else {
            previousButton.isHidden = false
            nextButton.isHidden = false
        }
    }
}

//MARK:-  Competition Details Cell Delegate
extension CompetitionDetailViewController: competitionDetailDelegate {
    func setNointernetState() {
        setNoConnectionState()
    }
    
    func addNoDataState() {
        self.setNoDataState()
    }
}
