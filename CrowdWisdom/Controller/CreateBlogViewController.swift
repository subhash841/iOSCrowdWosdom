//
//  CreateBlogViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 24/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import RichEditorView
import AVFoundation
import Photos
import AssetsLibrary
import RSSelectionMenu

protocol AddBlogDelegate {
    func refreshList()
    func checkUserPoint()
}

class CreateBlogViewController: NavigationBaseViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var topicTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descriptionView: RichEditorView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var subCategoryTextField: UITextField!
    @IBOutlet weak var topicLabel: UILabel!

    
    @IBOutlet weak var descriptionTextHeight: NSLayoutConstraint!
    @IBOutlet weak var saveButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var subCategoryHeightConstraints: NSLayoutConstraint!
    
    let picker = UIPickerView()
    var isCategoryTextField = Bool()
    var isFirstTimeAddDesc = Bool()
    
    var testArray = [String](repeating: "Test", count: 10)
    
    var isBlogImage = false
    var blogImageData: Data?
    var currentTopicId: String?
    var selectedTopic: TopicData?
    
    var topicListData = [TopicData]()
    var selectedTopicStringArray = [String]()
    var selectedTopicIdArray = [String]()
    
    var htmlImageHieght: CGFloat = 0
    let selectedImageScale: CGFloat = 0.5
    
    private var lastOffsetHeight: CGFloat = 0
    
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        if #available(iOS 11, *) {
            toolbar.options = [RichEditorDefaultOption.undo, RichEditorDefaultOption.redo,RichEditorDefaultOption.bold,RichEditorDefaultOption.italic,RichEditorDefaultOption.strike, RichEditorDefaultOption.underline,RichEditorDefaultOption.alignLeft, RichEditorDefaultOption.alignRight,RichEditorDefaultOption.alignCenter,RichEditorDefaultOption.image,RichEditorDefaultOption.link,RichEditorDefaultOption.link]
        } else {
            toolbar.options = [RichEditorDefaultOption.undo, RichEditorDefaultOption.redo,RichEditorDefaultOption.bold,RichEditorDefaultOption.italic,RichEditorDefaultOption.strike, RichEditorDefaultOption.underline,RichEditorDefaultOption.alignLeft, RichEditorDefaultOption.alignRight,RichEditorDefaultOption.alignCenter,RichEditorDefaultOption.image,RichEditorDefaultOption.link]
        }
        return toolbar
    }()
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isConfirm = true
        topicLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setupTopicSelector)))
        setupLeftBarButton(isback: true)
        setRichView()
        setupUI()
        
        self.getTopicListData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let saveButtonTop = saveButton.frame.origin.y
        scrollView.contentSize = CGSize(width: 0, height: saveButtonTop + 30 + 30)
    }
    
    private func setupUI() {
        //        headerLabel.attributedText = Common.shared.attributedText(withString: "Create A Blog", boldString: "Blog", font: Common.shared.getFont(type: .regular, size: 15))
//        topicLabel.padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 25)
        topicTextField.setLeftPaddingPoints(10)
        categoryTextField.setLeftPaddingPoints(10)
        uploadButton.contentHorizontalAlignment = .left
        uploadButton.setTitleColor(UIColor.lightGray, for: .normal)
        
        if Device.IS_IPHONE_5{
            descriptionTextHeight.constant = 150
        }else if Device.IS_IPHONE_6{
            descriptionTextHeight.constant = 280
        }else if Device.IS_IPHONE_XR{
            descriptionTextHeight.constant = 445
        }else if Device.IS_IPHONE_X{
            descriptionTextHeight.constant = 380
        }else if Device.IS_IPHONE_6P{
            descriptionTextHeight.constant = 370
        }
    }
    
    private func addPaddingToTextView(){
        // let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        /*descriptionView.superclass.leftView = paddingView
         descriptionView.leftViewMode = .always*/
    }
    
    private func setRichView() {
        descriptionView.placeholder = "Type Description Here"
        descriptionView.isScrollEnabled = false
        descriptionView.delegate = self
        descriptionView.inputAccessoryView = toolbar
        
        toolbar.delegate = self
        toolbar.editor = descriptionView
        toolbar.editor?.setEditorFontColor(.red)
        
        // We will create a custom action that clears all the input text when it is pressed
        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar.editor?.html = ""
        }
        let item1 = RichEditorOptionItem(image: nil, title: "Done") { toolbar in
            self.view.endEditing(true)
        }
        var options = toolbar.options
        options.append(item)
        options.append(item1)
        toolbar.options = options
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    //MARK:- Button Action
    
    @objc func dismissKeyboard() {
        let _ = descriptionView.resignFirstResponder()
        // clear toolBar here
        // descriptionView.inputAccessoryView = nil
    }
    
    @IBAction func imageUploadTapped(_ sender: Any) {
        isBlogImage = true
        //        let photos = PHPhotoLibrary.authorizationStatus()
        //        if photos == .notDetermined {
        //            PHPhotoLibrary.requestAuthorization({status in
        //                if status == .authorized{
        //                    self.presentPhotos()
        //                }else
        //                { }
        //            })
        //        }
        self.openPhotos()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        DLog(message: descriptionView.html)
        validateData()
        if let data = blogImageData {
            uploadImageToServer(with: data, isHtml: false)
        }
    }
    
    private func validateData() {
        
        
        
        guard let title = topicTextField.text,
            title != "" else {
                self.showAlert(message: "Enter proper blog title")
                return
        }
        if title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            self.showAlert(message: "Enter proper blog title")
            return
        }
        
