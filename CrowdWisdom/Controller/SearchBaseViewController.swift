//
//  SearchBaseViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 06/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class SearchBaseViewController: NavigationBaseViewController, UISearchBarDelegate {

    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    lazy var searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchButton()
    }
    
    func setSearchBar() {
        searchBar.returnKeyType = .done
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.alpha = 0.0
    }
    
    func setSearchButton(){
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        let searchNavigationBarButton = UIBarButtonItem(customView: searchButton)
        self.navigationItem.rightBarButtonItem = searchNavigationBarButton
        setSearchBar()
    }
    
    @objc func searchButtonPressed() {
        UIView.animate(withDuration: 0.5, animations: {
    
        }) { (finish) in
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.titleView = self.searchBar
            self.searchBar.alpha = 0.0
            
            UIView.animate(withDuration: 0.5, animations: {
                self.searchBar.alpha = 1.0
            }, completion: { (finished) in
                self.searchBar.becomeFirstResponder()
            })
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.alpha = 0.0
        }) { (finish) in
            self.setSearchButton()
            self.searchBar.becomeFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}
