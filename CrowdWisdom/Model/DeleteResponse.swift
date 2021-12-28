//
//  NewReply.swift
//  CrowdWisdom
//
//  Created by Sunday on 01/11/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation

struct DeleteResponse: Codable {
    let status: Bool
    let message: String
    let data: String?
}

// MARK: Convenience initializers

extension DeleteResponse {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(DeleteResponse.self, from: data) else { return nil }
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
