//
//  BlogViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 09/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import WebKit

protocol BlogRefreshCountDelegate {
    func refreshCommentCount(commentCount: Int)
    func refreshLikeCount(likesCount: Int)
}

class BlogViewController: NavigationBaseViewController {
    
    @IBOutlet weak var yourVoiceLabel: UILabel!
    @IBOutlet weak var blogTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var blogImageView: UIImageView!
    @IBOutlet weak var contentLabel: TTTAttributedLabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var blogDetailsLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var contentLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var commentsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var countDelegate: BlogRefreshCountDelegate?
    
    lazy var commentsViewController: RevisedCommentsViewController = storyboard?.instantiateViewController(withIdentifier: "RevisedCommentsViewController") as! RevisedCommentsViewController
    
    var blogId = String() {
        didSet {
            getBlogDetails()
        }
    }
    
    var blog: BlogDetail?
    var totalComment = Int()
    
    //MARK:- UI Setting
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLeftBarButton(isback: true)
        yourVoiceLabel.attributedText = Common.shared.attributedText(withString: "Your Voice", boldString: "Voice", font: Common.shared.getFont(type: .regular, size: 17))
        contentLabel.delegate = self
        setCommentsView()
        let likeImage = UIImage(named: "like")
        if let likeActiveImage = likeImage?.maskWithColor(color: BLUE_COLOR) {
            self.likeButton.setImage(likeActiveImage, for: .selected)
        } else {
            self.likeButton.setImage(UIImage(named: "like-active"), for: .selected)
        }
        self.likeButton.setTitleColor(BLUE_COLOR, for: .selected)
        
        self.emptyStateAction = {
            self.getBlogDetails()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUI()
        
    }
    
    func setUI() {
        blogDetailsLabel.font = Common.shared.getFont(type: .medium, size: 12)
        likeButton.contentHorizontalAlignment = .left
        shareButton.transform = .identity
        shareButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        shareButton.setImage(UIImage(named: "shareThreeDot")?.transform(withNewColor: UIColor.lightGray), for: .normal)

        //contentView.layer.shadowColor = UIColor.darkGray.cgColor
        //contentView.layer.shadowRadius = 3
        //contentView.layer.shadowOffset = CGSize.zero
        //contentView.layer.shadowOpacity = 0.3
    }
    
    func setCommentsView(){
        commentsViewHeight.constant = commentsViewController.view.frame.height + 40
        commentsView.frame = commentsViewController.view.frame
        commentsViewController.delegate = self
        self.addChild(commentsViewController)
        commentsView.addSubview(commentsViewController.view)
        self.view.layoutIfNeeded()
    }
    
