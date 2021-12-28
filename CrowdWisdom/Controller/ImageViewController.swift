//
//  ImageViewController.swift
//  CrowdWisdom
//
//  Created by sunday on 1/8/19.
//  Copyright © 2019 Gaurav. All rights reserved.
//

import UIKit
import WebKit

class ImageViewController: NavigationBaseViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var contentDataView: UIView!
    var imageURL = ""
    let webView = WKWebView()
    var str = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isImageViewLoad = true
        self.setupLeftBarButton(isback: true)
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        webView.frame = CGRect(x: 0, y: 0, width: Device.SCREEN_HEIGHT , height:Device.SCREEN_WIDTH)
        if let imgURL = URL(string: imageURL) {
            webView.load(URLRequest(url: imgURL))
        }
        self.tabBarController?.tabBar.isHidden = true
        webView.scrollView.bounces  = false
        contentDataView.addSubview(webView)
        
//        mainImageView.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(named: "placeholder"))
//        mainImageView.contentMode = .scaleAspectFit
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
