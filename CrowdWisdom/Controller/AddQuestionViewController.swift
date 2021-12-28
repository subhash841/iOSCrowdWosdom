//
//  AddQuestionViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 08/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import Photos
import RSSelectionMenu

protocol AddQuestionDelegate {
    func refreshCardList()
}

class AddQuestionViewController: NavigationBaseViewController, UINavigationControllerDelegate {

    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var topicTextField: UITextField!
    //    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var choicesTableView: UITableView!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addQuestionView: UIView!

    
    @IBOutlet weak var emailsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var questionBottomView: UIView!
    @IBOutlet weak var predictionBottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addEmailIdTableView: UITableView!
    @IBOutlet weak var dateTextView: UITextField!
    
    @IBOutlet weak var singleChoiceButton: UIButton!
    @IBOutlet weak var multipleChoiceButton: UIButton!
    
    @IBOutlet weak var singleChoiceImageView: UIImageView!
    @IBOutlet weak var multipleChoiceImageView: UIImageView!
    
    @IBOutlet weak var questionTextField: UITextField!
    var numberOfChoice = 3
    var numberOfEmails = 1
    var questionChoice = 0
    var type: CardType!
    var choiceArray = [NSMutableAttributedString](repeating: NSMutableAttributedString(string: ""), count: 4)
    var emailsArray = [NSMutableAttributedString](repeating: NSMutableAttributedString(string: ""), count: 1)
    
    var topicListData = [TopicData]()
    var selectedTopicStringArray = [String]()
    var selectedTopicIdArray = [String]()
    
    let picker = UIPickerView()
    var questionImageData = Data()
    var imageSelected = Bool()
    var imageLink = String()
    var isSingleChoice = 0
    var selectedTopic: TopicData?
    var questionDelegate: AddQuestionDelegate?
    var isMakePreduction = false
    var isEmail = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isConfirm = true
        
//        if type == CardType.askQuestion {
            getTopicListData()
            
//            bottomViewHeight.constant = 78
            choiceArray[3] = Common.shared.getColorInAttributedText(mainString: "None of the above*", stringToColor: "*")
            choiceArray[2] = Common.shared.getColorInAttributedText(mainString: "See the result*", stringToColor: "*")
//        }
        
        if isMakePreduction == true
        {
            predictionBottomView.isHidden = false
            questionBottomView.isHidden = true
        }else
        {
            bottomViewHeight.constant = 78
            predictionBottomView.isHidden = true
            questionBottomView.isHidden = false
        }
        choicesTableView.register(UINib(nibName: "ChoiceNewTableViewCell", bundle: nil), forCellReuseIdentifier: "choiceCell")
        addEmailIdTableView.register(UINib(nibName: "ChoiceNewTableViewCell", bundle: nil), forCellReuseIdentifier: "choiceCell")

        topicTextField.delegate = self
        questionTextField.delegate = self
        choicesTableView.delegate = self
        choicesTableView.dataSource = self
        addEmailIdTableView.delegate = self
        addEmailIdTableView.dataSource = self
        topicTextField.placeholder = "Please Select Topic"
      
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date
//        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(self.updateTextField(_:)), for: .valueChanged)
        datePicker.minimumDate = Date()
        dateTextView.inputView = datePicker
        dateTextView.tintColor = .clear
        