    func setContent(with blogDetail: BlogDetail) {
        
        if let blogDescription = blogDetail.data?.description {
            do{
                //            descString = descString?.replacingOccurrences(of: "\n", with: "</br>").replacingOccurrences(of: "\t", with: "")
                let attrStr = try NSAttributedString(data: (blogDescription.data(using: String.Encoding.unicode, allowLossyConversion: false)!), options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
                _ = attrStr.boundingRect(with: CGSize(width: contentLabel.frame.width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
                
                /*contentLabel.frame = CGRect(x: contentLabel.frame.origin.x, y: contentLabel.frame.origin.y, width: contentLabel.frame.width, height: rect.height)
                 contentLabel.numberOfLines = 0
                 contentLabel.text = attrStr
                 //                contentLabel.enabledTextCheckingTypes = NSTextCheckingTypes.
                 
                 contentLabelHeight.constant = contentLabel.frame.height*/
                
                /*let contentLabel1 = UILabel(frame: CGRect(x: contentLabel.frame.origin.x, y: contentLabel.frame.origin.y+30, width: contentLabel.frame.width, height: rect.height+10))
                 contentLabel1.numberOfLines = 0
                 contentLabel1.attributedText = attrStr
                 contentLabelHeight.constant = contentLabel1.frame.height + 20
                 contentView.addSubview(contentLabel1)*/
                
                // with web
                var frame = contentLabel.frame
                frame.origin.y = contentLabel.frame.origin.y + 20
                let contentLabel1 = UIWebView(frame:frame)
                contentLabel1.loadHTMLString(blogDescription, baseURL: nil)
                let jsString = "var imgs = document.getElementsByTagName('img');for(var i =0;i<imgs.length;i++){imgs[i].width= screen.width * 0.9}"
                
                contentLabel1.stringByEvaluatingJavaScript(from: jsString)
                
                contentLabel1.scrollView.bounces  = false
                contentLabel1.delegate = self
                
//                let cssString = "<style> img{ width: 10vw; max-width: 100px; display: block  }"
//                let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style);"
//                contentLabel1.stringByEvaluatingJavaScript(from: jsString)
                
//                let contentWebView = WKWebView(frame: frame)
//                contentWebView.loadHTMLString(blogDescription, baseURL: nil)
//                contentWebView.scrollView.bounces = false
//                contentWebView.uiDelegate = self
//                contentWebView.navigationDelegate = self
                contentView.addSubview(contentLabel1)
//                contentView.addSubview(contentLabel1)
                
            }catch{
                print(error)
                //            DLog(message: error)
            }
        }
        guard let blogData = blogDetail.data else { return }
        

        let str = blogData.title ?? ""
        let newString = str.replacingOccurrences(of: "&#39;", with: "'")
        blogTitleLabel.text = newString
        
        contentLabel.isUserInteractionEnabled = true
        
        if let date = blogData.created_date, let alias = blogData.alias  {
            
            let dat = Common.shared.stringFromDateString(date: date, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "MMMM dd, yyyy", isUT: false)
            
            if let raisedBy = blogData.raisedByAdmin, raisedBy == "1"{
                dateLabel.text = "By "
                dateLabel.addImage(imageName: "logo_red", afterLabel: true, afterText: "| \(dat)")
            } else {
                dateLabel.text = "By \(alias) | \(dat)"
            }
        }
        dateLabel.font = Common.shared.getFont(type: .medium, size: 12)
        dateLabel.textColor = UIColor.darkGray
        
        blogDetailsLabel.isUserInteractionEnabled = true
        blogDetailsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCommentsView)))
        
        commentButton.addTarget(self, action: #selector(openCommentsView), for: .touchUpInside)
        likeButton.isSelected = blogData.is_user_liked ?? "0" == "1" ? true : false
        totalComment = Int(blogData.total_comments ?? "0") ?? 0
        let likeString = blogData.total_likes == "0" || blogData.total_likes == "1" ? "LIKE" : "LIKES"
        let commentString = blogData.total_comments == "0" || blogData.total_comments == "1" ? "COMMENT" : "COMMENTS"
        let ViewsString = blogData.total_views == "0" || blogData.total_views == "1" ? "VIEW" : "VIEWS"
        
        //blogDetailsLabel.text = "\u{2022} \(blogData.total_likes ?? "0") \(likeString) \u{2022} \(totalComment) \(commentString) \u{2022} \(blogData.total_views ?? "0") \(ViewsString)"
        
        blogDetailsLabel.text = "● \(blogData.total_likes ?? "0") \(likeString) ● \(totalComment) \(commentString) ● \(blogData.total_views ?? "0") \(ViewsString)"
        /*if let views = Int(blogData.total_views ?? "0") {
         if views > 0 {
         blogDetailsLabel.text = "\u{2022} \(blogData.total_likes ?? "0") \(likeString) \u{2022} \(totalComment) COMMENT \u{2022} \(views) VIEWS"
         } else {
         blogDetailsLabel.text = "\u{2022} \(blogData.total_likes ?? "0") \(likeString) \u{2022} \(totalComment) COMMENT \u{2022} \(views) VIEW"
         }
         }*/
        
        if let url = URL(string: blogData.image ?? "") {
            blogImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
            blogImageView.contentMode = .scaleAspectFit
        }
        scrollView.isHidden = false
        commentsViewController.isOnlyCommentsView = false
        commentsViewController.commentId = blogDetail.data?.id ?? "0"
        commentsViewController.type = CardType.voice
        //        commentsViewController.isAvailable = blogDetail.is_available ?? "0"
        commentsViewController.commentsArray = blogData.comments ?? [CommentData]()
        commentsViewController.isAvailable = blogData.more_comments ?? "0"
        //        commentsViewController.replyArray += [Reply?](repeating: Reply(data: Data()), count: commentsViewController.commentsArray.count)
        //self.replyArray = self.commentsArray.compactMap{ _ in return Reply() }
        //commentsViewController.sectionArray += [Bool](repeating: false, count: commentsViewController.commentsArray.count)
        commentsViewController.randomColors += commentsViewController.commentsArray.compactMap{ _ in return UIColor.random() }
        Common.shared.assignColorToUser {
            userArray = Set(commentsViewController.commentsArray.compactMap{ $0.userID })
        }
        commentsViewController.commentsTableView.reloadData()
    }
    
//    func HTMLImageCorrector(HTMLString: String) -> String {
//        var HTMLToBeReturned = HTMLString
//        while HTMLToBeReturned.rangeOfString("(?<=width=\")[^\" height]+", options: .RegularExpressionSearch) != nil{
//            if let match = HTMLToBeReturned.rangeOfString("(?<=width=\")[^\" height]+", options: .RegularExpressionSearch) {
//                HTMLToBeReturned.removeRange(match)
//                if let match2 = HTMLToBeReturned.rangeOfString("(?<=height=\")[^\"]+", options: .RegularExpressionSearch) {
//                    HTMLToBeReturned.removeRange(match2)
//                    let string2del = "width=\"\" height=\"\""
//                    HTMLToBeReturned = HTMLToBeReturned.stringByReplacingOccurrencesOfString( string2del, withString: "")
//                }
//            }
//            
//        }
//        
//        return HTMLToBeReturned
//    }
    
    
    //MARK:- Share Button Actions
    @IBAction func shareButtonTapped(_ sender: UIButton) {
    }
    @IBAction func facebookButtonTapped(_ sender: Any) {
    }
    @IBAction func twitterButtonTapped(_ sender: UIButton) {
    }
    @IBAction func linkedInButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func whatsappButtonTapped(_ sender: Any) {
    }
    
    @IBAction func shareVoiceButtonTapped(_ sender: Any) {
        var shareLink = ""
        shareLink = Common.shared.shareURL(id: blog?.data?.id ?? "", isVoice: 0)
        
        if let someText:String = blog?.data?.title {
            let objectsToShare = URL(string:shareLink)
            let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
            let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
            
        }
        
    }
    
    //MARK:- Button Action
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        if USERID == "0" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.isFromAction = true
            vc.delegate = self
            let nvc = UINavigationController(rootViewController: vc)
            self.present(nvc, animated: true, completion: nil)
        } else {
            likePost(sender: sender)
        }
    }
    //MARK:- Label Tap Action
    
    @objc func openCommentsView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RevisedCommentsViewController") as! RevisedCommentsViewController
        vc.isOnlyCommentsView = true
        vc.commentId = blog?.data?.id ?? "0"
        vc.delegate = self
        vc.refreshDataDelegate = self
        vc.type = CardType.voice
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension BlogViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let jsString = "var imgs = document.getElementsByTagName('img');for(var i =0;i<imgs.length;i++){imgs[i].width= screen.width * 0.9}"

        webView.stringByEvaluatingJavaScript(from: jsString)
        let height = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight")
        DLog(message: height)
