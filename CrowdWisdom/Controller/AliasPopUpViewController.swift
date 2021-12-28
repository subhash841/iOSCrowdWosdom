//
//  AliasPopUpViewController.swift
//  CrowdWisdom
//
//  Created by sunday on 12/4/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import PopupDialog

protocol AliasPopUpDelegate {
    func updateData(with aliasName: String)
}

class AliasPopUpViewController: UIViewController {

    var isEdit = false
    
    var delegate: AliasPopUpDelegate?
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var aliastableView: UITableView!
    
    private var firstGradientColor: UIColor = UIColor(red:0.28, green:0.16, blue:0.57, alpha:1.0)
    private var secondGradientColor: UIColor = UIColor(red:0.03, green:0.63, blue:0.74, alpha:1.0)
    
    //MARK:-  Load View
    override func viewDidLoad() {
        super.viewDidLoad()

        aliastableView.register(UINib(nibName: "AliesCell", bundle: nil), forCellReuseIdentifier: "AliesCell")
        aliastableView.tableFooterView = UIView()
        headerView.backgroundColor = BLUE_COLOR

    }
    
    //MARK:-  Validation
    
    private func validateAndCallApi() {
        let aliasName = getInputedAliasName()
        
        if isEdit {
            if Common.shared.getAliasname() == aliasName {
                self.dismiss(animated: true, completion: nil)
            } else {
                if aliasName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
                    self.showAlert(message: "Enter Alias name like John321")
                    return
                }
                
                if aliasName.count > 10 {
                    self.showAlert(message: "Please enter less than 10 character for alias.")
                    return
                }
                
                // call API pass aliasName
                sendUserDetailsToServer(aliasname: aliasName)
            }
        } else {
            if aliasName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
                showAlert(message: "Enter Alias name like John321")
                return
            }
            
            if aliasName.count > 10 {
                self.showAlert(message: "Please enter less than 10 character for alias.")
                return
            }
            // call API pass aliasName
            sendUserDetailsToServer(aliasname: aliasName)
        }
    }
    
    private func getInputedAliasName() -> String {
        let index = IndexPath(row: 0, section: 0)
        let cell = aliastableView.cellForRow(at: index) as! AliesCell
        return cell.typeTextField.text ?? ""
    }
    
    //MARK:-  API and Populate data

    private func sendUserDetailsToServer(aliasname: String) {
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            Service.sharedInstance.editUserProfile(with: aliasname, partyAffiliation: "", location: "") { (success, responseData) in
                if success {
                    // do parsing
                    self.populateData(with: responseData)
                } else {
                    // error
                    print("error\(responseData)")
                }
                Loader.hide(for: self.view, animated: true)
            }
            
        }else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    private func populateData(with response: Any) {
        do {
            let topics = try decoder.decode(CreateBlogModel.self, from: response as! Data)
            if let status = topics.status, status == true {
                // success go to next view
                Common.shared.addKeyToInfo(key: "alias", value: getInputedAliasName())
                if let delegate = self.delegate {
                    delegate.updateData(with: getInputedAliasName())
                }
                
                self.showAlert(message: topics.message ?? "Profile updated successfully!") {
                    self.dismiss(animated: true, completion:nil) // dismiss popup
                }
            } else {
                self.showAlert(message: topics.message ?? "Please try again")
            }
        } catch {
            DLog(message: error)
            self.showAlert(message: error.localizedDescription)
        }
    }

    //MARK:-  Button Action
    @IBAction func submitButtonAction(_ sender: Any) {
        view.endEditing(true)
        
        validateAndCallApi()
    }
    
}

//MARK:-  Table View delegate and datasource

extension AliasPopUpViewController: UITableViewDelegate,UITableViewDataSource {
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AliesCell", for: indexPath) as! AliesCell
        cell.downArrowImageView.isHidden = true
        cell.typeTextField.delegate = cell
        cell.typeTextField.keyboardType = .asciiCapable
        cell.typeTextField.becomeFirstResponder()
        if isEdit {
            cell.typeTextField.text = Common.shared.getAliasname()
        } else {
            cell.typeTextField.placeholder = "Eg. John321"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
