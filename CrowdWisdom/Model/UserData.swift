/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct UserData : Decodable {
	let id : String?
	let name : String?
	let email : String?
	let login_type : String?
	let alias : String?
	let tnc_agree : String?
	let gold_points : String?
	let silver_points : String?
	let token : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case email = "email"
		case login_type = "login_type"
		case alias = "alias"
		case tnc_agree = "tnc_agree"
		case gold_points = "gold_points"
		case silver_points = "silver_points"
		case token = "token"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		login_type = try values.decodeIfPresent(String.self, forKey: .login_type)
		alias = try values.decodeIfPresent(String.self, forKey: .alias)
		tnc_agree = try values.decodeIfPresent(String.self, forKey: .tnc_agree)
		gold_points = try values.decodeIfPresent(String.self, forKey: .gold_points)
		silver_points = try values.decodeIfPresent(String.self, forKey: .silver_points)
		token = try values.decodeIfPresent(String.self, forKey: .token)
	}

}