//        webView.frame.size = webView.scrollView.contentSize
//        contentLabelHeight.constant = webView.frame.size.height
        
        DLog(message: "content: \(webView.scrollView.contentSize)")
        DLog(message: "frame: \(webView.frame)")
        
        var frame = contentLabel.frame
        
        frame.size.width = CGFloat(Device.SCREEN_WIDTH)
        frame.size.height = webView.scrollView.contentSize.height
        
        webView.frame = frame
        DLog(message: "content label frame: \(contentLabel.frame)")
        DLog(message: "frame: \(webView.frame)")

        contentLabelHeight.constant = webView.frame.size.height

//        let cssString = "<style>img{display: inline;height: auto;max-width: 100%;} p{color:blue}</style>"
        
//        contentLabel1.stringByEvaluatingJavaScript(from: jsString)
        
        
        
        
    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // Open links in Safari
            guard let url = request.url else { return true }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // openURL(_:) is deprecated in iOS 10+.
                UIApplication.shared.openURL(url)
            }
            return false
        default:
            // Handle other navigation types...
            return true
        }
    }
}

extension BlogViewController: WKUIDelegate, WKNavigationDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        webView.frame.size = webView.scrollView.contentSize
        contentLabelHeight.constant = webView.frame.size.height
        var frame = contentLabel.frame
        frame.size.height = webView.scrollView.contentSize.height
        webView.frame = frame
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.frame.size = webView.scrollView.contentSize
        contentLabelHeight.constant = webView.frame.size.height
        var frame = contentLabel.frame
        frame.size.height = webView.scrollView.contentSize.height
        webView.frame = frame
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        switch navigationAction.navigationType {
        case .linkActivated:
            guard let url = webView.url  else {
                decisionHandler(.cancel)
                return
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // openURL(_:) is deprecated in iOS 10+.
                UIApplication.shared.openURL(url)
            }
            decisionHandler(.allow)
        default:
            decisionHandler(.cancel)
            DLog(message: "Nothing")
        }
    }
}

