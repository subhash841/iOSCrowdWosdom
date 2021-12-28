//
//  LikeResponse.swift
//  CrowdWisdom
//
//  Created by Sunday on 16/11/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation

struct LikeResponse: Codable {
    let status: Bool
    let message: String
    let data: LikeResponseData
}

struct LikeResponseData: Codable {
    let totalLikes: String

    enum CodingKeys: String, CodingKey {
        case totalLikes = "total_likes"
    }
}

// MARK: Convenience initializers

extension LikeResponse {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(LikeResponse.self, from: data) else { return nil }
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

extension LikeResponseData {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(LikeResponseData.self, from: data) else { return nil }
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
