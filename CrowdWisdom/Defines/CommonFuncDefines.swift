//
//  CommonFuncDefines.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 10/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import KeychainSwift

private var sharedInst = CommonFuncDefines()

class CommonFuncDefines: NSObject {
    class var shared: CommonFuncDefines { return sharedInst }
    
    let keychain = KeychainSwift()
    var userInfoDict = [String:Any]()
    var defaults = UserDefaults.standard
    
    var USER_POINT = Int()
    var cardTypeAtList = CardType.competition
    
    var isFromNotification = false
    
    var notificationType: String?
    var notificationPostId: String?
    var notificationSubType: String?
    
    var notificationCommentId: String?
    var notificationCommentAlias: String?
    var notificationComment: String?
    
    
    
    func createGradientLayer(viewFrame: CGRect, colors:[CGColor], startPoint: CGPoint, endPoint:CGPoint) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = viewFrame
        gradientLayer.colors = colors
        //        point x and y co-ordinates should be in range 0.0 - 1.0
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.drawsAsynchronously = true
        return gradientLayer
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: getFont(type: .bold, size: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    func getColorInAttributedText(mainString: String, stringToColor: String) -> NSMutableAttributedString {
//        let mainString = "None of the above*"
//        let stringToColor = "*"
        
        let range = (mainString as NSString).range(of: stringToColor)
        
        let attribute = NSMutableAttributedString.init(string: mainString)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        
        return attribute
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}

//MARK:- Font Function
enum FontType: String {
    case regular = "Roboto-Regular"
    case medium = "Roboto-Medium"
    case bold = "Roboto-Bold"
}

extension CommonFuncDefines {
    
    func getFont(type: FontType, size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size)!
    }
    
}

//MARK:- Navigation
extension CommonFuncDefines {
    /*func setAppLogoToNavigationTitle() -> UIView {
     let width = 200
     let height = 65
     let logoView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
     let logoImageView = UIImageView(frame: CGRect(x: 20, y: 5, width: width-40, height: height/2))
     logoImageView.contentMode = .scaleAspectFit
     logoImageView.image = UIImage(named: "navigationLogo")
     logoView.addSubview(logoImageView)
     return logoView
     }*/
}

//MARK:- Keychain functions
extension Common {
    func getToken() -> String? {
        return keychain.get("token")
    }
    
    func setToken(token: String) {
        keychain.set(token, forKey: "token")
    }
    
    func getDeviceAPNsToken() -> String? {
        return keychain.get("APNsToken")
    }
    func setDeviceAPNsToken(token: String) {
        keychain.set(token, forKey: "APNsToken")
    }
    
}

//MARK:- User data
extension Common{
    
    //MARK:- User Defaults Methods
    func setInfo(dict: [String: Any]) {
        userInfoDict = dict
        saveInfo()
    }
    
    func saveInfo() {
        defaults.set(userInfoDict, forKey: "UserData")
        defaults.synchronize()
    }
    
    func loadInfo() {
        if defaults.object(forKey: "UserData") != nil {
            userInfoDict = defaults.object(forKey: "UserData") as! [String:Any]
        }
    }
    
    func getUserInfo() -> [String: Any] {
        loadInfo()
        return userInfoDict
    }
    
    func getAliasname() -> String {
        loadInfo()
        var aliasText = ""
        if let aliasName = userInfoDict["alias"] as? String {
            aliasText = aliasName
        }
        return aliasText
    }
    
    func addKeyToInfo(key: String, value: Any) {
        loadInfo()
        userInfoDict[key] = value
        saveInfo()
    }
    
    func setLoginScreen() {
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }
}

extension Common{
    //MARK:- Date Function
    
    func stringFromDateString(date:String, fromFormat:String, toFormat:String, isUT:Bool) -> String{
        if date == ""{
            return ""
        } else{
            let dateformate = DateFormatter()
            dateformate.dateFormat = fromFormat
            DLog(message: dateformate.timeZone.abbreviation()!)
            //        if (isUTC){
            //            dateformate.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
            //        }
            
            let date = dateformate.date(from: date)
            dateformate.dateFormat = toFormat
            if(isUT){
                dateformate.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
            }
            if let dat = date {
                return dateformate.string(from: dat)
            } else {
                return ""
            }
        }
    }
    
