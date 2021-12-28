//
//  CategoryListViewController.swift
//  CrowdWisdom
//
//  Created by Sunday on 08/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class CategoryListViewController: UIViewController {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func getCategory(index: Int) -> Categories {
        switch index {
        case 0:
            return Categories.prediction
        case 1:
            return Categories.askQuestion
        //case 2:
            //return Categories.game
        //case 3:
            //return Categories.yourVoice
        case 4:
            return Categories.ratedArticles
        case 5:
            return Categories.wall
        default:
            return Categories.prediction
        }
    }

}
//MARK:- Category Enum
enum Categories: String {
    case prediction = "Prediction"
    case askQuestion = "Ask Questions"
    case game = "Game"
    case yourVoice = "Your Voice"
    case ratedArticles = "Rated Articles"
    case wall = "Wall"
    
    
}

//MARK: - Collection View Delegates, DataSource, Layout

extension CategoryListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: CategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        let category = getCategory(index: indexPath.row)

        cell.categoryNameLabel.text = category.rawValue
        cell.categoryImageView.image = UIImage(named: category.rawValue)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc: CardListViewControler = storyboard?.instantiateViewController(withIdentifier: "CardListViewControler") as! CardListViewControler
        
        // TODO: Set Category ID in Card VC

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Collection View Cell Size and Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = collectionView.bounds.width/2.0 - 5
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}


