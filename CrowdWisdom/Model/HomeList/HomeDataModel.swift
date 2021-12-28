

import Foundation
struct HomeDataModel : Codable {
	let topic_list : [TopicListModel]?
	let prediction_list : [PredictionListModel]?
	let question_list : [QuestionListModel]?
	let your_voice_list : [YourVoiceListModel]?
	let rated_article_list : [RatedArticleListModel]?
	let competetion_list : [PlayAndWinListModel]?
	let discussion_list : [DiscussionListModel]?

	enum CodingKeys: String, CodingKey {

		case topic_list = "topic_list"
		case prediction_list = "prediction_list"
		case question_list = "question_list"
		case your_voice_list = "your_voice_list"
		case rated_article_list = "rated_article_list"
		case competetion_list = "competetion_list"
		case discussion_list = "discussion_list"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		topic_list = try values.decodeIfPresent([TopicListModel].self, forKey: .topic_list)
		prediction_list = try values.decodeIfPresent([PredictionListModel].self, forKey: .prediction_list)
		question_list = try values.decodeIfPresent([QuestionListModel].self, forKey: .question_list)
		your_voice_list = try values.decodeIfPresent([YourVoiceListModel].self, forKey: .your_voice_list)
		rated_article_list = try values.decodeIfPresent([RatedArticleListModel].self, forKey: .rated_article_list)
		competetion_list = try values.decodeIfPresent([PlayAndWinListModel].self, forKey: .competetion_list)
		discussion_list = try values.decodeIfPresent([DiscussionListModel].self, forKey: .discussion_list)
	}

}
