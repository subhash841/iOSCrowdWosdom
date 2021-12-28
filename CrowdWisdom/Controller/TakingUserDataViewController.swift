//
//  TakingUserDataViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 05/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import CoreLocation
import TransitionButton

enum TextFieldType{
    case location
    case party
}
struct userFieldNames {
    let alias = "Alias"
    let partyAffiliation = "Party Affiliation"
    let location = "Location"
}

struct userFieldImages {
    let aliasImage = "aliesIcon"
    let partyAffiliationImage = "partyAffilicationIcon"
    let locationImage = "locationIcon"
   
}

struct userFieldPlaceholders {
    let aliasPlaceholder = "Eg. John321"
    let partyAffiliationPlaceholder = "Eg. BJP"
    let locationPlaceholder = "Eg. Maharashtra"
}

struct userDetails  {
    let name: String
    let image: String
    let placeholderText: String
}

class TakingUserDataViewController: NavigationBaseViewController {
    
    var isFromLogin = false
    
    @IBOutlet weak var aliesTableView: UITableView!
    @IBOutlet weak var submitButton: TransitionButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var politicalPartyTextField: UITextField!
    
    private var dataArray = [userDetails]()
    private var aliasName = ""; private var partyAffilliationName = ""; private var locationName = ""
    
    var locationManager = CLLocationManager()
    let picker = UIPickerView()
    var selectedTF = TextFieldType.party
    var politicalParties = ["BJP", "AAP", "AIC", "SP", "AIMIM"]
    var statesList = ["Andaman and Nicobar Islands",
                      "Andhra Pradesh",
                      "Arunachal Pradesh",
                      "Assam",
                      "Bihar",
                      "Chandigarh",
                      "Chhattisgarh",
                      "Dadra and Nagar Haveli",
                      "Daman and Diu",
                      "Delhi",
                      "Goa",
                      "Gujarat",
                      "Haryana",
                      "Himachal Pradesh",
                      "Jammu and Kashmir",
                      "Jharkhand",
                      "Karnataka",
                      "Kerala",
                      "Lakshadweep",
                      "Madhya Pradesh",
                      "Maharashtra",
                      "Manipur",
                      "Meghalaya",
                      "Mizoram",
                      "Nagaland",
                      "Orissa",
                      "Pondicherry",
                      "Punjab",
                      "Rajasthan",
                      "Sikkim",
                      "Tamil Nadu",
                      "Telangana",
                      "Tripura",
                      "Uttaranchal",
                      "Uttar Pradesh",
                      "West Bengal"]
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLeftBarButton(isback: true)
        registerCell()
        setData()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() == true {
            
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            print("Please turn on location services or GPS")
        }
        
