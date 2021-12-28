

import Foundation
struct DiscussionListModel : Codable {
	let id : String?
	let title : String?
	let image : String?
	let total_like : String?
	let total_neutral : String?
	let total_dislike : String?
	let total_comments : String?
    let alias : String?
    
	enum CodingKeys: String, CodingKey {

		case id = "id"
		case title = "title"
		case image = "image"
		case total_like = "total_like"
		case total_neutral = "total_neutral"
		case total_dislike = "total_dislike"
		case total_comments = "total_comments"
        case alias = "alias"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		total_like = try values.decodeIfPresent(String.self, forKey: .total_like)
		total_neutral = try values.decodeIfPresent(String.self, forKey: .total_neutral)
		total_dislike = try values.decodeIfPresent(String.self, forKey: .total_dislike)
		total_comments = try values.decodeIfPresent(String.self, forKey: .total_comments)
        alias = try values.decodeIfPresent(String.self, forKey: .alias)
	}

}