        // Do any additional setup after loading the view.
        setUI()
        setButton()
    }
    
    @objc func updateTextField(_ sender: Any?) {
        let picker = dateTextView.inputView as? UIDatePicker
        if let aDate = picker?.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myString = formatter.string(from: aDate)
            let yourDate = formatter.date(from: myString)
            formatter.dateFormat = "dd-MMM-yyyy"
            let myStringafd = formatter.string(from: yourDate!)
            dateTextView.text = myStringafd
        }
    }
    
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: dt!)
    }


    @IBAction func dateTappedAction(_ sender: Any) {
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func setUI() {
//        addQuestionView.addShadow()
        topicTextField.setRightPaddingPoints(20)
        saveButton.roundCorners([.allCorners], radius: saveButton.frame.width / 2)
//        cancelButton.roundCorners([.allCorners], radius: saveButton.frame.width / 2)
        cancelButton.makeRoundedCorners()
        cancelButton.makeShadow()
        
//        tableViewHeight.constant = CGFloat(numberOfChoice * 44)
//        emailsTableViewHeight.constant = CGFloat(numberOfEmails * 44)
        
        uploadImageButton.contentHorizontalAlignment = .left
        uploadImageButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
        choicesTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        addEmailIdTableView.addObserver(self, forKeyPath: "contentSizeEmails", options: .new, context: nil)
        
        questionTextField.layer.cornerRadius = 5
        questionTextField.layer.borderWidth = 1
        questionTextField.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        questionTextField.clipsToBounds = true
        questionTextField.placeholder = "Ask your question with 'What', 'Why', 'Which' etc"
//        questionTextField.placeholderColor = UIColor.lightGray
        questionTextField.font = Common.shared.getFont(type: .regular, size: 15)
        
        descriptionTextView.font = Common.shared.getFont(type: .regular, size: 15)
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        descriptionTextView.clipsToBounds = true
        
        topicTextField.layer.borderColor = UIColor.lightGray.cgColor
        topicTextField.layer.cornerRadius = 2
        
        self.setupLeftBarButton(isback: true)
        
    }
    
    func setButton() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        
        singleChoiceImageView.image = singleChoiceImageView.image?.maskWithColor(color: BLUE_COLOR)
        multipleChoiceImageView.image = multipleChoiceImageView.image?.maskWithColor(color: BLUE_COLOR)

        multipleChoiceButton.setTitle("Multiple Choice", for: .normal)
        singleChoiceButton.addTarget(self, action: #selector(questionButtonTapped(_:)), for: .touchUpInside)
        multipleChoiceButton.addTarget(self, action: #selector(questionButtonTapped(_:)), for: .touchUpInside)

        singleChoiceButton.contentHorizontalAlignment = .center
        multipleChoiceButton.contentHorizontalAlignment = .center

//        singleChoiceButton.groupButtons = [singleChoiceButton, multipleChoiceButton]
//        singleChoiceButton.setSelected(true)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tableViewHeight.constant = choicesTableView.contentSize.height
        if isMakePreduction == true
        {
            emailsTableViewHeight.constant = addEmailIdTableView.contentSize.height
        }
    }
    
    deinit {
        choicesTableView.removeObserver(self, forKeyPath: "contentSize")
        if isMakePreduction == true
        {
            addEmailIdTableView.removeObserver(self, forKeyPath: "contentSizeEmails")
        }
    }
    
    @IBAction func uploadImageTapped(_ sender: Any) {
        openPhotos()
    }
    
    @IBAction func questionButtonTapped(_ sender: UIButton) {

        if sender == singleChoiceButton {
            questionChoice = 0
            singleChoiceImageView.image = UIImage(named: "radio-button-on")?.maskWithColor(color: BLUE_COLOR)
            multipleChoiceImageView.image = UIImage(named: "radio-button-off")?.maskWithColor(color: BLUE_COLOR)

        } else {
            questionChoice = 1
            singleChoiceImageView.image = UIImage(named: "radio-button-off")?.maskWithColor(color: BLUE_COLOR)
            multipleChoiceImageView.image = UIImage(named: "radio-button-on")?.maskWithColor(color: BLUE_COLOR)
            
        }
    }
    
    fileprivate func uploadImageToServer() {
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            Service.sharedInstance.sendImageToServer(with: questionImageData) { (success, link) in
                if success, let lin = link {
                    self.imageLink = lin
                    if self.isMakePreduction == true
                    {
                        self.postMakePreductionData()
                    }else
                    {
                        self.postQuestionData()
                    }
                } else {
                    Loader.hide(for: self.view, animated: true)
                }
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if validate() {
            uploadImageToServer()
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func validate() -> Bool {
        if !questionTextField.validate() {
            self.showAlert(message: "Please enter question")
            return false
        }
        
        if topicTextField.text!.isEmpty {
            self.showAlert(message: "Please select topic")
            return false
        }
        
        if !descriptionTextView.validate() {
            self.showAlert(message: "Please enter description")
            return false
        }
        
        var choiceAdded = true
        choiceArray.forEach { (choice) in
            if choice.string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
                choiceAdded = false
            }
        }
        
        if !choiceAdded {
            self.showAlert(message: "Please enter choice")
            return false
        }
        
        if !imageSelected {
            self.showAlert(message: "Please select image")
            return false
        }
        
        if choiceArray.contains(where: { $0.string.isEmpty }) {
            self.showAlert(message: "Please enter option.")
            return false
        }
        
        if isMakePreduction == true {
            let validEmailArray = emailsArray.compactMap{ isValidEmail(testStr: $0.string) }
            
            if validEmailArray.contains(false) {
                self.showAlert(message: "Please enter valid email Id")
                return false
            }
            
            var emailsAdded = true
            emailsArray.forEach { (email) in
                if email.string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
                    emailsAdded = false
                }
            }
            
            if !emailsAdded {
                self.showAlert(message: "Please enter emails")
                return false
            }
            
            if dateTextView.text!.isEmpty {
                self.showAlert(message: "Please select end date")
                return false
            }

        }
        return true
    }
    
    func getChoice(of index: Int) -> Choice {
        
        switch index {
        case 0:
            return Choice.normal
            
        case choiceArray.count - 3:
            //second last
            return Choice.add
        
        case 1:
            return Choice.delete
        
        case choiceArray.count - 2:
            return Choice.seeTheResult
            
        case choiceArray.count - 1:
            //last
            return Choice.noneOfTheAbove
        
        default:
            return Choice.delete
        }
    }
    
    func getEmails(of index: Int) -> Emails {
        
        switch index {
            
        case emailsArray.count - 1:
            return Emails.addEmail
        
        default:
            return Emails.deleteEmail
        }
    }
    
}

enum Choice: String {
    case add = "Add"
    case delete = "Delete"
    case normal = "Default"
    case seeTheResult = "See the result*"
    case noneOfTheAbove = "None of the above*"
    
}

enum Emails: String {
    case addEmail = "Add"
    case deleteEmail = "Delete"
}

//MARK:- Choices TableView Delegates and DataSource
extension AddQuestionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == addEmailIdTableView {
            return emailsArray.count
        }else
        {
            return choiceArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let choiceCell: ChoiceNewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "choiceCell", for: indexPath) as! ChoiceNewTableViewCell

        if tableView == addEmailIdTableView {
            choiceCell.choiceTextField.attributedText = emailsArray[indexPath.row]
            choiceCell.choiceTextField.delegate = self
            choiceCell.choiceTextField.tag = 1000 + indexPath.row
            choiceCell.selectionStyle = .none
            choiceCell.optionImage.isUserInteractionEnabled = true
            choiceCell.choiceTextField.placeholder = "Enter Participant's Email"

            choiceCell.choiceTextField.keyboardType = UIKeyboardType.emailAddress
            let emailsType = getEmails(of: indexPath.row)

            switch emailsType {
                
            case .addEmail:
                choiceCell.optionImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addEmails(sender:))))
                choiceCell.imageWidth.constant = 20
                choiceCell.optionImage.image = UIImage(named: emailsType.rawValue)?.maskWithColor(color: GREEN_COLOR)

            case .deleteEmail:
                choiceCell.optionImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteEmails(sender:))))
                choiceCell.imageWidth.constant = 20
                choiceCell.optionImage.image = UIImage(named: emailsType.rawValue)?.maskWithColor(color: RED_COLOR)

            }
            
            
        }else
        {
            
            isEmail = false
            choiceCell.choiceTextField.isUserInteractionEnabled = indexPath.row >= choiceArray.count - 2 ? false : true
            choiceCell.choiceTextField.delegate = self
            choiceCell.choiceTextField.tag = indexPath.row
            choiceCell.optionImage.tag = indexPath.row
            
            choiceCell.selectionStyle = .none
            choiceCell.optionImage.isUserInteractionEnabled = true

            let choiceType = getChoice(of: indexPath.row)
            
            switch choiceType {
                
            case .normal:
                choiceCell.imageWidth.constant = 0
                
            case .add:
                choiceCell.optionImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addChoice(sender:))))
                choiceCell.imageWidth.constant = 20
                choiceCell.optionImage.image = UIImage(named: choiceType.rawValue)?.maskWithColor(color: GREEN_COLOR)

                
            case .delete:
                choiceCell.optionImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteChoice(sender:))))
                choiceCell.imageWidth.constant = 20
                choiceCell.optionImage.image = UIImage(named: choiceType.rawValue)?.maskWithColor(color: RED_COLOR)

                
            case .noneOfTheAbove:
                let mainString = "None of the above*"
                let stringToColor = "*"
                
                let range = (mainString as NSString).range(of: stringToColor)
                
                let attribute = NSMutableAttributedString.init(string: mainString)
                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
                
                choiceCell.imageWidth.constant = 0
                choiceCell.choiceTextField.attributedText = attribute
                
            case .seeTheResult:
                choiceCell.imageWidth.constant = 0
                choiceCell.choiceTextField.text = "See the result*"
            }
            choiceCell.choiceTextField.attributedText = choiceArray[indexPath.row]
        }
        
        return choiceCell
    }
    
    @objc func addChoice(sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: choicesTableView)
        if let cellIndexPath = self.choicesTableView.indexPathForRow(at: touchPoint), let cell = self.choicesTableView.cellForRow(at: cellIndexPath) as? ChoiceNewTableViewCell {
            if choiceArray.count < 12{
                choiceArray[cellIndexPath.row] =  NSMutableAttributedString(string: cell.choiceTextField.text!)
                choiceArray[choiceArray.count - 2] = NSMutableAttributedString(string: "")
                choiceArray.append(NSMutableAttributedString(string:""))
                choiceArray[choiceArray.count - 1] = Common.shared.getColorInAttributedText(mainString: NONE_OF_THE_ABOVE, stringToColor: "*")
                choiceArray[choiceArray.count - 2] = Common.shared.getColorInAttributedText(mainString: SEE_THE_RESULT, stringToColor: "*")
                //            numberOfChoice += 1
                updateChoicesTableView()
            } else {
                self.showAlert(message: "You can only add upto 10 options.")
            }
        }
        
    }
    
    @objc func deleteChoice(sender: UITapGestureRecognizer){
        let touchPoint = sender.location(in: choicesTableView)
        if let cellIndexPath = self.choicesTableView.indexPathForRow(at: touchPoint) {
            if choiceArray.count >= 3 {
                choiceArray.popLast()
                choiceArray[cellIndexPath.row] = NSMutableAttributedString(string: "")
                choiceArray[choiceArray.count - 1] = Common.shared.getColorInAttributedText(mainString: NONE_OF_THE_ABOVE, stringToColor: "*")
                choiceArray[choiceArray.count - 2] = Common.shared.getColorInAttributedText(mainString: SEE_THE_RESULT, stringToColor: "*")
                updateChoicesTableView()
            }
        }
    }
    
    func updateChoicesTableView() {
        choicesTableView.reloadData()
        tableViewHeight.constant = choicesTableView.contentSize.height
        addQuestionView.layoutSubviews()
    }
    
    @objc func addEmails(sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: addEmailIdTableView)
        if let cellIndexPath = self.addEmailIdTableView.indexPathForRow(at: touchPoint), let cell = self.addEmailIdTableView.cellForRow(at: cellIndexPath) as? ChoiceNewTableViewCell {
            if emailsArray.count < 10{
                emailsArray[cellIndexPath.row] =  NSMutableAttributedString(string: cell.choiceTextField.text!)
                emailsArray.append(NSMutableAttributedString(string:""))
                updateEmailsTableView()
            }
        }
        
    }
    
    @objc func deleteEmails(sender: UITapGestureRecognizer){
        let touchPoint = sender.location(in: addEmailIdTableView)
        if let cellIndexPath = self.addEmailIdTableView.indexPathForRow(at: touchPoint) {
            if emailsArray.count >= 1 {
                emailsArray.popLast()
                emailsArray[cellIndexPath.row] = NSMutableAttributedString(string: "")
                updateEmailsTableView()
            }
        }
    }
    
    func updateEmailsTableView() {
        addEmailIdTableView.reloadData()
        emailsTableViewHeight.constant = addEmailIdTableView.contentSize.height
        addQuestionView.layoutSubviews()
    }
}

