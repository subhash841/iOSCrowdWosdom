/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct TypeDetail : Decodable {
    let alias : String?
	let id : String?
	let user_id : String?
	let topic_id : String?
	let category_id : String?
	let raised_by_admin : String?
	let title : String?
	let description : String?
	let preview : String?
	let url : String?
	let image : String?
	let total_votes : String?
	var total_comments : String?
	let average : String?
	let end_date : String?
	let created_date : String?
	let topic : String?
	let users_choice : String?
	let options : [Options]?
    let more_comments : String?
    let isMultiple: String?

	enum CodingKeys: String, CodingKey {

        case alias = "alias"
		case id = "id"
		case user_id = "user_id"
		case topic_id = "topic_id"
		case category_id = "category_id"
		case raised_by_admin = "raised_by_admin"
		case title = "title"
		case description = "description"
		case preview = "preview"
		case url = "url"
		case image = "image"
		case total_votes = "total_votes"
		case total_comments = "total_comments"
		case average = "average"
		case end_date = "end_date"
		case created_date = "created_date"
		case topic = "topic"
		case users_choice = "users_choice"
		case options = "options"
        case more_comments = "more_comments"
        case isMultiple = "is_multiple"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        alias = try values.decodeIfPresent(String.self, forKey: .alias)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
		topic_id = try values.decodeIfPresent(String.self, forKey: .topic_id)
		category_id = try values.decodeIfPresent(String.self, forKey: .category_id)
		raised_by_admin = try values.decodeIfPresent(String.self, forKey: .raised_by_admin)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		preview = try values.decodeIfPresent(String.self, forKey: .preview)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		total_votes = try values.decodeIfPresent(String.self, forKey: .total_votes)
		total_comments = try values.decodeIfPresent(String.self, forKey: .total_comments)
		average = try values.decodeIfPresent(String.self, forKey: .average)
		end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
		created_date = try values.decodeIfPresent(String.self, forKey: .created_date)
		topic = try values.decodeIfPresent(String.self, forKey: .topic)
		users_choice = try values.decodeIfPresent(String.self, forKey: .users_choice)
		options = try values.decodeIfPresent([Options].self, forKey: .options)
        more_comments = try values.decodeIfPresent(String.self, forKey: .more_comments)
        isMultiple = try values.decodeIfPresent(String.self, forKey: .isMultiple)
	}

}
