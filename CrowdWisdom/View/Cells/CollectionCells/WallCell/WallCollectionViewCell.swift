//
//  WallCollectionViewCell.swift
//  CrowdWisdom
//
//  Created by Sunday on 30/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import UICircularProgressRing

class WallCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var progressContainerView: UIView!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var progressView = UICircularProgressRing()
    
    var cellType: WallCellType = WallCellType.like {
        didSet {
            switch cellType {
            case .like:
                imageView.image = UIImage(named: "like-1")
                progressLabel.textColor = GREEN_COLOR
                progressView.innerRingColor = GREEN_COLOR
                label.text = "Like"
            case .dislike:
                imageView.image = UIImage(named: "dislike")
                progressLabel.textColor = RED_COLOR
                progressView.innerRingColor = RED_COLOR
                label.text = "Dislike"

            case .neutral:
                imageView.image = UIImage(named: "neutral")?.transform(withNewColor: BLUE_COLOR)
                
                progressLabel.textColor = BLUE_COLOR
                progressView.innerRingColor = BLUE_COLOR
                label.text = "Neutral"
                
            }
        }
    }
    
    var showProgress = false {
        didSet {
            progressView.startProgress(to: progress, duration: 2.0)
        }
    }
    
    var progress: CGFloat = 0.0 {
        didSet {
            showProgress = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        progressView.frame = progressContainerView.frame
        progressContainerView.addSubview(progressView)
        progressView.delegate = self
        progressView.shouldShowValueText = false
        progressView.outerRingWidth = 1
        progressView.outerRingColor = UIColor.lightGray
        progressView.innerRingWidth = 3
        progressView.startAngle = 90
        progressView.isClockwise = true
        progressView.maxValue = 100
        progressView.minValue = 0
    }
    
}

extension WallCollectionViewCell: UICircularProgressRingDelegate {
    func didUpdateProgressValue(for ring: UICircularProgressRing, to newValue: UICircularProgressRing.ProgressValue) {
//        DLog(message: newValue)
//        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: newValue)){
            progressLabel.text = "\(Int(newValue))%"
//        }
    }
    
}

enum WallCellType: String {
    case like = "Like"
    case dislike = "Dislike"
    case neutral = "Neutral"
}
