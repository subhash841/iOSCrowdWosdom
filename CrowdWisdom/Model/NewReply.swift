//
//  NewReply.swift
//  CrowdWisdom
//
//  Created by Sunday on 01/11/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation

struct NewReply: Codable {
    let status: Bool
    let message: String
    let data: NewReplyData?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status) ?? false
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent(NewReplyData.self, forKey: .data)
    }
    
}

struct NewReplyData: Codable {
    let id, pollID, commentID, userID: String?
    let reply, isActive, createdDate, commentReplyID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case pollID = "poll_id"
        case commentID = "comment_id"
        case userID = "user_id"
        case reply
        case isActive = "is_active"
        case createdDate = "created_date"
        case commentReplyID = "comment_reply_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
         id = try values.decodeIfPresent(String.self, forKey: .id )
         pollID = try values.decodeIfPresent(String.self, forKey: .pollID)
         commentID = try values.decodeIfPresent(String.self, forKey: .commentID)
         userID = try values.decodeIfPresent(String.self, forKey: .userID)
         reply = try values.decodeIfPresent(String.self, forKey: .reply)
         isActive = try values.decodeIfPresent(String.self, forKey: .isActive)
         createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
         commentReplyID = try values.decodeIfPresent(String.self, forKey: .commentReplyID)
    }
}
