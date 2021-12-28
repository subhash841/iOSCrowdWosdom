//
//  LoginViewController.swift
//  CrowdWisdom
//
//  Created by  user on 7/24/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import Foundation
import FacebookLogin
import FacebookCore
import TwitterKit
import GoogleSignIn
import PopupDialog

protocol LoginViewDelegate {
    func loginSuccessful()
}

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var bgImageView: JBKenBurnsView!
    @IBOutlet weak var gmailSignInButton: GIDSignInButton!
    @IBOutlet weak var termsConditionLbl: FRHyperLabel!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var closeImageView: UIImageView!
    
    var kenBurnImages = [UIImage]()
    var indexToShow = 1
    var alternate = false , sidealter = false
    var isPrivacyPolicy = false
    var isTab = false
    var isFromAction = false
    var delegate: LoginViewDelegate?
    var isFirstTimeSkip = false
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromAction {
            skipButton.setTitle("SKIP", for: .normal)
//            closeImageView.isHidden = false
            
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        kenBurnImages = [UIImage(named: "Login-1"), UIImage(named: "Login-2"),UIImage(named: "Login-3"),UIImage(named: "Login-4")] as! [UIImage]
        agreeButton.isSelected = true	
//        bgImageView.animate(withImages: kenBurnImages, transitionDuration: 4, initialDelay: 0, loop: true, isLandscape: true)
        addGestureToTermsLabel()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bgImageView.animate(withImages: kenBurnImages, transitionDuration: 4, initialDelay: 0, loop: true, isLandscape: true)

        /*let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.isHidden = true*/
        if isTab { self.tabBarController?.tabBar.isHidden = true }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bgImageView.stopAnimation()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func addGestureToTermsLabel() {
        /*let tap = UITapGestureRecognizer(target: self, action: #selector(opentermCondtionView))
        termsConditionLbl.addGestureRecognizer(tap)*/
        
        let handler = {
            (hyperLabel: FRHyperLabel!, substring: String!) -> Void in
            self.opentermCondtionView()
            //action here
        }
        //Step 3: Add link substrings
        
        termsConditionLbl.setLinksForSubstrings(["Terms & Condition & Privacy Policy"], withLinkHandler: handler)
//        termsConditionLbl.setLinksForSubstrings(["Privacy Policy"], withLinkHandler: handler)
        
    }
    
    //MARK:- Actions
    
    @IBAction func playANdWinBtnAction(_ sender: Any) {
        let playVC = PlayAndWinViewController(nibName: "PlayAndWinViewController", bundle: nil)
        self.navigationController?.pushViewController(playVC, animated: true)
        
    }
    
    @IBAction func navigationbutton(_ sender: Any) {
       /* let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeContainerViewController") as! HomeContainerViewController
        self.navigationController?.pushViewController(vc, animated: true)*/
        
    }
    
    @IBAction func agreeBtnAction(_ sender: Any) {
        if agreeButton.isSelected == true{
            agreeButton.isSelected = false
            agreeButton.setImage(UIImage(named: "uncheckIcon"), for: .normal)
        }else
        {
            agreeButton.isSelected = true
            agreeButton.setImage(UIImage(named: "checkIcon"), for: .normal)
        }
    }
    
    //MARK:- Social Login Methods
    
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
        if agreeButton .isSelected {
            if NetworkStatus.shared.haveInternet() {
                doFacebookLogin()
            } else {
                self.showAlert(message: NO_INTERNET)
            }
        }
        else
        {
            showAlert(message: "Please accept the terms and conditions to proceed.")
        }
        
    }
    
    @IBAction func twitterButtonTapped(_ sender: Any) {
        
        if agreeButton.isSelected {
            if NetworkStatus.shared.haveInternet() {
                doTwitterLogin()
            } else {
                self.showAlert(message: NO_INTERNET)
            }
        } else {
            self.showAlert(message: "Please accept the terms and conditions to proceed.")
        }
    }
    
    @IBAction func gmailButtonTapped(_ sender: Any) {
        if agreeButton .isSelected {
            if NetworkStatus.shared.haveInternet() {
                doGoogleLogin()
            } else {
                self.showAlert(message: NO_INTERNET)
            }
        }else
        {
            showAlert(message: "Please accept the terms and conditions to proceed.")
        }
    }
    
    private func doFacebookLogin() {
        let facebookLoginManager = LoginManager()
        
        facebookLoginManager.logIn(readPermissions: [.publicProfile], viewController: self) { (result) in
            switch result {
            case .success( _, _, let accessToken):
                DLog(message: accessToken)
                
                //                loginUser(with: dict)
                let request = GraphRequest.init(graphPath: "me", parameters: ["fields":"first_name,last_name,email"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
                
                request.start({ (response, requestResult) in
                    switch requestResult{
                    case .success(let response):
                        //                        let dict = ["name":, "social_id":userId, "email": email, "login_type":"Google", "twitter_handle":""]
                       // guard let firstName = response.dictionaryValue?["first_name"] as? String, let lastName = response.dictionaryValue?["last_name"] as? String , let email = response.dictionaryValue?["email"], let id = accessToken.userId else { return }
                        
                        guard let id = accessToken.userId else {
                            self.showAlert(message: "There is something wrong while sign in with Facebook. Please try again after sometime")
                            return
                        }
                        
                        var firstName = ""; var lastName = ""; var email = ""
                        if let first = response.dictionaryValue?["first_name"] as? String {
                            firstName = first
                        }
                        if let last = response.dictionaryValue?["last_name"] as? String {
                            lastName = last
                        }
                        if let emaill = response.dictionaryValue?["email"] as? String {
                            email = emaill
                        }
        
                        let dict = ["name":firstName + " " + lastName , "social_id":id, "email": email, "login_type":"Facebook", "twitter_handle":""]
                        self.loginUser(with: dict)
                        
                    case .failed(let error):
                        print("error start:\(error.localizedDescription)")
                    }
                })
                
            case .cancelled:
                print("user cancelled log in")
            case .failed(let error):
                print("error:\(error)")
            }
        }
    }
    
    private func doTwitterLogin() {
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(session?.userName ?? "")")
                let client = TWTRAPIClient.withCurrentUser()
                let dict = ["name":session?.userName ?? "", "social_id":session?.userID ?? "", "email": "", "login_type": "Twitter", "twitter_handle":""]
                
                self.loginUser(with: dict as [String : Any])
                
                client.requestEmail { email, error in
                    if (email != nil) {
                        print("signed in as \(session?.userName ?? "")")
                    } else {
                        print("error: \(error?.localizedDescription ?? "")")
                    }
                }
                
            } else {
                print("error: \(error?.localizedDescription ?? "")")
            }
        })

    }
    
    private func doGoogleLogin() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func skipButtonTapped(_ sender: Any) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        if isFromAction {
            if isTab {
                self.tabBarController?.selectedIndex = 1
                self.tabBarController?.tabBar.isHidden = false
//                let cardView = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
//                self.navigationController?.pushViewController(cardView, animated: false)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            USERID = "0"
            //        self.navigationController?.pushViewController(vc, animated: true)
            
            let cardView = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
            self.navigationController?.pushViewController(cardView, animated: false)
        }
    }
    
    //MARK:- Navigations
    
    @IBAction func termConditionButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let termsVC = storyboard.instantiateViewController(withIdentifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
        termsVC.type = getURL.TermsCondition
        self.navigationController?.pushViewController(termsVC, animated: true)
    }
    
    @objc private func opentermCondtionView() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let termsVC = storyboard.instantiateViewController(withIdentifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
        termsVC.type = getURL.TermsCondition
        self.navigationController?.pushViewController(termsVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTermsAndCondition"{
            if let destinationVc = segue.destination as? TakingUserDataViewController{
                destinationVc.isFromLogin = false
            }
        }
    }
    
    private func navigate(to alies: String) {
        if alies == "" {
            showAliasPopup()
        } else {
            // marking that user is login now. Next time no need to ask him login again
            UserDefaults.standard.set(true, forKey: IS_USER_LOGIN)
            UserDefaults.standard.synchronize()
            
            if isFromAction {
                delegate?.loginSuccessful()
                self.dismiss(animated: true, completion: nil)
            } else {
                let cardView = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
                self.navigationController?.pushViewController(cardView, animated: false)
            }
        }
    }
}

