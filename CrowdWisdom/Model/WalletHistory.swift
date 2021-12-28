//
//  WalletHistory.swift
//  CrowdWisdom
//
//  Created by Sunday on 27/11/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation
struct WalletHistory : Decodable {
    let status : Bool?
    let message : String?
    let pointsHistory : [PointsHistory]?
    let isAvailable : String?
    let points : String?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case pointsHistory = "points_history"
        case isAvailable = "is_available"
        case points = "points"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        points = try values.decodeIfPresent(String.self, forKey: .points)
        pointsHistory = try values.decodeIfPresent([PointsHistory]?.self, forKey: .pointsHistory) as? [PointsHistory]
        isAvailable = try values.decodeIfPresent(String.self, forKey: .isAvailable)

    }
    
}

struct PointsHistory:Decodable {
    let date : String?
    let topic : String?
    let category : String?
    let action : String?
    let points : String?
    let value : String?
    let id : String?
    let postId : String?
    let userId : String?
    let choiceId : String?

    enum CodingKeys: String, CodingKey {
        case date = "date"
        case topic = "topic"
        case category = "category"
        case action = "action"
        case points = "points"
        case value = "value"
        case id = "id"
        case postId = "post_id"
        case userId = "user_id"
        case choiceId = "choice_id"
        
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        topic = try values.decodeIfPresent(String.self, forKey: .topic)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        action = try values.decodeIfPresent(String.self, forKey: .action)
        points = try values.decodeIfPresent(String.self, forKey: .points)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        postId = try values.decodeIfPresent(String.self, forKey: .postId)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        choiceId = try values.decodeIfPresent(String.self, forKey: .choiceId)
    }

}

