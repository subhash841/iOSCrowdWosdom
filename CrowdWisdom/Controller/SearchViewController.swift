//
//  SearchViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 06/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class SearchViewController: NavigationSearchViewController {

    @IBOutlet weak var hotTopicHeight: NSLayoutConstraint!
    @IBOutlet weak var hotTopicView: UIView!
    @IBOutlet weak var featuredTopicTableView: UITableView!
    @IBOutlet weak var featuredTopicLabel: UILabel!
    @IBOutlet weak var featuredTopicLabelHeight: NSLayoutConstraint!
    
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 70, height: 20))
    
    var hotTopicViewController = HotTopicViewController()
    
    var featuredTopicsList = [TopicData]()
    var searchData = [SearchData]()
    
    var isAvailable = "0"
    
    var isSearchBarActive = false {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.hotTopicHeight.constant = self.isSearchBarActive ? 0 : 220
                self.featuredTopicLabelHeight.constant = self.isSearchBarActive ? 0 : 18
            }
        }
    }
    
    var offset: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hotTopicViewController = storyboard?.instantiateViewController(withIdentifier: "HotTopicViewController") as! HotTopicViewController
        setupLeftBarButton(isback: true)
        setupSearchBar()
        setHotTopicView()
        offset = 0
        self.searchCompletion = {
            self.isSearchBarActive = !self.isSearchBarActive
            self.featuredTopicTableView.reloadData()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
    
    func setHotTopicView() {
        hotTopicView.layer.masksToBounds = false
        hotTopicView.layer.shadowOffset = CGSize(width: 0, height: 3)
        hotTopicView.layer.shadowRadius = 1
        hotTopicView.layer.shadowOpacity = 0.5
        
        hotTopicViewController.view.frame = hotTopicView.frame
        hotTopicViewController.isOnSearch = true
        self.addChild(hotTopicViewController)
        hotTopicView.addSubview(hotTopicViewController.view)
        hotTopicViewController.isSearchView = true
        hotTopicViewController.searchDelegate = self
        //        view.layoutSubviews()
    }
    
    func setupSearchBar() {
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
        self.navigationItem.rightBarButtonItems = nil
        searchBar.placeholder = "Search For Latest Topics"
        searchBar.tintColor = UIColor.white

        searchBar.returnKeyType = .done
        searchBar.delegate = self
        searchBar.setTextColor(color: .white)
//        searchBar.layer.borderWidth = 1
//        searchBar.layer.borderColor = searchBar.barTintColor?.cgColor //orange
        searchBar.setTextFieldColor(color: .clear)
        searchBar.setPlaceholderTextColor(color: .lightGray)
        
        searchBar.setSearchImageColor(color: .white)
        searchBar.setTextFieldClearButtonColor(color: .white)
        let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as! UITextField
        textFieldInsideSearchBar.leftViewMode = UITextField.ViewMode.never
        self.navigationItem.titleView = searchBar
        
    }


}

//MARK:- Table View Delegates and Datasources

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchBarActive {
            return searchData.count
        } else {
            if featuredTopicsList.isEmpty {
                featuredTopicLabel.isHidden = true
            } else {
                featuredTopicLabel.isHidden = false
            }
            return featuredTopicsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FeaturedTopicCellTableViewCell = featuredTopicTableView.dequeueReusableCell(withIdentifier: "featuredTopicCell", for: indexPath) as! FeaturedTopicCellTableViewCell
        cell.selectionStyle = .none
        cell.followButton.isHidden = true
//        cell.imageView?.clipsToBounds = true
        if isSearchBarActive && searchData.count > indexPath.row {
            cell.topicLabel.text = searchData[indexPath.row].topic
            cell.topicLabel.font = Common.shared.getFont(type: .medium, size: 14)
            cell.imageWidth.constant = 36
            cell.topicImageView.kf.setImage(with: URL(string: searchData[indexPath.row].icon), placeholder: UIImage(named: "placeholder"))
        } else {
            if featuredTopicsList.count > indexPath.row {
                cell.imageWidth.constant = 36
                cell.topicLabel.text = featuredTopicsList[indexPath.row].topic
                cell.topicImageView.kf.setImage(with: URL(string: featuredTopicsList[indexPath.row].image ?? ""), placeholder: UIImage(named: "placeholder"))
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var id = String()
        var topicName = String()
        if isSearchBarActive {
            id = searchData[indexPath.row].id
            topicName = searchData[indexPath.row].topic
        } else {
            id = featuredTopicsList[indexPath.row].id ?? ""
            topicName = featuredTopicsList[indexPath.row].topic ?? ""
        }
        if topicName == NO_DATA { return }
        let hotTopicDetailVC = storyboard?.instantiateViewController(withIdentifier: "HotTopicDetailViewController") as! HotTopicDetailViewController
        hotTopicDetailVC.hotTopicName = topicName
        hotTopicDetailVC.topicId = id
        self.navigationController?.pushViewController(hotTopicDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isSearchBarActive && featuredTopicsList.count - 2 == indexPath.row && isAvailable == "1" {
            
            offset += 10
            getTopics()
            DLog(message: "feature cell will display \(offset)")
        }
    }
}

//MARK: - UISearchBar EXTENSION
extension UISearchBar {
    
    private func getViewElement<T>(type: T.Type) -> T? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func getSearchBarTextField() -> UITextField? {
        return getViewElement(type: UITextField.self)
    }
    
    func setTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }
    
    func setTextFieldColor(color: UIColor) {
        
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
            case .prominent, .default:
                textField.backgroundColor = color
            }
        }
    }
    
    func setPlaceholderTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
    
    func setTextFieldClearButtonColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            