//        guard let _ = selectedTopic  else {
//            self.showAlert(message: "Please select topic")
//            return
//        }
        if selectedTopicIdArray.isEmpty {
            self.showAlert(message: "Please select topic")
            return
        }
        
        if validate(textView: descriptionView){
            self.showAlert(message: "Please enter description")
            return
        }
        
        if descriptionView.text.count <= 0 , descriptionView.html == ""
        {
            self.showAlert(message: "Please enter description")
            return
        }
        
        guard let _ = blogImageData else {
            self.showAlert(message: "Select an image for blog")
            return
        }
    }
    
    func validate(textView: RichEditorView) -> Bool {
        let text = textView.text
        if !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty{
            return false
        } else {
            return true
        }
    }
    
    private func showLinkAlert() {
        let alert = UIAlertController(title: "", message: "Enter proper Link", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your link here"
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields {
                let txtField = textField[0]
                if let text = txtField.text, text.count > 0 {
                    self.toolbar.editor?.insertLink(text, title: "Link title")
                } else {
                    // show error
                    self.showError()
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showError() {
        let alert = UIAlertController(title: "", message: "Link cant be nil", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.showLinkAlert()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Server Calls
    
    func getTopicListData(openSelector: Bool = false){
        
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            let params = ["user_id":USERID,"topic":""]
            Service.sharedInstance.request(api: API_COMMON_SEARCH, type: .post, parameters: params, complete: { (response) in
                do {
                    let topics = try decoder.decode(TopicList.self, from: response as! Data)
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
    
    private func uploadImageToServer(with data: Data, isHtml: Bool) {
        
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: view, animated: true)
            Service.sharedInstance.sendImageToServer(with: data) { (isSuccess, imageLink) in
                Loader.hide(for: self.view, animated: true)
                if isSuccess , let link = imageLink {
                    if isHtml {
//                        self.toolbar.editor?.insertImage(self.createLink(with: link), alt: "Gravatar")
                        self.toolbar.editor?.insertImage(link, alt: "Gravatar")
                        let currentHt = self.descriptionTextHeight.constant
                        self.descriptionTextHeight.constant = currentHt + self.htmlImageHieght
                    } else {
                        // Now send Blog details to server
                        self.sendBlogDetailsToServer(with: link)
                    }
                }
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    private func createLink(with mainLink: String) -> String {
        var link = ""
        if mainLink.contains("https://") {
            link = mainLink.replacingOccurrences(of: "https://", with: "")
        }
        
        if mainLink.contains("http://") {
            link = mainLink.replacingOccurrences(of: "http://", with: "")
        }
        
        link = "https://imgcdn.crowdwisdom.co.in/" + link + "?w=200"
        print("link:\(link)")
        return link
    }
    
    private func sendBlogDetailsToServer(with blogImageUrl: String) {
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
//            var topicArray = [String]()
//            if let topicId = selectedTopic?.id {
//                topicArray.append(topicId)
//            } else {
//                topicArray.append("")
//            }
            
            let params = ["voice_id":"0", "user_id":USERID, "title":topicTextField.text!,"topics":selectedTopicIdArray,"description":descriptionView.html,"uploaded_filename":blogImageUrl,"is_topic_change":"0"] as [String : Any]
            print("param:\(params)")
            Service.sharedInstance.request(api: API_CREATE_BLOG, type: .post, parameters: params, complete: { (response) in
                do {
                    let topics = try decoder.decode(CreateBlogModel.self, from: response as! Data)
                    if let status = topics.status, status == true {
                        self.confirmationAlert(msg: topics.message ?? "Thank you. Crowd wisdom will approve your voice soon")
                    } else {
                        self.showAlert(message: topics.message ?? "Please try again")
                    }
                } catch {
                    DLog(message: error)
                    self.showAlert(message: error.localizedDescription)
                }
                Common.shared.getUserPoints()
                Loader.hide(for: self.view, animated: true)
                
            }) { (error) in
                DLog(message: error)
                Loader.hide(for: self.view, animated: true)
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    private func confirmationAlert(msg: String ) {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK:- Extensions

extension CreateBlogViewController: RichEditorDelegate {
    
    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        //        if content.isEmpty {
        //            htmlTextView.text = "HTML Preview"
        //        } else {
        //            htmlTextView.text = content
        //        }
        //        DLog(message: content)
    }
    
    func richEditorTookFocus(_ editor: RichEditorView) {
        
        if lastOffsetHeight == 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: descriptionView.center.y), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: descriptionView.frame.origin.y + lastOffsetHeight - 140), animated: true)
        }
        isFirstTimeAddDesc = true
        descriptionView.inputAccessoryView = toolbar
    }
    
    func richEditorLostFocus(_ editor: RichEditorView) {
        let _ = descriptionView.resignFirstResponder()
        scrollView.setContentOffset(CGPoint.zero, animated: true)
        descriptionView.inputAccessoryView = nil
    }
}


extension CreateBlogViewController: RichEditorToolbarDelegate {
    
    fileprivate func randomColor() -> UIColor {
        let colors: [UIColor] = [
            .red,
            .orange,
            .yellow,
            .green,
            .blue,
            .purple
        ]
        
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }
    
    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }
    
    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }
    
    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar) {
        isBlogImage = false
        presentPhotos()
    }
    
    func richEditor(_ editor: RichEditorView, heightDidChange height: Int) {
        print("height:\(height)")
        
        var oldHeight = 150
        if height < 150 {
            if Device.IS_IPHONE_5{
                descriptionTextHeight.constant =  150
                oldHeight = 150
            }else if Device.IS_IPHONE_6{
                descriptionTextHeight.constant =  280
                oldHeight = 280
            }else if Device.IS_IPHONE_6P{
                descriptionTextHeight.constant =  370
                oldHeight = 370
            }else if Device.IS_IPHONE_X{
                descriptionTextHeight.constant =  380
                oldHeight = 380
            }else if Device.IS_IPHONE_XR{
                descriptionTextHeight.constant =  445
                oldHeight = 445
            }
            return
        }
        descriptionTextHeight.constant =  CGFloat(height) + CGFloat(oldHeight)
        
        if height > oldHeight {
            lastOffsetHeight =  CGFloat(height) + CGFloat(oldHeight)
            scrollView.setContentOffset(CGPoint(x: 0, y: descriptionView.center.y + CGFloat(height) + CGFloat(oldHeight)), animated: false)
            return
        }
    }
    
    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar) {
        if toolbar.editor?.hasRangeSelection == true {
            showLinkAlert()
            //toolbar.editor?.insertLink("http://github.com/cjwirth/RichEditorView", title: "Github Link")
        }
    }
}

//MARK:- Image Picking methods

extension CreateBlogViewController {
    func openCamera() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .notDetermined: takePermissionForCameraUsage()
        case .authorized: presentCamera()
        case .restricted, .denied: alertCameraAccessNeeded()
        }
    }
    func takePermissionForCameraUsage() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
            self.presentPhotos()
        })
    }
    
    func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else if !UIImagePickerController.isSourceTypeAvailable(.camera){
            self.showAlert(message: "Device has no camera")
        }
    }
    
    func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        let alert = UIAlertController(
            title: "Need Camera Access",
            message: "Camera access is required to update profile image.",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            } else {
                self.showAlert(message: "This app does not have access to Camera. You can enable access in Privacy Settings.")
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
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
    
    func    alertPhotosAccessNeeded() {
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

extension CreateBlogViewController: UIImagePickerControllerDelegate {
    //MARK:- Image Picker Delegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = (info[UIImagePickerController.InfoKey.editedImage]) as? UIImage {
            if isBlogImage {
                if let data: Data = (pickedImage).jpegData(compressionQuality: 0.5) {
                    blogImageData = data
                    setImageName(info: info)
                }
            } else {
                let finalImage = getRectSizeImage(actualImage: pickedImage)
                if let data:Data = (finalImage).jpegData(compressionQuality: 0.5) {
                    uploadImageToServer(with: data, isHtml: true)
                }
            }
            dismiss(animated: true, completion: nil)
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
                uploadButton.setTitle(imageName, for: .normal)
                uploadButton.setTitleColor(UIColor.black, for: .normal)
            } else {
                uploadButton.setTitle("jpg or png", for: .normal)
                uploadButton.setTitleColor(UIColor.black, for: .normal)
            }
        }
    }
    
    private func getRectSizeImage(actualImage: UIImage) -> UIImage {
        let targetSize = CGSize(width: 200, height: 200)
        UIGraphicsBeginImageContext(targetSize)
        actualImage.draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        let scaledImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        htmlImageHieght = targetSize.height
        if let finalImage = scaledImage {
            return finalImage
        }
        return actualImage
    }
    
    private func getScaledImage(actualImage: UIImage) -> UIImage {
        let targetSize = CGSize(width: actualImage.size.width * selectedImageScale, height: actualImage.size.height * selectedImageScale)
        UIGraphicsBeginImageContext(targetSize)
        actualImage.draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        let scaledImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        htmlImageHieght = targetSize.height
        if let finalImage = scaledImage {
            return finalImage
        }
        return actualImage
    }
    
}

