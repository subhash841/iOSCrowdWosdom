//
//  UserProfile.swift
//  CrowdWisdom
//
//  Created by  user on 11/27/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation
struct UserProfile : Decodable {
    let status : Bool?
    let message : String?
    let user_data : ProfileData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case user_data = "user_data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        user_data = try values.decodeIfPresent(ProfileData.self, forKey: .user_data)
    }
    
}
