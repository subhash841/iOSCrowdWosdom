//
//  File.swift
//  CrowdWisdom
//
//  Created by sunday on 12/11/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation

struct PurchasePackageModel : Codable {
    let status : Bool?
    let message : String?
    let question_ids : [String]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case question_ids = "question_ids"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        question_ids = try values.decodeIfPresent([String].self, forKey: .question_ids)
    }
    
}
