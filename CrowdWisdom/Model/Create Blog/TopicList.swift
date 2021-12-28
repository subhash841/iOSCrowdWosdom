

import Foundation
struct TopicList : Codable {
	let status : Bool?
	let message : String?
	let data : [TopicData]?
    let is_available: String?
    
	enum CodingKeys: String, CodingKey {

		case status = "status"
		case message = "message"
		case data = "data"
        case is_available = "is_available"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Bool.self, forKey: .status)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		data = try values.decodeIfPresent([TopicData].self, forKey: .data)
        is_available = try values.decodeIfPresent(String.self, forKey: .is_available)
	}

}
