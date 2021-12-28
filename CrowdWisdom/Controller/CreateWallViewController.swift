//
//  CreateWallViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 23/11/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import Photos
import RSSelectionMenu

protocol AddWallDelegate {
    func refreshWallList()
}

class CreateWallViewController: NavigationBaseViewController, UINavigationControllerDelegate {

    @IBOutlet weak var titleView: UITextView!
    @IBOutlet weak var topicTextField: UITextField!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var topicLabel: UILabel!
    
    var topicListData = [TopicData]()
    var selectedTopicStringArray = [String]()
    var selectedTopicIdArray = [String]()
    
    var selectedTopic: TopicData?
    var wallDelegate: AddWallDelegate?
    
    var wallImageData = Data()
    let picker = UIPickerView()
    var imageSelected = false
    var imageLink = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topicTextField.delegate = self
        titleView.delegate = self
//        topicLabel.padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 25)
        topicLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setupTopicSelector)))
        setUI()
        getTopicListData()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        self.isConfirm = true
        self.setupLeftBarButton(isback: true)
        titleView.layer.cornerRadius = 5
        titleView.layer.borderWidth = 1
        titleView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        titleView.clipsToBounds = true
        titleView.placeholder = "Type Your Title Here"
        titleView.placeholderColor = UIColor.lightGray
        
        topicTextField.placeholder = "Select Topic"
        uploadImageButton.contentHorizontalAlignment = .left
    }
    
    func validate() -> Bool {
        if !titleView.validate() { self.showAlert(message: "Please enter title"); return false }
        if selectedTopicStringArray.isEmpty { self.showAlert(message: "Please select topic"); return false }
//        if selectedTopic == nil { self.showAlert(message: "Please select topic"); return false }
        if !imageSelected { self.showAlert(message: "Please select image"); return false }
        return true
    }

    @IBAction func uploadButtonTapped(_ sender: Any) {
        openPhotos()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if validate() {
            uploadImageToServer()
        }
    }
    
}

//MARK:- Textfield Delegate

extension CreateWallViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        setupPickerView(in: textField)
        if topicListData.isEmpty || !NetworkStatus.shared.haveInternet() {
            self.showAlert(message: NO_INTERNET)
        } else {
            setupTopicSelector()
        }

    }
}

//MARK:- Multiple Selector Setup
extension CreateWallViewController {
    @objc func setupTopicSelector() {
        if topicListData.isEmpty {
            getTopicListData(openSelector: true)
        } else {
            let topicString = topicListData.compactMap{ $0.topic }
            let selectionMenu = RSSelectionMenu(selectionType: .Multiple, dataSource: topicString) { (cell, object, indexPath) in
                cell.textLabel?.text = object
                cell.tintColor = BLUE_COLOR
                cell.textLabel?.font = Common.shared.getFont(type: .regular, size: 15)
            }
            selectionMenu.setNavigationBar(title: "Select Topics", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white], barTintColor: BLUE_COLOR, tintColor: UIColor.white)
            
            selectionMenu.setSelectedItems(items: selectedTopicStringArray) { (text, isSelected, selectedItems) in
                
                self.selectedTopicStringArray = selectedItems
                self.selectedTopicIdArray = self.topicListData.filter{ self.selectedTopicStringArray.contains($0.topic ?? "") }.compactMap{ $0.id }
                if self.selectedTopicStringArray.isEmpty {
                    self.topicLabel.text = "Select Topics"
                } else {
                    self.topicLabel.text = self.selectedTopicStringArray.compactMap{ $0 }.joined(separator: ", ")
                }
                
            }
            selectionMenu.show(style: .Present, from: self)
        }
        
    }
}
extension CreateWallViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == titleView {
            let maxLength = 75
            let currentString: NSString = textView.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: text) as NSString
            DLog(message: "textLength: \(newString.length)")
            return newString.length <= maxLength
        }
        return true
    }
}

//MARK:- Topic Picker View
extension CreateWallViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setupPickerView(in textField: UITextField) {
        
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        doneButton.tintColor = UIColor.black
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        textField.inputView = picker
        print(selectedTopic?.topic ?? 0)
        if !topicListData.isEmpty {
            selectedTopic = topicListData[0]
            textField.text = selectedTopic?.topic ?? topicListData[0].topic ?? ""
        } else{
            textField.resignFirstResponder()
            self.showAlert(message: NO_INTERNET)
        }
        //        currentTopicId = topicListData[0].id ?? ""
    }
    
    @objc func doneClick() {
        topicTextField.resignFirstResponder()
        //        subCategoryTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return topicListData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return topicListData[row].topic ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if topicListData.count > row{
            selectedTopic = topicListData[row]
            topicTextField.text = selectedTopic?.topic ?? ""
        } else{
            topicTextField.resignFirstResponder()
            self.showAlert(message: NO_INTERNET)
        }
        
    }
}

