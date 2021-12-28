//
//  SearchList.swift
//  CrowdWisdom
//
//  Created by Sunday on 26/11/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation

struct SearchList : Codable {
    let status : Bool
    let message : String
    let data : [SearchData]
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status) ?? false
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        data = try values.decodeIfPresent([SearchData].self, forKey: .data) ?? [SearchData]()
    }
    
}

struct SearchData : Codable {
    let id : String
    let topic : String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case topic = "topic"
        case icon = "icon"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        topic = try values.decodeIfPresent(String.self, forKey: .topic) ?? ""
        icon = try values.decodeIfPresent(String.self, forKey: .icon) ?? ""
    }
    
    init(id: String, topic: String, icon: String ) {
        self.id = id
        self.topic = topic
        self.icon = icon
    }
    
}