//             if let clearButton = textField.value(forKey: "_clearButton")as? UIButton {
//
//               /* if let img3 = clearButton.image(for: .normal) {
//                    clearButton.isHidden = false
//                    let tintedClearImage = img3.transform(withNewColor: UIColor.white)
//                    clearButton.setImage(tintedClearImage, for: .normal)
//                    clearButton.setImage(tintedClearImage, for: .highlighted)
//                }else{
////                    clearButton.isHidden = true
//                }*/
//
//                let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
//                // Set the template image copy as the button image
//                clearButton.setImage(templateImage, for: .normal)
//                // Finally, set the image color
//                clearButton.tintColor = .red
//            }
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            [button setImage:[UIImage imageNamed:@"clear_button.png"] forState:UIControlStateNormal];
//            [button setFrame:CGRectMake(0.0f, 0.0f, 15.0f, 15.0f)]; // Required for iOS7
//            theTextField.rightView = button;
//            theTextField.rightViewMode = UITextFieldViewModeWhileEditing;
            let button = UIButton(type: .custom)
            let image = UIImage(named: "clear-button")
            button.setImage(image, for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
            textField.rightView = button
            textField.tintColor = .white
            textField.rightViewMode = UITextField.ViewMode.whileEditing
//            let button = textField.value(forKey: "clearButton") as! UIButton
//            if let image = button.imageView?.image {
//                button.setImage(image.transform(withNewColor: color), for: .normal)
//            }
        }
    }
    
    func setSearchImageColor(color: UIColor) {
        
        if let imageView = getSearchBarTextField()?.leftView as? UIImageView {
            imageView.image = imageView.image?.transform(withNewColor: color)
        }
    }
}



extension UIImage {
    
    func transform(withNewColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        
        color.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension SearchViewController: SearchHotTopicDelegate {
    func updateOffset(with off: Int) {
        
        self.offset += 10
        getTopics()
        DLog(message: "feature delegate offset : \(offset)")
    }
}

//MARK:- APIs
extension SearchViewController {
    func getTopics() {
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            let params = ["user_id":USERID, "offset":offset] as [String : Any]
            DLog(message: "feature params: \(params)")
            Service.sharedInstance.request(api: API_COMMON_TOPIC_LIST, type: .post, parameters: params, complete: { (response) in
                DLog(message: "feature \(response)")
                do {
                    let topic = try decoder.decode(TopicList.self, from: response as! Data)
                    self.isAvailable = topic.is_available ?? "0"
                    DLog(message: "feature before adding:\(self.featuredTopicsList.count)")
                    self.featuredTopicsList += topic.data ?? [TopicData]()
                    DLog(message: "feature after adding:\(self.featuredTopicsList.count)")
                    self.featuredTopicTableView.reloadData()
                } catch {
                    DLog(message: "\(error)")
                }
                Loader.hide(for: self.view, animated: true)
            }) { (error) in
                Loader.hide(for: self.view, animated: true)
                DLog(message: "\(error)")
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func searchTopic(with search: String) {
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            let params = ["user_id": USERID, "topic": search]
            Service.sharedInstance.request(api: API_COMMON_SEARCH, type: .post, parameters: params, complete: { (response) in
                do {
                    let result = try decoder.decode(SearchList.self, from: response as! Data)
                    self.searchData = result.data 
                    
                    if self.searchData.isEmpty {
                        let noRecords = SearchData(id: "", topic: NO_DATA, icon: "")
//                        noRecords.topic = "No Topic Found"
//                        noRecords.id = "0"
                        self.searchData.append(noRecords)
                    }
                    self.featuredTopicTableView.reloadData()

                } catch {
                    DLog(message: error)
                }
                Loader.hide(for: self.view, animated: true)
            }) { (err) in
                DLog(message: "\(err)")
                Loader.hide(for: self.view, animated: true)
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        if searchBar.text!.isEmpty {
//            searchTopic(with: "")
//        }
//
//        return isSearchBarActive
//    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchBarActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            isSearchBarActive = true
            self.isSearch = true
            searchTopic(with: searchText)
        } else {
            isSearchBarActive = false
            self.isSearch = false
            featuredTopicTableView.reloadData()
        }
    }
}
