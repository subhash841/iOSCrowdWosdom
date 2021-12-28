//
//  File.swift
//  CrowdWisdom
//
//  Created by sunday on 12/11/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation

struct CompetitionInfoModel : Codable {
    let status : Bool?
    let message : String?
    let data : CompetitionInfoDataModel?
    let silver_points : String?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
        case silver_points = "silver_points"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(CompetitionInfoDataModel.self, forKey: .data)
        silver_points = try values.decodeIfPresent(String.self, forKey: .silver_points)
    }
}

struct CompetitionInfoDataModel : Codable {
    let id : String?
    let name : String?
    let prize_text : String?
    let point_required_text : String?
    let reward_text : String?
    let price : String?
    let image : String?
    let end_date : String?
    let prediction_count : String?
    let purchased: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case prize_text = "prize_text"
        case point_required_text = "point_required_text"
        case reward_text = "reward_text"
        case price = "price"
        case image = "image"
        case end_date = "end_date"
        case prediction_count = "prediction_count"
        case purchased = "purchased"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        prize_text = try values.decodeIfPresent(String.self, forKey: .prize_text)
        point_required_text = try values.decodeIfPresent(String.self, forKey: .point_required_text)
        reward_text = try values.decodeIfPresent(String.self, forKey: .reward_text)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
        prediction_count = try values.decodeIfPresent(String.self, forKey: .prediction_count)
        purchased = try values.decodeIfPresent(String.self, forKey: .purchased)
    }
    
}