//MARK:- TextField Delegates
extension AddQuestionViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField != topicTextField {
            let index = textField.tag
            DLog(message: "tag:\(index)")
            if isMakePreduction == true
            {
                if index >= 1000 {
                    // means you are in emails
                    if (isValidEmail(testStr:textField.text!)){
                        emailsArray[index - 1000] = NSMutableAttributedString(attributedString: textField.attributedText!)
                    }else
                    {
                        self.showAlert(message: "Please enter valid email Id")
                    }

                } else {
                    // means you are in choice
                    choiceArray[index] = NSMutableAttributedString(attributedString: textField.attributedText!)
                }
                
            }else
            {
                choiceArray[index] = NSMutableAttributedString(attributedString: textField.attributedText!)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == questionTextField {
            let maxLength = 75
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            DLog(message: "\(newString.length)")
            return newString.length <= maxLength
        }
        return true
    }

    // email validation
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == topicTextField {
            if topicListData.isEmpty {
                getTopicListData(isFromTexField: false, openSelector: true)
                textField.resignFirstResponder()
            } else {
                setupTopicSelector()
                //                setupPickerView(in: textField)
            }
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
}

/*extension AddQuestionViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == questionTextView {
            let maxLength = 75
            let currentString: NSString = textView.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: text) as NSString
            DLog(message: "textLength: \(newString.length)")
            return newString.length <= maxLength
        }
        return true
    }
}*/

//extension AddQuestionViewController: UITextFieldDelegate {
//
//}

extension AddQuestionViewController {
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
                    self.topicTextField.text = "Select Topics"
//                    self.topicLabel.text = "Select Topics"
                } else {
                    self.topicTextField.text = self.selectedTopicStringArray.compactMap{ $0 }.joined(separator: ", ")
//                    self.topicLabel.text = self.selectedTopicStringArray.compactMap{ $0 }.joined(separator: ", ")
                }
                
            }
            selectionMenu.show(style: .Present, from: self)
        }
        
    }
}


