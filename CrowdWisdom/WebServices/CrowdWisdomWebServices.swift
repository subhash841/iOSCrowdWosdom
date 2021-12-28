//
//  CrowdWisdomWebServices.swift
//  CrowdWisdom
//
//  Created by  user on 7/24/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import Alamofire

class CrowdWisdomWebServices: NSObject {
    static let sharedInstance = CrowdWisdomWebServices()
    var alamoFireManager : SessionManager?
    var header = ["Content-Type":"application/x-www-form-urlencoded"]
//    var header = [String:Any]()
    //MARK:- Data for Web Service
    func checkToken(accessToken: String?){
        if let token = accessToken {
            header["Authorization"] = "Bearer " + token
        }
    }
    
    //MARK:- Webservice functions
    func request(api:String, type: HTTPMethod, parameters:[String:Any], decode:Bool = false, complete:@escaping(Any)->(), error:@escaping(Any)->()) {
        
        if api != API_LOGIN{
            let userinfo = Common.shared.getUserInfo()
            if let cookieProperties = userinfo[COOKIE] {
                if let cookie = HTTPCookie(properties: cookieProperties as! [HTTPCookiePropertyKey : Any] ) {
                    header[COOKIE] = "\(cookie.name)=\(cookie.value)"
                }
            }
        }
        DLog(message: "Header ======= \(header)")
        
        let url = LIVE_URL + api
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 0.2
        manager.request(url, method: type, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            
            if let headerFields = response.response?.allHeaderFields as? [String: String],
                let cookieURL = response.request?.url
            {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: cookieURL)
                
             if api == API_LOGIN ||  !Common.shared.userInfoDict.keys.contains(COOKIE){
                    var userinfo = Common.shared.getUserInfo()
                    userinfo[COOKIE] = cookies.first?.properties
                    //Common.shared.userInfoDict[COOKIE] = cookies.first?.properties
                    Common.shared.setInfo(dict: userinfo)
                }
                print(cookies)
            }
            if statusCode == 401 {
                DispatchQueue.main.async {
                    //                    CommonSettings.sharedInst.loadInfo()
                    //                    CommonSettings.sharedInst.deleteAllDataFromRealm()
                    //                    CommonSettings.sharedInst.userInfoDict = [:]
                    //                    CommonSettings.sharedInst.saveInfo()
                    //                    app_delegate?.setLoginScreen()
                }
            }  else if statusCode == 200 {
                switch response.result {
                case .success(let JSON):
                    if decode {
                        complete(JSON)
                    } else {
                        DLog(message: JSON)
                        complete(response.data!)
                    }
                case .failure(let err):
                    error(err)
                }
            } else if statusCode == 400 {
                switch response.result {
                case .success(let JSON):
                    error(JSON)
                case .failure(let err):
                    error(err)
                }
            } else if statusCode == 404 {
                switch response.result {
                case .success(let JSON):
                    error(JSON)
                case .failure(let err):
                    error(err)
                }
            } else if statusCode == 500 {
                switch response.result {
                case .success(let JSON):
                    error(JSON)
                case .failure(let err):
                    error(err)
                }
            } else {
                switch response.result {
                case .success(let JSON):
                    error(JSON)
                case .failure(let err):
                    error(err)
                }
            }
        }
        
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 1
////        configuration.timeoutIntervalForResource = 1
//        alamoFireManager = Alamofire.SessionManager(configuration: configuration)
        
//        manager.request(url, method: type, parameters: parameters).responseJSON { (response) in
//
//        }
        
    }
    
    
