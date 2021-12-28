
import Foundation
struct TopicListModel : Codable {
	let id : String?
	let topic : String?
	let image : String?
	let icon : String?
	let is_follow : Int?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case topic = "topic"
		case image = "image"
		case icon = "icon"
		case is_follow = "is_follow"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		topic = try values.decodeIfPresent(String.self, forKey: .topic)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		icon = try values.decodeIfPresent(String.self, forKey: .icon)
		is_follow = try values.decodeIfPresent(Int.self, forKey: .is_follow)
	}

}
