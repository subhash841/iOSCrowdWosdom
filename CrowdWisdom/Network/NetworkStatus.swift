//
//  NetworkStatus.swift
//  CrowdWisdom
//
//  Created by sunday on 10/5/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit

class NetworkStatus: NSObject {
    
    static let shared = NetworkStatus()
    
    func haveInternet() -> Bool {
        return Network.reachability?.isReachable ?? false
    }
}
