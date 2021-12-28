//
//  NewVoiceComment.swift
//  CrowdWisdom
//
//  Created by Sunday on 05/11/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation

struct NewVoiceComment : Decodable {
    let status : Bool?
    let message : String?
    let data : NewVoiceCommentData?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        if let value = try? values.decodeIfPresent(String.self, forKey: .data) {
            data = nil
        } else {
            data = try values.decodeIfPresent(NewVoiceCommentData.self, forKey: .data)
        }
        
    }
    
}

struct NewVoiceCommentData : Codable {
    let comment_id : String?
    
    enum CodingKeys: String, CodingKey {
        
        case comment_id = "comment_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        comment_id = try values.decodeIfPresent(String.self, forKey: .comment_id)
    }
    
}
