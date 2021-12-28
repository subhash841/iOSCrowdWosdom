//
//  NewComment.swift
//  CrowdWisdom
//
//  Created by Sunday on 01/11/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation
struct NewComment: Codable {
    let status: Bool
    let message: String
    let data: NewCommentData?
}

struct NewCommentData: Codable {
    let id, pollID, userID, comment: String?
    let totalLikes, totalReplies, isActive, createdDate: String?
    let commentID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case pollID = "poll_id"
        case userID = "user_id"
        case comment
        case totalLikes = "total_likes"
        case totalReplies = "total_replies"
        case isActive = "is_active"
        case createdDate = "created_date"
        case commentID = "comment_id"
    }
}

// MARK: Convenience initializers

extension NewComment {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(NewComment.self, from: data) else { return nil }
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

extension NewCommentData {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(NewCommentData.self, from: data) else { return nil }
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
