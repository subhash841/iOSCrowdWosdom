//
//  NavigationSearchViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 06/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class NavigationSearchViewController: NavigationBaseViewController {
    
    lazy var searchButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let searchImageView = UIImageView(frame: CGRect(x: 20, y: 9.5, width: 20, height: 21))
        searchImageView.image = UIImage(named: "searchnavIcon")
        button.addSubview(searchImageView)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setSearchButton()
    }
    
    //MARK:- Internal Methods
    private func setSearchButton() {
        searchButton.addTarget(self, action: #selector(openSearchView), for: .touchUpInside)
        let searchButtonItem = UIBarButtonItem(customView:searchButton)
        
        self.navigationItem.rightBarButtonItem = searchButtonItem
    }
    
    //MARK:- Button Actions
    @objc func openSearchView() {
        let searchViewController = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.closeDrawer()
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
}