//    func multipartImageUpload(webName: String, imageData: Data?,imageName: String = "", onCompletion: @escaping (Any) -> (), onError: @escaping (Any) -> ()){
//        let deviceID = UIDevice.current.identifierForVendor!.uuidString
//        let contentType = "multipart/form-data; boundary=\(deviceID)"
////        if let userToken = CommonSettings.sharedInst.userInfoDict["AccessToken"]{
////            checkToken(accessToken: userToken as? String)
////        }
//        header["content-type"] = contentType
//        let url = BASE_URL + webName
//
//        let parameters = ["name":"avatar","fileName": imageName,"mimetype":"image/jpeg"]
//
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            for (key, value) in parameters {
//                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//            }
//            if let data = imageData{
//                multipartFormData.append(data, withName: "avatar", fileName: "image1.jpg", mimeType: "image/jpeg")
//            }
//
//        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: header) { (result) in
//            switch result{
//            case .success(let upload, _, _):
//                upload.responseJSON { response in
////                    DLog(message:"Succesfully uploaded")
//                    if let err = response.error {
//                        onError(err)
//                    }
//                    onCompletion(response)
//                }
//            case .failure(let error):
////                DLog(message: "Error in upload: \(error.localizedDescription)")
//                onError(error)
//            }
//        }
//    }
    
    func cancelAllRequest(){
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
        URLCache.shared.removeAllCachedResponses()

//        if (CommonSettings.sharedInst.realm.isInWriteTransaction) {
//            CommonSettings.sharedInst.realm.cancelWrite()
//            do{
//                try CommonSettings.sharedInst.realm.commitWrite()
//            }catch{
//                DLog(message: error)
//            }
//        }
//        CommonSettings.sharedInst.realm.refresh()
    }
    
    func encodeRequest(api:String, type: HTTPMethod, parameters:[String:Any], decode:Bool = true, complete:@escaping(Any)->(), error:@escaping(Any)->()) {
        
        if api != API_LOGIN{
            let userinfo = Common.shared.getUserInfo()
            if let cookieProperties = userinfo[COOKIE] {
                if let cookie = HTTPCookie(properties: cookieProperties as! [HTTPCookiePropertyKey : Any] ) {
                    header[COOKIE] = "\(cookie.name)=\(cookie.value)"
                }
            }
        }
        DLog(message: "Header ======= \(header)")
        
        let url = LIVE_URL + api
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 0.2
        manager.request(url, method: type, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            let statusCode = response.response?.statusCode
            
            if let headerFields = response.response?.allHeaderFields as? [String: String],
                let cookieURL = response.request?.url
            {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: cookieURL)
                
                if api == API_LOGIN ||  !Common.shared.userInfoDict.keys.contains(COOKIE){
                    var userinfo = Common.shared.getUserInfo()
                    userinfo[COOKIE] = cookies.first?.properties
                    //Common.shared.userInfoDict[COOKIE] = cookies.first?.properties
                    Common.shared.setInfo(dict: userinfo)
                }
                print(cookies)
            }
            if statusCode == 401 {
                DispatchQueue.main.async {
                    //                    CommonSettings.sharedInst.loadInfo()
                    //                    CommonSettings.sharedInst.deleteAllDataFromRealm()
                    //                    CommonSettings.sharedInst.userInfoDict = [:]
                    //                    CommonSettings.sharedInst.saveInfo()
                    //                    app_delegate?.setLoginScreen()
                }
            }  else if statusCode == 200 {
                switch response.result {
                case .success(let JSON):
                    if decode {
                        complete(JSON)
                    } else {
                        DLog(message: JSON)
                        complete(response.data!)
                    }
                case .failure(let err):
                    error(err)
                }
            } else if statusCode == 400 {
                switch response.result {
                case .success(let JSON):
                    error(JSON)
                case .failure(let err):
                    error(err)
                }
            } else if statusCode == 404 {
                switch response.result {
                case .success(let JSON):
                    error(JSON)
                case .failure(let err):
                    error(err)
                }
            } else if statusCode == 500 {
                switch response.result {
                case .success(let JSON):
                    error(JSON)
                case .failure(let err):
                    error(err)
                }
            } else {
                switch response.result {
                case .success(let JSON):
                    error(JSON)
                case .failure(let err):
                    error(err)
                }
            }
        }
        
        
    }
    func sendImageToServer(with imageData: Data, completion: @escaping (_ success: Bool, _ imageLink: String?) -> ()) {
        
        //https://imgupload.crowdwisdom.co.in/
        
        /* let deviceID = UIDevice.current.identifierForVendor!.uuidString
         let contentType = "multipart/form-data; boundary=\(deviceID)"
         if let userToken = CommonSettings.sharedInst.userInfoDict["AccessToken"]{
         checkToken(accessToken: userToken as? String)
         }
         header["content-type"] = contentType*/
        
        let url = "https://imgupload.crowdwisdom.co.in"
        
        // let parameters = ["mimetype":"image/jpeg"]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            /*for (key, value) in parameters {
             multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
             }*/
            
            multipartFormData.append(imageData, withName: "file", fileName: "image1.jpg", mimeType: "image/jpeg")
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: [:]) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let responseData = response.data {
                        if let imageLink = String(data: responseData, encoding: String.Encoding.utf8) {
                            DLog(message:"Succesfully uploaded")
                            print("result:\(imageLink)")
                            if imageLink.contains("http") {
                                completion(true,imageLink)
                            } else {
                                completion(false,imageLink)
                            }
                        }
                    } else {
                        if let err = response.error {
                            DLog(message: "Error in upload: \(err.localizedDescription)")
                            completion(false,nil)
                        }
                    }
                }
            case .failure(let error):
                DLog(message: "Error in upload: \(error.localizedDescription)")
                completion(false,nil)
            }
        }
        
    }
    
    //MARK:- Edit User profile
    
    func editUserProfile(with aliasName: String, partyAffiliation: String, location: String, completion: @escaping (_ success: Bool, _ response: Any) -> ()) {
        let params = ["user_id":USERID, "alias":aliasName,"party_affiliation":partyAffiliation,"location":location,"tnc_agree":"1"]
        print("param:\(params)")
        request(api: API_UPDATE_PROFILE, type: .post, parameters: params, complete: { (response) in
            completion(true,response)
        }) { (error) in
            completion(false,error)
        }
    }

}
