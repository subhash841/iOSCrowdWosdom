
import Foundation
struct HomeModel : Codable {
	let status : Bool?
	let message : String?
    let is_follow : Int?
	let topic_name : String?
    let data : HomeDataModel?
    let versionCode : String?
    
	enum CodingKeys: String, CodingKey {

		case status = "status"
		case message = "message"
		case data = "data"
        case topic_name = "topic_name"
        case is_follow = "is_follow"
        case versionCode = "version_code"
        
    }

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(Bool.self, forKey: .status)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		data = try values.decodeIfPresent(HomeDataModel.self, forKey: .data)
        topic_name = try values.decodeIfPresent(String.self, forKey: .topic_name)
        is_follow = try values.decodeIfPresent(Int.self, forKey: .is_follow)
        versionCode = try values.decodeIfPresent(String.self, forKey: .versionCode)
	}

}