extension BlogViewController: RevisedCommentsViewDelegate {
    
    func updateViewFrame(height: CGFloat) {
        if height > 20 {
            commentsViewHeight.constant = height + 40
        }
    }
    
    func updateComment(deleted: Bool) {
        totalComment = deleted ? totalComment - 1 : totalComment + 1
        countDelegate?.refreshCommentCount(commentCount: totalComment)
        if let blogData = blog?.data {
            
            let likeString = blogData.total_likes == "0" || blogData.total_likes == "1" ? "LIKE" : "LIKES"
            let commentString = totalComment == 0 || totalComment == 1 ? "COMMENT" : "COMMENTS"
            let ViewsString = blogData.total_views == "0" || blogData.total_views == "1" ? "VIEW" : "VIEWS"
            
            blogDetailsLabel.text = "\u{2022} \(blogData.total_likes ?? "0") \(likeString) \u{2022} \(totalComment) \(commentString) \u{2022} \(blogData.total_views ?? "0") \(ViewsString)"
        }
    }
    
}

//MARK:- API

extension BlogViewController {
    func getBlogDetails(showLoader: Bool = true) {
        if NetworkStatus.shared.haveInternet() {
            if showLoader { Loader.showAdded(to: self.view, animated: true) }
            Service.sharedInstance.request(api: API_VOICE_DETAIL, type: .post, parameters: ["id":blogId, "user_id": USERID], complete: { (response) in
                do {
                    let blogDetail = try decoder.decode(BlogDetail.self, from: response as! Data)
                    self.blog = blogDetail
                    self.setContent(with: blogDetail)
                    
                } catch {
                    self.showAlert(message: "\(error)")
                }
                self.hideEmptyStateView()
                Loader.hide(for: self.view, animated: true)
                
            }) { (error) in
                Loader.hide(for: self.view, animated: true)
                self.showAlert(message: "\(error)")
            }
        } else {
            self.setNoConnectionState()
            //            self.showAlert(message: NO_INTERNET)
        }
    }
    //PARAMS: LIKE
    //    "voice_id:123
    //    is_user_like:0
    //    user_id:5149"
    func likePost(sender: UIButton) {
        if NetworkStatus.shared.haveInternet() {
            let like = sender.isSelected ? "1" : "0"
            guard let blogData = blog else { return }
            let body = ["voice_id": blogData.data?.id ?? "0", "is_user_like":like, "user_id": USERID] as [String : Any]
            Service.sharedInstance.request(api: API_VOICE_LIKE, type: .post, parameters: body, complete: { (response) in
                do {
                    let likeData = try decoder.decode(LikeResponse.self, from: response as! Data)
                    
                    let likeString = likeData.data.totalLikes == "0" || likeData.data.totalLikes == "1" ? "LIKE" : "LIKES"
                    let commentString = self.totalComment == 0 || self.totalComment == 1 ? "COMMENT" : "COMMENTS"
                    let ViewsString = blogData.data?.total_views == "0" || blogData.data?.total_views == "1" ? "VIEW" : "VIEWS"
                    
                    self.blogDetailsLabel.text = "\u{2022} \(likeData.data.totalLikes ) \(likeString) \u{2022} \(self.totalComment) \(commentString) \u{2022} \(blogData.data?.total_views ?? "0") \(ViewsString)"
                    
                    sender.isSelected = !sender.isSelected
                    if let likeCount = Int(likeData.data.totalLikes) {
                        self.countDelegate?.refreshLikeCount(likesCount: likeCount)
                    }
                } catch {
                    DLog(message: error)
                } 
            }) { (error) in
                DLog(message: error)
            }
        } else {
            self.showAlert(message: NO_INTERNET)
            //            self.setNoConnectionState()
        }
    }
}

extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}

extension BlogViewController: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.openURL(url)
    }
}

extension BlogViewController: RefreshDataDelegate {
    func refreshData() {
        getBlogDetails(showLoader: false)
    }
}

extension BlogViewController: LoginViewDelegate {
    func loginSuccessful() {
        likePost(sender: likeButton)
    }
}
