//
//  ViewControllerExtension.swift
//  CrowdWisdom
//
//  Created by Sunday on 23/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = "", message: String, completion: @escaping () -> () = {  }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                completion()
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        present(alert, animated: true, completion: nil)
    }
    
    
}