//MARK:- Alias Alert and API call
extension LoginViewController {
    
    private func showAliasPopup() {
        let aliasPopUpVC = AliasPopUpViewController(nibName: "AliasPopUpViewController", bundle: nil)
        aliasPopUpVC.isEdit = false
        aliasPopUpVC.delegate = self
        // Create the dialog
        let popup = PopupDialog(viewController: aliasPopUpVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                tapGestureDismissal: false,
                                panGestureDismissal: false)
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
}

    //MARK:- Google - Sign In Delegate
extension LoginViewController: GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            DLog(message: error)
        } else {
            guard let userId = user.userID, let fullName = user.profile.name, let email = user.profile.email else { return }
            
            let dict = ["name":fullName, "social_id":userId, "email": email, "login_type":"Google", "twitter_handle":""]
            loginUser(with: dict)
        }
    }
    
    func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
    }
}

extension LoginViewController {
    func loginUser(with data: [String:Any]!) {
        if NetworkStatus.shared.haveInternet() {
            Loader.showAdded(to: self.view, animated: true)
            Service.sharedInstance.request(api: API_LOGIN, type: .post, parameters: data, complete: { (response) in
                do {
                    let userData = try decoder.decode(StatusResponse.self, from: response as! Data)
                    if userData.status ?? false {
                        let dict = ["id":userData.data?.id,
                                    "name":userData.data?.name ?? "",
                                    "email":userData.data?.email ?? "",
                                    "gold_points":userData.data?.gold_points ?? "",
                                    "silver_points":userData.data?.silver_points ?? "",
                                    "alias":userData.data?.alias ?? "",
                                    ]
                        USERID = userData.data?.id ?? ""
                        Common.shared.updateDeviceAPNsToken()
                        Common.shared.getUserPoints()
                        UserDefaults.standard.set(USERID, forKey: LOGGED_USER_ID)
                        UserDefaults.standard.synchronize()
                        
                        var userDict = Common.shared.getUserInfo()
                        for key in dict.keys {
                            userDict[key] = dict[key] ?? ""
                            NotificationCenter.default.post(name: Notification.Name(UpdateDrawerListingAfterLogin), object: nil)
                        }
                        Common.shared.setInfo(dict: userDict)
                        
                        /*Common.shared.loadInfo()
                        Common.shared.userInfoDict = dict as [String : Any]
                        Common.shared.saveInfo()*/
                        
                        if let token = userData.data?.token {
                            Common.shared.setToken(token: token)
                        }
                        Loader.hide(for: self.view, animated: true)
                        self.navigate(to: userData.data?.alias ?? "")
                    } else {
                        Loader.hide(for: self.view, animated: true)
                        self.showAlert(message: NO_VALID)
                    }
                } catch {
                    Loader.hide(for: self.view, animated: true)
                    self.showAlert(message: error.localizedDescription)
                }
                DLog(message: response)
            }) { (error) in
                Loader.hide(for: self.view, animated: true)
                DLog(message: error)
                self.showAlert(message: SERVER_DOWN_MSG)
            }
        } else {
            self.showAlert(message: NO_INTERNET)
        }
        
    }
}

//MARK:-  Alias Popup Delegate

extension LoginViewController: AliasPopUpDelegate {
    func updateData(with aliasName: String) {
        navigate(to: "card")
    }
}
