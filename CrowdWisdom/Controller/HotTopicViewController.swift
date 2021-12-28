//
//  HotTopicViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 06/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
enum Type: String {
    case hotTopic = "HotTopic"
    case trendingGames = "TrendingGames"
}

protocol HotTopicDelegate {
    func hideTopicView()
    func showTopicView()
}

protocol SearchHotTopicDelegate {
    func updateOffset(with off: Int)
}

class HotTopicViewController: UIViewController {

    var isSearchView = false
    var first = true
    @IBOutlet weak var hotTopicCollectionView: UICollectionView!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var viewMoreButton: NSButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var delegate: HotTopicDelegate?
    var searchDelegate: SearchHotTopicDelegate?
    
    var hotTopicsList = [TopicData]()
    var offset = 0
    var isAvailable = "0"
    var isOnlyHotTopicView = Bool()
    var isOnSearch: Bool = false
    
    var type: Type = .hotTopic {
        didSet {
            switch type {
            case .hotTopic:
                 viewLabel.attributedText = Common.shared.attributedText(withString: "Hot Topics", boldString: "Topics", font: Common.shared.getFont(type: .regular, size: 15))
            case .trendingGames:
                viewLabel.attributedText = Common.shared.attributedText(withString: "Trending Games", boldString: "Games", font: Common.shared.getFont(type: .regular, size: 15))
                
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getTopics()
        viewMoreButton.isHidden = true
//        if isSearchView {
//            viewMoreButton.isHidden = true
//        } else {
//            viewMoreButton.isHidden = false
//        }
    }
    
    func reloadTopicData() {
        offset = 0
        getTopics()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isOnSearch {
            backgroundImageView.isHidden = false
            self.view.backgroundColor = .clear
            viewLabel.textColor = .white
        } else {
            backgroundImageView.isHidden = true
            self.view.backgroundColor = .white
            viewLabel.textColor = .black
        }
    }
    //TODO:- view more action setup
    @IBAction func viewMoreButtonTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    //TODO:- follow button action setup
    @objc func followButtonTapped(_ sender: UIButton) {
        //action for follow button
        let topic = hotTopicsList[sender.tag]
        if let follow = topic.is_follow, follow == 0 {
            followTopic(topicId: topic.id, isFollow: 1, index: sender.tag)
        } else {
            followTopic(topicId: topic.id, isFollow: 0, index: sender.tag)
        }
        
    }

}

extension HotTopicViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DLog(message: hotTopicsList.count)
        return hotTopicsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HotTopicCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "hotTopicCell", for: indexPath) as! HotTopicCollectionViewCell
        switch type {
        case .hotTopic:
            cell.followButton.backgroundColor = UIColor.clear
            cell.followButton.borderWidth = 1
        case .trendingGames:
            cell.followButton.setTitleColor(UIColor.white, for: .normal)
            cell.followButton.backgroundColor = BLUE_COLOR
            cell.followButton.borderWidth = 0
        }
        if indexPath.row < hotTopicsList.count {
            let dict = hotTopicsList[indexPath.row]
            
            cell.topicLabel.text = (dict.topic ?? "").handleApostrophe()
            cell.topicImageView.kf.setImage(with: URL(string: dict.image ?? ""), placeholder: UIImage(named: "placeholder"))
            cell.followButton.addTarget(self, action: #selector(followButtonTapped(_:)), for: .touchUpInside)
            cell.followButton.tag = indexPath.row
            cell.followButton.isHidden = true
        }
        
        if isOnSearch {
            cell.cellView.layer.borderWidth = 0.5
            cell.cellView.layer.borderColor = UIColor.gray.cgColor
        }
//        if dict.is_follow == 1 {
//            cell.followButton.setTitle("Following", for: .normal)
//        } else {
//            cell.followButton.setTitle("Follow", for: .normal)
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row < hotTopicsList.count {
            let dict = hotTopicsList[indexPath.row]
            if let id = dict.id {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let hotTopicDetailVC = storyboard.instantiateViewController(withIdentifier: "HotTopicDetailViewController") as! HotTopicDetailViewController
                hotTopicDetailVC.hotTopicName = dict.topic ?? ""
                hotTopicDetailVC.topicId = id
                hotTopicDetailVC.delegate = self
                if let follow = dict.is_follow, follow == 1 {
                    hotTopicDetailVC.isFollow = true
                }
                self.navigationController?.pushViewController(hotTopicDetailVC, animated: true)
            } else {
                showAlert(message: "Oops! we are having problem with this topic, please try again later")
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if hotTopicsList.count - 2 == indexPath.row && isAvailable == "1" && !isSearchView{
            offset = offset + 10
            getTopics()
        }
    }
}

//MARK:- APIs
extension HotTopicViewController {
    func getTopics() {
        if NetworkStatus.shared.haveInternet() {
//            Loader.showAdded(to: self.view, animated: true)
            let params = ["user_id":USERID, "offset":offset] as [String : Any]
            print("param:\(params)")
            if offset == 0 { hotTopicsList.removeAll() }
            Service.sharedInstance.request(api: API_COMMON_TOPIC_LIST, type: .post, parameters: params, complete: { (response) in
                DLog(message: "\(response)")
                do {
                    let topic = try decoder.decode(TopicList.self, from: response as! Data)
                    self.isAvailable = topic.is_available ?? "0"
                    self.hotTopicsList += topic.data ?? [TopicData]()
//                    self.offset = self.hotTopicsList.count
                    if self.hotTopicsList.isEmpty {
                        self.delegate?.hideTopicView()
                    } else {
                        self.delegate?.showTopicView()
                    }
                    
                    if self.isAvailable == "1" && self.first {
                        self.first = false
                        self.searchDelegate?.updateOffset(with: self.offset)
                    }
                    
                    self.hotTopicCollectionView.reloadData()
                } catch {
                    DLog(message: "\(error)")
                    self.delegate?.hideTopicView()
                }
            }) { (error) in
                self.delegate?.hideTopicView()
                DLog(message: "\(error)")
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func followTopic(topicId: String?, isFollow: Int, index: Int) {
        if NetworkStatus.shared.haveInternet() {
            guard let id = topicId else { return }
            let params = ["user_id": USERID,
                          "topic_id":id,
                          "is_follow":isFollow] as [String : Any]
            Service.sharedInstance.request(api: API_COMMON_FOLLOW_TOPIC, type: .post, parameters: params, complete: { (response) in
                do {
                    let resp = try decoder.decode(StatusResponse.self, from: response as! Data)
                    if resp.status ?? false {
                        self.showAlert(message: resp.message ?? "Topic followed successfully")
                        self.hotTopicsList[index].is_follow = isFollow
                        self.hotTopicCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                    } else {
                        self.showAlert(message: "Something went wrong.")
                    }
                } catch {
                    DLog(message: "\(error)")
                }
            }) { (error) in
                DLog(message: "\(error)")
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
}

extension HotTopicViewController: HotTopicDetailsDelegate {
    func reloadTopicListData() {
        offset = 0
        getTopics()
    }
}
