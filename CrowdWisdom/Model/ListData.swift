/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ListData : Decodable {
	let id : String?
	let user_id : String?
	let topic_id : String?
	let title : String?
	let image : String?
	var total_votes : String?
	var total_comments : String?
	let topic : String?
    let total_likes: String?
    let total_dislike : String?
    let total_neutral : String?
    let total_views : String?
    let raisedByAdmin: String?
    let question : String?
    let name : String?
    let price : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case user_id = "user_id"
		case topic_id = "topic_id"
		case title = "title"
		case image = "image"
		case total_votes = "total_votes"
		case total_comments = "total_comments"
        case total_likes = "total_likes"
		case topic = "topic"
        case total_dislike = "total_dislike"
        case total_neutral = "total_neutral"
        case total_views = "total_views"
        case raisedByAdmin = "raised_by_admin"
        case question = "question"
        case name = "name"
        case price = "price"
	}

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        topic_id = try values.decodeIfPresent(String.self, forKey: .topic_id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        total_votes = try values.decodeIfPresent(String.self, forKey: .total_votes)
        total_comments = try values.decodeIfPresent(String.self, forKey: .total_comments)
        topic = try values.decodeIfPresent(String.self, forKey: .topic)
        total_likes = try values.decodeIfPresent(String.self, forKey: .total_likes)
        total_dislike = try values.decodeIfPresent(String.self, forKey: .total_dislike)
        total_neutral = try values.decodeIfPresent(String.self, forKey: .total_neutral)
        total_views = try values.decodeIfPresent(String.self, forKey: .total_views)
        raisedByAdmin = try values.decodeIfPresent(String.self, forKey: .raisedByAdmin)
        question = try values.decodeIfPresent(String.self, forKey: .question)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        price = try values.decodeIfPresent(String.self, forKey: .price)

    }

}
