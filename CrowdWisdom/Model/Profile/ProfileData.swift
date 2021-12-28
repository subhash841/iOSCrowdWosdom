//
//  ProfileData.swift
//  CrowdWisdom
//
//  Created by  user on 11/27/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation
struct ProfileData: Decodable {
    let alias : String?
    let email : String?
    let id : String?
    let location : String?
    let party_affiliation : String?
    let points : String?
    let total_gold : String?
    let total_silver : String?
    let total_diamond : Int?

    enum CodingKeys: String, CodingKey {
        case alias = "alias"
        case email = "email"
        case id = "id"
        case location = "location"
        case party_affiliation = "party_affiliation"
        case points = "points"
        case total_gold = "total_gold"
        case total_silver = "total_silver"
        case total_diamond = "total_diamond"
        
        }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        alias = try values.decodeIfPresent(String.self, forKey: .alias)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        party_affiliation = try values.decodeIfPresent(String.self, forKey: .party_affiliation)
        points = try values.decodeIfPresent(String.self, forKey: .points)
        total_gold = try values.decodeIfPresent(String.self, forKey: .total_gold)
        total_silver = try values.decodeIfPresent(String.self, forKey: .total_silver)
        total_diamond = try values.decodeIfPresent(Int.self, forKey: .total_diamond)
    }
    
}
