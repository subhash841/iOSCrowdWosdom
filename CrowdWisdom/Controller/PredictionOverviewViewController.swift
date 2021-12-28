//
//  PredictionOverviewViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 10/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class PredictionOverviewViewController: NavigationBaseViewController {

    @IBOutlet weak var predictionNameLabel: UILabel!
    @IBOutlet weak var currentPrediction: UILabel!
    @IBOutlet weak var predictionTableView: UITableView!
    
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        predictionTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    @IBAction func predictNowButtonTapped(_ sender: Any) {
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tableViewHeight.constant = predictionTableView.contentSize.height
    }
    
    deinit {
        predictionTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    func setUI(){
        self.setupLeftBarButton(isback: true)
    }
}

//MARK:- Table View Delegate and Datasource
extension PredictionOverviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PartyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "partyCell", for: indexPath) as! PartyTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    
}
