

import Foundation
struct YourVoiceListModel : Codable {
	let id : String?
	let user_id : String?
	let name : String?
	let category_id : String?
	let sub_category_id : String?
	let title : String?
	let description : String?
	let image : String?
	let blog_date : String?
	let total_likes : String?
	let total_comments : String?
	let total_views : String?
	let link : String?
	let type : String?
	let is_approve : String?
	let is_active : String?
	let blog_order : String?
	let created_date : String?
	let modified_date : String?
	let alias : String?
	let category : String?
	let total_like_comment : String?
	let meta_keywords : String?
	let meta_description : String?
	let is_user_liked : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case user_id = "user_id"
		case name = "name"
		case category_id = "category_id"
		case sub_category_id = "sub_category_id"
		case title = "title"
		case description = "description"
		case image = "image"
		case blog_date = "blog_date"
		case total_likes = "total_likes"
		case total_comments = "total_comments"
		case total_views = "total_views"
		case link = "link"
		case type = "type"
		case is_approve = "is_approve"
		case is_active = "is_active"
		case blog_order = "blog_order"
		case created_date = "created_date"
		case modified_date = "modified_date"
		case alias = "alias"
		case category = "category"
		case total_like_comment = "total_like_comment"
		case meta_keywords = "meta_keywords"
		case meta_description = "meta_description"
		case is_user_liked = "is_user_liked"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		category_id = try values.decodeIfPresent(String.self, forKey: .category_id)
		sub_category_id = try values.decodeIfPresent(String.self, forKey: .sub_category_id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		blog_date = try values.decodeIfPresent(String.self, forKey: .blog_date)
		total_likes = try values.decodeIfPresent(String.self, forKey: .total_likes)
		total_comments = try values.decodeIfPresent(String.self, forKey: .total_comments)
		total_views = try values.decodeIfPresent(String.self, forKey: .total_views)
		link = try values.decodeIfPresent(String.self, forKey: .link)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		is_approve = try values.decodeIfPresent(String.self, forKey: .is_approve)
		is_active = try values.decodeIfPresent(String.self, forKey: .is_active)
		blog_order = try values.decodeIfPresent(String.self, forKey: .blog_order)
		created_date = try values.decodeIfPresent(String.self, forKey: .created_date)
		modified_date = try values.decodeIfPresent(String.self, forKey: .modified_date)
		alias = try values.decodeIfPresent(String.self, forKey: .alias)
		category = try values.decodeIfPresent(String.self, forKey: .category)
		total_like_comment = try values.decodeIfPresent(String.self, forKey: .total_like_comment)
		meta_keywords = try values.decodeIfPresent(String.self, forKey: .meta_keywords)
		meta_description = try values.decodeIfPresent(String.self, forKey: .meta_description)
		is_user_liked = try values.decodeIfPresent(String.self, forKey: .is_user_liked)
	}

}
