

import Foundation
struct PlayAndWinListModel : Codable {
	let id : String?
	let name : String?
	let type : String?
	let price : String?
	let image : String?
	let is_active : String?
	let end_date : String?
	let created_date : String?
	let modified_date : String?
	let purchased : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case type = "type"
		case price = "price"
		case image = "image"
		case is_active = "is_active"
		case end_date = "end_date"
		case created_date = "created_date"
		case modified_date = "modified_date"
		case purchased = "purchased"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		price = try values.decodeIfPresent(String.self, forKey: .price)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		is_active = try values.decodeIfPresent(String.self, forKey: .is_active)
		end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
		created_date = try values.decodeIfPresent(String.self, forKey: .created_date)
		modified_date = try values.decodeIfPresent(String.self, forKey: .modified_date)
		purchased = try values.decodeIfPresent(String.self, forKey: .purchased)
	}

}