//MARK:- Picker Delegate and setup
extension CreateBlogViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == categoryTextField {
            if topicListData.count > 0{
                setupPickerView(in: textField)
            } else{
                textField.resignFirstResponder()
                self.showAlert(message: NO_INTERNET)
            }
            isCategoryTextField = true
        }else{
            isCategoryTextField = false
        }
    }
    
    @objc func doneClick() {
        categoryTextField.resignFirstResponder()
        //        subCategoryTextField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == topicTextField {
            let maxLength = 75
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            DLog(message: "\(newString.length)")
            return newString.length <= maxLength
        }
        return true
    }
    
}

//MARK:- Topic Multi Selector Setup
extension CreateBlogViewController {
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

extension CreateBlogViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        guard let _ = selectedTopic else {
            selectedTopic = topicListData[0]
            textField.text = topicListData[0].topic ?? ""
            return
        }
        
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
        if isCategoryTextField {
            categoryTextField.text = topicListData[row].topic ?? ""
            selectedTopic = topicListData[row]
        }
    }
}

extension CreateBlogViewController {
    func postData() {
        print(descriptionView.html)
    }
}

/*
 // Change navigation bar color while picking image with image Picker Controller
 
 imagePicker.navigationBar.barTintColor = BLUE_COLOR
 imagePicker.navigationBar.isTranslucent = false
 imagePicker.navigationBar.shadowImage = UIImage()
 imagePicker.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
 imagePicker.navigationBar.tintColor = UIColor.white
 imagePicker.navigationItem.titleView = titleLabel
 */
