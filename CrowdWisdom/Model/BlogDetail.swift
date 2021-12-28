import Foundation

struct BlogDetail : Codable {
    let status : Bool?
    let message : String?
    let data : BlogData?
    let is_available : String?
    
    enum CodingKeys: String, CodingKey {
        
        case status 
        case message = "message"
        case data = "data"
        case is_available = "is_available"
    }
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        status = try values.decodeIfPresent(Bool.self, forKey: .status) ?? false
////        let stat = try values.decode(Int.self, forKey: .status) == 1 ? true : false
////        status = stat
////        if let sta: String = try values.decodeIfPresent(String.self, forKey: .status) {
////            status = sta.lowercased() == "1" ? true : false
////        } else {
////            status = false
////        }
//        message = try values.decodeIfPresent(String.self, forKey: .message)
//        data = try values.decodeIfPresent(BlogData.self, forKey: .data)
//        is_available = try values.decodeIfPresent(String.self, forKey: .is_available)
//    }
    
}

struct BlogData : Codable {
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
    let meta_keywords : String?
    let meta_description : String?
    let is_user_liked : String?
    let comments : [CommentData]?
    let more_comments : String?
    let raisedByAdmin: String?
    
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
        case meta_keywords = "meta_keywords"
        case meta_description = "meta_description"
        case is_user_liked = "is_user_liked"
        case comments = "comments"
        case more_comments = "more_comments"
        case raisedByAdmin = "raised_by_admin"
    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(String.self, forKey: .id)
//        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//        category_id = try values.decodeIfPresent(String.self, forKey: .category_id)
//        sub_category_id = try values.decodeIfPresent(String.self, forKey: .sub_category_id)
//        title = try values.decodeIfPresent(String.self, forKey: .title)
//        description = try values.decodeIfPresent(String.self, forKey: .description)
//        image = try values.decodeIfPresent(String.self, forKey: .image)
//        blog_date = try values.decodeIfPresent(String.self, forKey: .blog_date)
//        total_likes = try values.decodeIfPresent(String.self, forKey: .total_likes)
//        total_comments = try values.decodeIfPresent(String.self, forKey: .total_comments)
//        total_views = try values.decodeIfPresent(String.self, forKey: .total_views)
//        link = try values.decodeIfPresent(String.self, forKey: .link)
//        type = try values.decodeIfPresent(String.self, forKey: .type)
//        is_approve = try values.decodeIfPresent(String.self, forKey: .is_approve)
//        is_active = try values.decodeIfPresent(String.self, forKey: .is_active)
//        blog_order = try values.decodeIfPresent(String.self, forKey: .blog_order)
//        created_date = try values.decodeIfPresent(String.self, forKey: .created_date)
//        modified_date = try values.decodeIfPresent(String.self, forKey: .modified_date)
//        alias = try values.decodeIfPresent(String.self, forKey: .alias)
//        category = try values.decodeIfPresent(String.self, forKey: .category)
//        meta_keywords = try values.decodeIfPresent(String.self, forKey: .meta_keywords)
//        meta_description = try values.decodeIfPresent(String.self, forKey: .meta_description)
//        is_user_liked = try values.decodeIfPresent(String.self, forKey: .is_user_liked)
//        comments = try values.decodeIfPresent([Comment].self, forKey: .comments)
//        more_comments = try values.decodeIfPresent(String.self, forKey: .more_comments)
//    }
    
}

