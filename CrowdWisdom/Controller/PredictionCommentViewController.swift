//
//  PredictionCommentViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 01/11/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class PredictionCommentViewController: NavigationBaseViewController {

    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var commentViewHeight: NSLayoutConstraint!
    
    lazy var commentsViewController = storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
    
    var id = 0
    var type: CardType?
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        setCommentsView()
        self.setupLeftBarButton(isback: true)
    }
    
    func setCommentsView(){
        
        commentViewHeight.constant = commentsViewController.view.frame.height
        commentsView.frame = commentsViewController.view.frame
        commentsViewController.id = id
        if let typ = type {
            commentsViewController.type = typ
        }
        commentsViewController.delegate = self
        self.addChild(commentsViewController)
        commentsView.addSubview(commentsViewController.view)
        self.view.layoutIfNeeded()
    }
}

extension PredictionCommentViewController: CommentsViewDelegate {
    func updateViewFrame(height: CGFloat) {
        commentViewHeight.constant = height + 60
    }
}
