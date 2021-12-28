//
//  NoticicationList.swift
//  CrowdWisdom
//
//  Created by sunday on 1/2/19.
//  Copyright © 2019 Gaurav. All rights reserved.
//

import Foundation
struct NoticicationList : Decodable {
    let status : Bool?
    let message : String?
    let notificationData : [NotificationData]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case notificationData = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        notificationData = try values.decodeIfPresent([NotificationData]?.self, forKey: .notificationData) as? [NotificationData]
    }
    
}

struct NotificationData:Decodable {
    let id : String?
    let ownId : String?
    let postId : String?
    let title : String?
    let text : String?
    let type : String?
    let subtype : String?
    let image : String?
    let commentId : String?
    let createdDate : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case ownId = "own_id"
        case postId = "post_id"
        case title = "title"
        case text = "text"
        case type = "type"
        case subtype = "subtype"
        case image = "image"
        case commentId = "comment_id"
        case createdDate = "created_date"
        
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        ownId = try values.decodeIfPresent(String.self, forKey: .ownId)
        postId = try values.decodeIfPresent(String.self, forKey: .postId)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        subtype = try values.decodeIfPresent(String.self, forKey: .subtype)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        commentId = try values.decodeIfPresent(String.self, forKey: .commentId)
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
    }
    
}
