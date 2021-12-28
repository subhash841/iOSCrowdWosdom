
import Foundation
struct QuestionListModel : Codable {
	let id : String?
	let question : String?
	let description : String?
	let image : String?
	var total_votes : String?
	var total_comments : String?
	let engagement : String?
    let alias : String?
    
	enum CodingKeys: String, CodingKey {

		case id = "id"
		case question = "question"
		case description = "description"
		case image = "image"
		case total_votes = "total_votes"
		case total_comments = "total_comments"
		case engagement = "engagement"
        case alias = "alias"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		question = try values.decodeIfPresent(String.self, forKey: .question)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		total_votes = try values.decodeIfPresent(String.self, forKey: .total_votes)
		total_comments = try values.decodeIfPresent(String.self, forKey: .total_comments)
		engagement = try values.decodeIfPresent(String.self, forKey: .engagement)
        alias = try values.decodeIfPresent(String.self, forKey: .alias)
	}

}
