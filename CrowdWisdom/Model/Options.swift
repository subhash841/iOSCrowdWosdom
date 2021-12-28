/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Options : Decodable {
	var choice_id : String?
	var choice : String?
    let type : String?
    var total : String?
    var avg : String?
    var selected : Bool?
    
	enum CodingKeys: String, CodingKey {
		case choice_id = "choice_id"
		case choice = "choice"
        case type = "type"
        case selected = "selected"
        case total = "total"
        case avg = "avg"
	}

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        choice_id = try values.decodeIfPresent(String.self, forKey: .choice_id)
        choice = try values.decodeIfPresent(String.self, forKey: .choice)
        total = "0"
//        total = try values.decodeIfPresent(String.self, forKey: .total) ?? "0"
        type = try values.decodeIfPresent(String.self, forKey: .type)
        avg = try values.decodeIfPresent(String.self, forKey: .avg)
//        selected = false
    }

}