        submitButton.layer.cornerRadius = 5
        submitButton.spinnerColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        //        locationManager.delegate = nil
        //        locationManager.stopUpdatingLocation()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addShadowToTableView()
    }
    
    //MARK:- Setup
    
    private func registerCell() {
        aliesTableView.register(UINib(nibName: "AliesCell", bundle: nil), forCellReuseIdentifier: "AliesCell")
        aliesTableView.register(UINib(nibName: "AliesSaveButtonCell", bundle: nil), forCellReuseIdentifier: "AliesSaveButtonCell")
    }
    
    private func addShadowToTableView() {
        let shadowSize : CGFloat = 4.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: aliesTableView.frame.size.width + shadowSize,
                                                   height: aliesTableView.frame.size.height + shadowSize))
        aliesTableView.layer.masksToBounds = false
        aliesTableView.layer.shadowColor = UIColor.black.cgColor
        aliesTableView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        aliesTableView.layer.shadowOpacity = 0.1
        aliesTableView.layer.shadowPath = shadowPath.cgPath
    }
    
    private func setData() {
        let firstCell = userDetails(name: userFieldNames().alias, image: userFieldImages().aliasImage, placeholderText: userFieldPlaceholders().aliasPlaceholder)
        if isFromLogin {
            dataArray.append(firstCell)
        } else {
            let secondCell = userDetails(name: userFieldNames().partyAffiliation, image: userFieldImages().partyAffiliationImage, placeholderText: userFieldPlaceholders().partyAffiliationPlaceholder)
            let thirdCell = userDetails(name: userFieldNames().location, image: userFieldImages().locationImage, placeholderText: userFieldPlaceholders().locationPlaceholder)
            dataArray.append(firstCell)
            dataArray.append(secondCell)
            dataArray.append(thirdCell)
        }
    }
    
    //MARK:- Validations
    
    private func validations() {
        
        for rowIndex in 0 ..< dataArray.count {
            let index = IndexPath(row: rowIndex, section: 0)
            let cell: AliesCell = aliesTableView.cellForRow(at: index) as! AliesCell
            switch rowIndex {
            case 0:
                aliasName = cell.getAliasText()
            case 1:
                partyAffilliationName = cell.getPartyAffilliationText()
            case 2:
                locationName = cell.getLocationText()
            default:
                print("nothing")
            }
        }
        
        guard aliasName != "" else {
            print("enter alias name")
            return
        }
        
        /*guard partyAffilliationName != "" else {
            print("select party name")
            return
        }
        
        guard locationName != "" else {
            print("select location")
            return
        }*/
    }
    
    //MARK:- API call
    
    private func submitUserDetail() {
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            let params = ["user_id":USERID, "alias":aliasName,"party_affiliation":partyAffilliationName,"location":locationName,"tnc_agree":"1"]
            print("param:\(params)")
            
            Service.sharedInstance.request(api: API_UPDATE_PROFILE, type: .post, parameters: params, complete: { (response) in
                do {
                    let topics = try decoder.decode(CreateBlogModel.self, from: response as! Data)
                    if let status = topics.status, status == true {
                        // success go to next view
                        self.showAlert(message: topics.message ?? "success")
                    } else {
                        self.showAlert(message: topics.message ?? "Please try again")
                    }
                } catch {
                    DLog(message: error)
                    self.showAlert(message: error.localizedDescription)
                }
                Loader.hide(for: self.view, animated: true)
                
            }) { (error) in
                DLog(message: error)
                Loader.hide(for: self.view, animated: true)
            }
            
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    //MARK:- Actions
    
    @objc func saveButtonAction() {
        validations()
        submitUserDetail()
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        //validate, register data, call API, and move to home view
        //        performSegue(withIdentifier: "goToHome", sender: self)
        
        submitButton.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(1) // 3: Do your networking task or background work here.
            
            DispatchQueue.main.async(execute: { () -> Void in
                // 4: Stop the animation, here you have three options for the `animationStyle` property:
                // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
                // .shake: when you want to reflect to the user that the task did not complete successfly
                // .normal
                self.submitButton.stopAnimation(animationStyle: .expand, completion: {
                    //MainTabBarController
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    //                    let homeViewVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    //                    let vc = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
                    let cardView = storyBoard.instantiateViewController(withIdentifier: "CardMainViewViewController")
                    self.navigationController?.pushViewController(cardView, animated: false)
                })
            })
        })
        
    }
    
}

//MARK:- TextField Delegate
extension TakingUserDataViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == locationTextField{
            selectedTF = TextFieldType.location
        } else{
            selectedTF = TextFieldType.party
        }
        setupPickerView(in: textField)
    }
    
    @objc func doneClick() {
        if selectedTF == TextFieldType.location{
            locationTextField.resignFirstResponder()
        } else{
            politicalPartyTextField.resignFirstResponder()
            
        }
    }
    
}


//MARK:- Picker View Setup, Delegates and Datasource
extension TakingUserDataViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setupPickerView(in textField: UITextField) {
        
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        textField.inputView = picker
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if selectedTF == TextFieldType.location{
            return statesList.count
        } else{
            return politicalParties.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectedTF == TextFieldType.location{
            return statesList[row]
        } else{
            return politicalParties[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedTF == TextFieldType.location{
            locationTextField.text = statesList[row]
        } else{
            politicalPartyTextField.text = politicalParties[row]
        }
    }
}

extension TakingUserDataViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("didFailWithError: \(error)");
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateToLocation: \(String(describing: locations.last))");
        self.locationManager.stopUpdatingLocation()
        if let currentLocation = locations.last{
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
                if error == nil && placemarks?.count ?? 0 > 0{
                    let placemark = placemarks?.last
                    print("\(placemark?.subThoroughfare ?? ""), \(placemark?.thoroughfare ?? ""), \(placemark?.postalCode ?? ""), \(placemark?.locality ?? ""), \(placemark?.administrativeArea ?? ""),\(placemark?.country ?? "")")
                    self.locationTextField.text = placemark?.administrativeArea
                } else{
                    print(error.debugDescription)
                }
            }
            
        }
    }
    
}

//MARK:- Table View Delegate And DataSource

extension TakingUserDataViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataArray.count > 0 {
            return dataArray.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == dataArray.count {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "AliesSaveButtonCell") as! AliesSaveButtonCell
            cell.selectionStyle = .none
            cell.saveButton.tag = indexPath.row
            cell.saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
            return cell
        } else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "AliesCell") as! AliesCell
            cell.selectionStyle = .none
            let dict = dataArray[indexPath.row]
            cell.nameLabel.text = dict.name
            cell.typeImageView.image = UIImage(named: dict.image)
            cell.typeTextField.placeholder = dict.placeholderText
            cell.typeTextField.tag = indexPath.row
            cell.typeTextField.delegate = cell
            
            if dict.name == userFieldNames().partyAffiliation {
                cell.showDropDownImage()
            } else {
                cell.hideDropDownImage()
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == dataArray.count {
            return 60
        }
        return 125
    }
}