//MARK:- APIs
extension AddQuestionViewController {
    func getTopicListData (isFromTexField: Bool = false, openSelector: Bool = false){
        
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            let params = ["user_id":USERID,"topic":""]
            Service.sharedInstance.request(api: API_COMMON_SEARCH, type: .post, parameters: params, complete: { (response) in
                do {
                    let topics = try decoder.decode(TopicList.self, from: response as! Data)
                    self.topicListData += topics.data ?? [TopicData]()
                    if openSelector { self.setupTopicSelector() }
                    if isFromTexField && !self.topicListData.isEmpty {
                        self.setupPickerView(in: self.topicTextField)
                        self.topicTextField.becomeFirstResponder()
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

    
    func postQuestionData() {
        let selectedTopicId = selectedTopic?.id ?? ""
        var choiceStringArray = choiceArray.compactMap{ $0.string }
        choiceStringArray[choiceStringArray.count - 2] = "See the Results"
        choiceStringArray[choiceStringArray.count - 1] = "None of the above"
        let titleText = descriptionTextView.text.replacingOccurrences(of: "\n", with: " ")
        let dict = ["questionid":0,
                    "user_id": USERID,
                    "title": questionTextField.text!,
                    "description": titleText,
                    "topics":selectedTopicIdArray,
                    "choices":choiceStringArray,
                    "uploaded_filename": imageLink,
                    "is_topic_change":0,
                    "is_choice_change":0,
                    "select_choice":questionChoice ] as [String : Any]
        print(dict)
        if NetworkStatus.shared.haveInternet() {
            
            Service.sharedInstance.request(api: API_ASKQUESTIONS_CREATE, type: .post, parameters: dict, complete: { (response) in
                do {
                    let statusResponse = try decoder.decode(ExpertResponse.self, from: response as! Data)
                    if statusResponse.status {
                        self.questionDelegate?.refreshCardList()
                        //self.showAlert(message: statusResponse.message ?? "Question created successfully")
                        self.showAlert(title: "", message: statusResponse.message ?? "Question created successfully", completion: {
                            
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
    
    func postMakePreductionData() {
        let selectedTopicId = selectedTopic?.id ?? ""
        var choiceStringArray = choiceArray.compactMap{ $0.string }
        choiceStringArray[choiceStringArray.count - 2] = "See the Results"
        choiceStringArray[choiceStringArray.count - 1] = "None of the above"
        let emailString = emailsArray.compactMap{$0.string}.joined(separator: ",")
//        let titleText = questionTextField.text.replacingOccurrences(of: "\n", with: "")

        let dict = ["predictionid":"0",
                    "user_id": USERID,
                    "title": questionTextField.text!,
                    "description": descriptionTextView.text!,
                    "topics":selectedTopicIdArray,
                    "choices":choiceStringArray,
                    "emails":emailString,
                    "uploaded_filename": imageLink,
                    "end_date":dateTextView.text!,
                    "is_topic_change":"0",
                    "is_choice_change":"0" ] as [String : Any]
        print(dict)
        if NetworkStatus.shared.haveInternet() {
            
            Service.sharedInstance.request(api: API_PREDICTIONS_CREATE_UPDATE, type: .post, parameters: dict, complete: { (response) in
                do {
                    let statusResponse = try decoder.decode(ExpertResponse.self, from: response as! Data)
                    if statusResponse.status {
                        self.showAlert(title: "", message: statusResponse.message ?? "Predictions created successfully", completion: {

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
}

//MARK:- Topic Picker View
extension AddQuestionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        if !topicListData.isEmpty {
            textField.text = selectedTopic?.topic ?? topicListData[0].topic ?? ""
        }
//        else {
//            if NetworkStatus.shared.haveInternet() {
//                textField.resignFirstResponder()
//                getTopicListData()
//            } else {
//                self.showAlert(message: NO_INTERNET)
//            }
//        }
        
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
        selectedTopic = topicListData[row]
        topicTextField.text = selectedTopic?.topic ?? ""
    }
}

//MARK:- Image Picking methods

extension AddQuestionViewController {
    
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

extension AddQuestionViewController: UIImagePickerControllerDelegate {
    //MARK:- Image Picker Delegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = (info[UIImagePickerController.InfoKey.editedImage]) as? UIImage {
            if let imageData = pickedImage.pngData() {
                questionImageData = imageData
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
                uploadImageButton.setTitleColor(.black, for: .normal)
            } else {
                uploadImageButton.setTitle("jpg or png", for: .normal)
                uploadImageButton.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }
    
}
