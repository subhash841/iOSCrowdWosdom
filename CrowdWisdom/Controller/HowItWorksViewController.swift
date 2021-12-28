//
//  HowItWorksViewController.swift
//  CrowdWisdom
//
//  Created by sunday on 10/23/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class HowItWorksViewController: NavigationSearchViewController {
    
    @IBOutlet weak var startVotingButton: UIButton!
    
    @IBOutlet weak var dataView: UIView!
    
    struct titleStruct {
        var firstStep  = "Step 1 :Pay & Start Voting"
        var secondStep = "Step 2 :Vote to Participate in The Game"
        var thirdStep  = "Step 3 :Play The Game & Win Cash Prize"
    }
    struct ImageStruct {
        var firstStep  = "stepOne"
        var secondStep = "steptwo"
        var thirdStep  = "stepThree"
    }
    
    @IBOutlet weak var howItWorksTableView: UITableView!
    
    private var titles = [String]()
    private var images = [String]()
    
    var imageArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        howItWorksTableView.register(UINib(nibName: "HowItWorksTableViewCell", bundle: nil), forCellReuseIdentifier: "HowItWorksTableViewCell")
        
        setUI()
        setupTitleData()
        setupImagesData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        addGradientTonavigationBar()
    }
    
    private func setUI(){
        startVotingButton.layer.cornerRadius = 15
        dataView.layer.shadowColor = UIColor.lightGray.cgColor
        dataView.layer.shadowOpacity = 1
        dataView.layer.shadowOffset = CGSize.zero
        dataView.layer.shadowRadius = 2
        dataView.layer.cornerRadius = 5
    }
    
    private func setupTitleData() {
        let title = titleStruct()
        titles = [title.firstStep, title.secondStep, title.thirdStep]
    }
    
    private func setupImagesData() {
        let image = ImageStruct()
        images = [image.firstStep, image.secondStep, image.thirdStep]
    }
    
    @IBAction func startVotingBtnAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "CardMainViewViewController") as! CardMainViewViewController
        vc.type = CardType.competition
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

/*extension HowItWorksViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles .count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HowItWorksTableViewCell = howItWorksTableView.dequeueReusableCell(withIdentifier: "HowItWorksTableViewCell", for: indexPath) as! HowItWorksTableViewCell
        if indexPath.row == 0 {
            cell.statusLabel?.textColor = UIColor(red: 71.00/255.0, green: 42.00/255.0, blue: 145.00/255.0, alpha: 1.00)
        }else if indexPath.row == 1{
            cell.statusLabel?.textColor = UIColor(red: 255.00/255.0, green: 84.00/255.0, blue: 0/255.0, alpha: 1.00)
        }else if indexPath.row == 2{
            cell.statusLabel?.textColor = UIColor(red: 0.00/255.0, green:101.00/255.0, blue: 122.0/255.0, alpha: 1.00)
        }
       
        cell.statusLabel?.text = titles[indexPath.row]
        let yourImage: UIImage = UIImage(named: images[indexPath.row]) ?? UIImage()
        cell.statusImage?.image =  yourImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.frame = CGRect(x: 0 , y: 10, width: self.howItWorksTableView.frame.size.width, height: 30)
        label.textAlignment = NSTextAlignment.center
        label.text = "How It Works"
        label.textColor=UIColor.black
        label.font=UIFont.systemFont(ofSize: 20)
        view.addSubview(label)
        
        let labelBottom = UILabel()
        labelBottom.frame = CGRect(x: 10 , y: 45, width: self.howItWorksTableView.frame.size.width - 20 , height: 2)
        labelBottom.backgroundColor=UIColor.groupTableViewBackground
        view.addSubview(labelBottom)
        view.backgroundColor = UIColor.white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.groupTableViewBackground
        
        let startButton = UIButton()
        startButton.setTitle("Start Voting", for: .normal)
        startButton.setTitleColor(UIColor.white, for: .normal)
        startButton.backgroundColor = UIColor(red: 0.00/255.0, green:164.00/255.0, blue: 249.0/255.0, alpha: 1.00)
//        startButton.frame = CGRect(x: 0 , y: 10, width: 200, height: 40)
        startButton.layer.cornerRadius = 17.5
        startButton.titleLabel?.font =  UIFont.systemFont(ofSize: 14)

        footerView.addSubview(startButton)

        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: startButton,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: footerView,
                                     attribute: .top,
                                     multiplier: 1.0,
                                     constant: 15.0)
        
        let height = NSLayoutConstraint(item: startButton,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0,
                                        constant: 35.0)
        
        let width = NSLayoutConstraint(item: startButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 150.0)
        
        let centerHorizontally = NSLayoutConstraint(item: startButton,
                                                    attribute: .centerX,
                                                    relatedBy: .equal,
                                                    toItem: footerView,
                                                    attribute: .centerX,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
        
        let centerVertically = NSLayoutConstraint(item: startButton,
                                                  attribute: .centerY,
                                                  relatedBy: .equal,
                                                  toItem: footerView,
                                                  attribute: .centerY,
                                                  multiplier: 1.0,
                                                  constant: 0.0)
        
        NSLayoutConstraint(item: startButton,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 120.0).isActive = true
        
        NSLayoutConstraint(item: startButton,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 70.0).isActive = true
        
        NSLayoutConstraint.activate([centerHorizontally, centerVertically])

        footerView.addConstraint(top)
        footerView.addConstraint(height)
        footerView.addConstraint(width)
        NSLayoutConstraint.activate([top, height, width])
        
        
        
        //        startButton.addTarget(self, action: #selector(myClass.pressed(_:)), forControlEvents: .TouchUpInside)
        return footerView
    }
    
    // set height for footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
}*/

