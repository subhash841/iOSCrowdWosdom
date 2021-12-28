//
//  RatedArticleDetails.swift
//  CrowdWisdom
//
//  Created by  user on 12/11/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation

struct RatedArticleDetails: Codable {
    let status: Bool
    let message: String
    var data: RatedArticleData?
}

struct RatedArticleData: Codable {
    let id, userID, title, description, alias: String?
    let image: String?
    let data: PreviewData?
    let raisedByAdmin: String?
    var totalLike, totalNeutral, totalDislike, totalComments: String?
    let metaKeywords, metaDescription: JSONNull?
    let isActive, createdDate, modifiedDate: String?
    let comments: [CommentData]?
    let topicAssociated: [TopicAssociated]?
    let moreComments: String?
    let userActions: [UserAction]
    let countActions: [CountAction]

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case title, description, image, data, alias
        case raisedByAdmin = "raised_by_admin"
        case totalLike = "total_like"
        case totalNeutral = "total_neutral"
        case totalDislike = "total_dislike"
        case totalComments = "total_comments"
        case metaKeywords = "meta_keywords"
        case metaDescription = "meta_description"
        case isActive = "is_active"
        case createdDate = "created_date"
        case modifiedDate = "modified_date"
        case comments
        case topicAssociated = "topic_associated"
        case moreComments = "more_comments"
        case userActions = "user_actions"
        case countActions = "count_actions"
    }
}


struct CountAction: Codable {
    let id, webID, userID, likes: String
    let dislikes, neutral, createdDate, modifiedDate: String
    let totalCounts, totalLikes, totalDislikes, totalNeutral: String

    enum CodingKeys: String, CodingKey {
        case id
        case webID = "web_id"
        case userID = "user_id"
        case likes, dislikes, neutral
        case createdDate = "created_date"
        case modifiedDate = "modified_date"
        case totalCounts = "total_counts"
        case totalLikes = "total_likes"
        case totalDislikes = "total_dislikes"
        case totalNeutral = "total_neutral"
    }
}

struct PreviewData: Codable {
    let link, img, domain, title: String?
    let description: String?
}

struct TopicAssociated: Codable {
    let topicID, type, topic: String

    enum CodingKeys: String, CodingKey {
        case topicID = "topic_id"
        case type, topic
    }
}

struct UserAction: Codable {
    let id, webID, userID, likes: String?
    let dislikes, neutral, createdDate, modifiedDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case webID = "web_id"
        case userID = "user_id"
        case likes, dislikes, neutral
        case createdDate = "created_date"
        case modifiedDate = "modified_date"
    }
}

// MARK: Convenience initializers

extension RatedArticleDetails {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(RatedArticleDetails.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension RatedArticleData {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(RatedArticleData.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Comment {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Comment.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension CountAction {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(CountAction.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension PreviewData {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(PreviewData.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension TopicAssociated {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(TopicAssociated.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension UserAction {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(UserAction.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

// MARK: Encode/decode helpers

class JSONNull: Codable {
    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