    func dateFromStringDate(date:String, fromFormat:String, isUTC:Bool) -> Date?{
        let dateformate = DateFormatter()
        dateformate.dateFormat = fromFormat
        if(isUTC){
            dateformate.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        }
        let date = dateformate.date(from: date)
        if date == nil {
            return nil
        }
        return date!
    }
    
    func stringFromDate(date:Date, toFormat:String, isUTC:Bool) -> String{
        let dateformate = DateFormatter()
        dateformate.dateFormat = toFormat
        if(isUTC){
            dateformate.timeZone = NSTimeZone.local
        }
        return dateformate.string(from: date)
    }
}

extension CommonFuncDefines {
    func showLoader(isEmpty: Bool = false, view: UIView) {
        if !isEmpty {
            Loader.showAdded(to: view, animated: true)
        }
    }
}

extension Common{
    func shareURL(id:String, isVoice:Int) -> String{
        var URLString = ""
        
        if isVoice == 0 {
            URLString = LIVE_URL + YOUR_VOICE_LINK + id
        }else if isVoice == 1
        {
            URLString = LIVE_URL + PREDICTIONS_LINK + id
        }else if isVoice == 2
        {
            URLString = LIVE_URL + HOT_TOPICS_LINK + id
        }else if isVoice == 3
        {
            URLString = LIVE_URL + DISCUSSION_WALL_LINK + id
        }else if isVoice == 4
        {
            URLString = LIVE_URL + ASK_QUESTION_LINK + id
        } else if isVoice == 5
        {
            URLString = LIVE_URL + PACKAGES_LINK + id
        } else if isVoice == 6
        {
           URLString = LIVE_URL + PACKAGE_DETAIL_LINK + id
        } else if isVoice == 7
        {
            URLString = LIVE_URL + RATED_ARTICLE_LINK + id
        }
        return URLString
    }
}

extension Common {
    func assignColorToUser(completion: ()->()) {
        colorDictionary["nil"] = UIColor.random()
        let oldUserSet = userArray
        completion()
        let newUsersSet = userArray.subtracting(oldUserSet)
        newUsersSet.forEach { (user) in
            colorDictionary[user] = UIColor.random()
        }
    }
}

extension Common {
    func getCommentIntValue(string: String?) -> Int {
        if let totalCommentString = string, let totalComment = Int(totalCommentString) {
            return totalComment
        }
        return 0
    }
}

//MARK:- Size of string

extension Common {
    func sizeOfString (string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
        return (string as NSString).boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                 attributes: [NSAttributedString.Key.font: font],
                                                 context: nil).size
    }
}

//MARK:- Common APIs
extension Common {
    func getUserPoints() {
        Service.sharedInstance.request(api: API_USER_CURRENT_POINT, type: .post, parameters: ["user_id":USERID], complete: { (response) in
            do {
                let userPointData = try decoder.decode(WalletHistory.self, from: response as! Data)
                self.USER_POINT = self.getCommentIntValue(string: userPointData.points)
                
            } catch {
                DLog(message: error)
            }
            DLog(message: response)
        }) { (error) in
            DLog(message: error)
        }
    }
    
    func updateDeviceAPNsToken() {
        if let token = getDeviceAPNsToken(), NetworkStatus.shared.haveInternet() {
            
            Service.sharedInstance.request(api: API_UPDATE_DEVICE_TOKEN, type: .post, parameters: ["user_id":USERID, "device_token":token, "device_type":"Ios"], complete: { (response) in
                do {
                    DLog(message: response)
                } catch {
                    DLog(message: error)
                }
                DLog(message: response)
            }) { (error) in
                DLog(message: error)
            }
        }
    }
    
    func logoutUser() {
        Service.sharedInstance.request(api: API_LOGOUT, type: .post, parameters: ["user_id":USERID], complete: { (response) in
            DLog(message: response)
        }) { (error) in
            DLog(message: error)
        }
    }
}
