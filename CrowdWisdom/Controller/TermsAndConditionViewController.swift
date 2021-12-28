//
//  TermsAndConditionViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 05/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

enum getURL:String{
    case TermsCondition
    case AboutUs
    case ImageView
}

class TermsAndConditionViewController: NavigationBaseViewController, WKNavigationDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var agreeButton: UIButton!
    
    let webView = WKWebView()
    var hud = MBProgressHUD()
    var type : getURL = getURL.TermsCondition
    var str = String()
    var isImageView  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        hud.show(animated: true)
        
        if isImageView == true {
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            isImageView = false
        }
    }
    
//    override func shouldAutorotate() -> Bool {
//        return true
//    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLeftBarButton(isback: true)
        webView.frame = CGRect(x: 5, y: 0, width: contentView.frame.width-10, height: contentView.frame.height)
        // set web view for type
        setWebView()
    }
    
    func setWebView() {
        webView.navigationDelegate = self
        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        switch type {
        case .TermsCondition:
            guard let urlTerms = URL(string: terms_and_conditions_link) else{ return }
            webView.loadHTMLString(termsAndConditionText, baseURL: nil)
                webView.load(URLRequest(url: urlTerms))
        case .AboutUs:
            guard let url = URL(string: about_us_link) else { return }
            webView.load(URLRequest(url: url))
            
        case .ImageView:
            
            guard let imgURL = URL(string: str) else { return }
            webView.load(URLRequest(url: imgURL))
        }
        webView.scrollView.bounces  = false
        contentView.addSubview(webView)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hud.hide(animated: true)
        agreeButton.isUserInteractionEnabled = true
    }
    
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        //perform segue
    }

}
