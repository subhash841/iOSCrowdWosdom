//
//  RatedArticleModel.swift
//  CrowdWisdom
//
//  Created by sunday on 11/21/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation

struct RatedArticleListModel : Codable {
    let id : String?
    let user_id : String?
    let question : String?
    let description : String?
    let image : String?
    let data : PreviewData?
    let total_like : String?
    let total_neutral : String?
    let total_dislike : String?
    let total_votes : String?
    let total_comments : String?
    let meta_keywords : String?
    let meta_description : String?
    let is_active : String?
    let created_date : String?
    let modified_date : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case user_id = "user_id"
        case question = "question"
        case description = "description"
        case image = "image"
        case data = "data"
        case total_like = "total_like"
        case total_neutral = "total_neutral"
        case total_dislike = "total_dislike"
        case total_votes = "total_votes"
        case total_comments = "total_comments"
        case meta_keywords = "meta_keywords"
        case meta_description = "meta_description"
        case is_active = "is_active"
        case created_date = "created_date"
        case modified_date = "modified_date"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        question = try values.decodeIfPresent(String.self, forKey: .question)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        data = try values.decodeIfPresent(PreviewData.self, forKey: .data)
        total_like = try values.decodeIfPresent(String.self, forKey: .total_like)
        total_neutral = try values.decodeIfPresent(String.self, forKey: .total_neutral)
        total_dislike = try values.decodeIfPresent(String.self, forKey: .total_dislike)
        total_votes = try values.decodeIfPresent(String.self, forKey: .total_votes)
        total_comments = try values.decodeIfPresent(String.self, forKey: .total_comments)
        meta_keywords = try values.decodeIfPresent(String.self, forKey: .meta_keywords)
        meta_description = try values.decodeIfPresent(String.self, forKey: .meta_description)
        is_active = try values.decodeIfPresent(String.self, forKey: .is_active)
        created_date = try values.decodeIfPresent(String.self, forKey: .created_date)
        modified_date = try values.decodeIfPresent(String.self, forKey: .modified_date)
    }
    
}
