//
//  CreatePredictionViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 11/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class CreatePredictionViewController: NavigationBaseViewController {

    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var predictionTableView: UITableView!
    @IBOutlet weak var predictionTableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        // Do any additional setup after loading the view.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        predictionTableViewHeight.constant = predictionTableView.contentSize.height
        
    }
    
    deinit {
        predictionTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    func setUI() {
        predictionTableView.register(UINib(nibName: "PredictionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "predictionHeader")
        predictionTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.setupLeftBarButton(isback: true)
    }
}

extension CreatePredictionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "partyCell", for: indexPath) as! AddPredictionTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = predictionTableView.dequeueReusableHeaderFooterView(withIdentifier: "predictionHeader") as! PredictionHeaderView
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0
        }
        return 25
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
}
