//
//  Reply.swift
//  CrowdWisdom
//
//  Created by Sunday on 01/11/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation

struct Reply: Codable {
    let status: Bool
    let message: String
    let data: [ReplyData]
    let isAvailable: String

    enum CodingKeys: String, CodingKey {
        case status, message, data
        case isAvailable = "is_available"
    }
}

struct ReplyData: Codable {
    let id, commentID, userID: String?
    let pollID: String?
    let reply, isActive, createdDate, replyID: String?
    let alias: String?
    var isEdit: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case pollID = "poll_id"
        case commentID = "comment_id"
        case userID = "user_id"
        case reply
        case isActive = "is_active"
        case createdDate = "created_date"
        case replyID = "reply_id"
        case alias
        case isEdit
    }
}

// MARK: Convenience initializers

extension Reply {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Reply.self, from: data) else { return nil }
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

extension ReplyData {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(ReplyData.self, from: data) else { return nil }
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
