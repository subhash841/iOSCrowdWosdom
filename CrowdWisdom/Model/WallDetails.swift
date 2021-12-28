////
////  WallDetails.swift
////  CrowdWisdom
////
////  Created by ITRS-676 on 11/23/18.
////  Copyright © 2018 Gaurav. All rights reserved.
////
//

import Foundation

struct WallDetails: Codable {
    let status: Bool?
    let message: String?
    var data: WallData
}

struct WallData: Codable {
    let id, userID, title, image: String?
    var totalLike, totalDislike, totalNeutral, totalComments: String?
    let createdDate, alias, isUserLike, isUserDislike, raisedByAdmin: String?
    let isUserNeutral: String?
    let topics: [Topic]
    let comments: [CommentData]
    let moreComments: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case title, image
        case totalLike = "total_likes"
        case totalDislike = "total_dislike"
        case totalNeutral = "total_neutral"
        case totalComments = "total_comments"
        case createdDate = "created_date"
        case alias
        case isUserLike = "is_user_like"
        case isUserDislike = "is_user_dislike"
        case isUserNeutral = "is_user_neutral"
        case topics, comments
        case moreComments = "more_comments"
        case raisedByAdmin = "raised_by_admin"
    }
}

struct Topic: Codable {
    let topicID, type, topic: String?

    enum CodingKeys: String, CodingKey {
        case topicID = "topic_id"
        case type, topic
    }
}