//MARK:- Image Picking methods

extension CreateWallViewController {
    
    func openPhotos() {
        let photosAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photosAuthorizationStatus {
        case .notDetermined: takePermissionForPhotosUsage()
        case .authorized: presentPhotos()
        case .restricted, .denied: alertPhotosAccessNeeded()
        default: break
        }
    }
    
    func takePermissionForPhotosUsage() {
        PHPhotoLibrary.requestAuthorization({status in
            if status == .authorized{
                self.presentPhotos()
            }else{ return }
        })
    }
    
    func presentPhotos() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            alertPhotosAccessNeeded()
        }
    }
    
    func alertPhotosAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        let alert = UIAlertController(
            title: "Need Photos Access",
            message: "Photos access is required to update profile image.",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            } else {
                self.showAlert(message: "This app does not have access to Photos. You can enable access in Privacy Settings.")
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension CreateWallViewController: UIImagePickerControllerDelegate {
    //MARK:- Image Picker Delegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = (info[UIImagePickerController.InfoKey.editedImage]) as? UIImage {
            if let imageData = pickedImage.pngData() {
                wallImageData = imageData
                imageSelected = true
                setImageName(info: info)
                dismiss(animated: true, completion: nil)
            } else {
                self.showAlert(message: "The selected image is corrupted.")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setImageName(info: [UIImagePickerController.InfoKey : Any]) {
        if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            let asset = result.firstObject
            print("name:\(String(describing: asset?.value(forKey: "filename")))")
            if let imageName = (asset?.value(forKey: "filename")) as? String {
                uploadImageButton.setTitle(imageName, for: .normal)
            } else {
                uploadImageButton.setTitle("", for: .normal)
            }
        }
    }
    
}

//MARK:- API
extension CreateWallViewController {
    func uploadImage() {
        if NetworkStatus.shared.haveInternet() {
            
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func postData() {
        if NetworkStatus.shared.haveInternet() {
            let wallData = ["id": 0,
                            "user_id": USERID,
                            "title": titleView.text!,
                            "uploaded_filename": imageLink,
                            "is_topic_change":0,
                            "topics":selectedTopicIdArray] as [String: Any]
            Loader.showAdded(to: self.view, animated: true)
            Service.sharedInstance.request(api: API_DISCUSSION_CREATE, type: .post, parameters: wallData, complete: { (response) in
                do {
                    let statusResponse = try decoder.decode(StatusResponse.self, from: response as! Data)
                    if statusResponse.status ?? false {
//                        self.questionDelegate?.refreshCardList()
                        //self.showAlert(message: statusResponse.message ?? "Question created successfully")
                        self.showAlert(title: "", message: statusResponse.message ?? "Discussion created successfully", completion: {
                            self.wallDelegate?.refreshWallList()
                            self.navigationController?.popViewController(animated: true)
                        })
                        
                    } else {
                        self.showAlert(message: statusResponse.message ?? "Something went wrong, please try again later.")
                    }
                } catch {
                    self.showAlert(message: "\(error)")
                }
                Loader.hide(for: self.view, animated: true)
            }) { (err) in
                self.showAlert(message: "\(err)")
                DLog(message: err)
                Loader.hide(for: self.view, animated: true)
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func uploadImageToServer() {
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            Service.sharedInstance.sendImageToServer(with: wallImageData) { (success, link) in
                if success, let lin = link {
                    self.imageLink = lin
                    self.postData()
                } else {
                    Loader.hide(for: self.view, animated: true)
                }
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    func getTopicListData(openSelector: Bool = false){
        
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            let params = ["user_id":USERID,"topic":""]
            Service.sharedInstance.request(api: API_COMMON_SEARCH, type: .post, parameters: params, complete: { (response) in

                do {

                    let topics = try decoder.decode(TopicList.self, from: response as! Data)
                    print(topics)
                    
                    self.topicListData += topics.data ?? [TopicData]()
                    if openSelector { self.setupTopicSelector() }
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
}
