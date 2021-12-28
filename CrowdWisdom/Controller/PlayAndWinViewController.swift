//
//  PlayAndWinViewController.swift
//  CrowdWisdom
//
//  Created by  user on 10/8/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import TransitionButton

enum GameType: String {
    case premium = "Premium"
    case free = "Free"
}

enum GameCategory: String {
    case prediction = "Prediction"
    case forecast = "Forecast"
}


class PlayAndWinViewController: NavigationBaseViewController {

    @IBOutlet weak var hotTopicView: UIView!
    @IBOutlet weak var gamesTableView: UITableView!
    @IBOutlet weak var seeMoreButton: TransitionButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    lazy var hotTopicViewController = storyboard?.instantiateViewController(withIdentifier: "HotTopicViewController") as! HotTopicViewController
    
    var offset: Int = 0
    var listData = [ListData]()
    
//    lazy var predictionOverviewVC: PredictionOverviewViewController = {
//        return storyboard?.instantiateViewController(withIdentifier: "PredictionOverviewViewController") as! PredictionOverviewViewController
//
//    }()
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        gamesTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        setupLeftBarButton(isback: true)
        setHotTopicView()
        getPlayAndWinList(with: offset)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

    }
    
    deinit {
        if gamesTableView != nil{
            gamesTableView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tableViewHeight.constant = gamesTableView.contentSize.height
    }
    
    func setHotTopicView() {
        print("frame:- \(hotTopicView.frame)")
        hotTopicViewController.view.frame = CGRect(x: 0, y: 0, width: hotTopicView.frame.width, height: hotTopicView.frame.height)
        hotTopicViewController.type = .hotTopic
        self.addChild(hotTopicViewController)
        hotTopicView.addSubview(hotTopicViewController.view)//(, at: 0)
        hotTopicViewController.didMove(toParent: self)
    }
    
    @objc func playNowButtonTapped(at button: NSButton) {
        if button.tag % 2 == 0 {
            self.performSegue(withIdentifier: "goToPredictionOverview", sender: self)
        } else {
            self.performSegue(withIdentifier: "goToGameOverview", sender: self)
        }
        
//        self.navigationController?.pushViewController(predictionOverviewVC, animated: true)
    }
    
    @IBAction func seeMoreButtonTapped(_ sender: TransitionButton) {
        offset += 1
       
        getPlayAndWinList(with: offset)
    }
    
    
}
extension PlayAndWinViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
        cell.selectionStyle = .none
        cell.playNowButton.addTarget(self, action: #selector(playNowButtonTapped(at:)), for: .touchUpInside)
        cell.playNowButton.tag = indexPath.row
        cell.gameNameLabel.text = listData[indexPath.row].title
        
        guard let imageURL = URL(string: listData[indexPath.row].image ?? "") else { return cell }
        cell.gameImageView.kf.setImage(with: imageURL)
        return cell
    }
    
    
    
}
extension PlayAndWinViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK:- API
extension PlayAndWinViewController {
    func getPlayAndWinList(with offset: Int) {
        if NetworkStatus.shared.haveInternet() {
            //TODO:- Change API
            if offset > 0 { self.seeMoreButton.startAnimation() } else { Loader.showAdded(to: self.view, animated: true) }
            
            let api = API_PREDICTIONS_LIST
            Service.sharedInstance.request(api: api, type: .post, parameters: ["offset":offset], complete: { (response) in
                do {
                    let prediction = try decoder.decode(ListType.self, from: response as! Data)
                    self.listData += prediction.data ?? [ListData]()
                    self.gamesTableView.reloadData()
                    
                } catch {
                    DLog(message: error)
                    self.showAlert(message: error.localizedDescription)
                }
                if offset > 0 { self.seeMoreButton.stopAnimation() } else { Loader.hide(for: self.view, animated: true) }
                
                
            }) { (error) in
                DLog(message: error)
                if offset > 0 { self.seeMoreButton.stopAnimation() } else { Loader.hide(for: self.view, animated: true) }
            }
        } else {
            self.showAlert(message: NO_INTERNET)

        }
    }
}
