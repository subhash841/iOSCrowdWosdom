//
//  APIs.swift
//  CrowdWisdom
//
//  Created by Sunday on 08/10/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation

let terms_and_conditions_link = "https://www.crowdwisdom.co.in/Login/privacy_policy" //"https://www.crowdwisdom.co.in/TnC"
let about_us_link = "https://www.crowdwisdom.co.in/Home/aboutus"


let API_LOGIN = "AppLogin/social_login"
let API_LOGOUT = "AppLogin/logout"
let API_UPDATE_DEVICE_TOKEN = "AppLogin/update_device_token_and_type"
let API_HOME_LIST = "ApiHome/home"

//prediction Apis
let API_PREDICTIONS_LIST = "ApiPredictions/lists"
let API_PREDICTIONS_DETAIL = "ApiPredictions/detail"
let API_PREDICTIONS_ANSWERED = "Predictions/answered_predictions"
let API_PREDICTIONS_LIST_COMMENT = "ApiPredictions/view_more_comments"
let API_PREDICTIONS_UPDATE_COMMENT = "ApiPredictions/update_comment"
let API_PREDICTIONS_DELETE_COMMENT = "ApiPredictions/delete_comment"
let API_PREDICTIONS_ADD_COMMENT = "ApiPredictions/add_comment"
let API_PREDICTIONS_ADD_COMMENT_REPLY = "ApiPredictions/add_comment_reply"
let API_PREDICTIONS_REPLY_OF_COMMENT = "ApiPredictions/get_comment_replies"
let API_PREDICTIONS_UPDATE_REPLY = "ApiPredictions/update_comment_reply"
let API_PREDICTIONS_DELETE_REPLY = "ApiPredictions/delete_comment_reply"
let API_PREDICTIONS_VOTE = "ApiPredictions/vote_action"
let API_PREDICTIONS_EXPERT = "ApiPredictions/experts_result"
let API_PREDICTIONS_CREATE_UPDATE = "ApiPredictions/create_update_prediction"

//Ask question APIs
let API_ASKQUESTIONS_LIST = "ApiAskQuestions/lists"
let API_ASKQUESTIONS_DETAIL = "ApiAskQuestions/detail"
//let API_ASKQUESTIONS_ANSWERED = "AskQuestions/answered_questions"
let API_ASKQUESTIONS_COMMENT = "ApiAskQuestions/view_more_comments"
let API_ASKQUESTIONS_ADDCOMMENT = "ApiAskQuestions/add_comment"
let API_ASKQUESTIONS_UPDATE_COMMENT = "ApiAskQuestions/update_comment"
let API_ASKQUESTIONS_DELETE_COMMENT = "ApiAskQuestions/delete_comment"
let API_ASKQUESTIONS_ADD_COMMENT_REPLY = "ApiAskQuestions/add_comment_reply"
let API_ASKQUESTIONS_REPLY_OF_COMMENT = "ApiAskQuestions/get_comment_replies"
let API_ASKQUESTIONS_UPDATE_REPLY = "ApiAskQuestions/update_comment_reply"
let API_ASKQUESTIONS_DELETE_REPLY = "ApiAskQuestions/delete_comment_reply"
let API_ASKQUESTIONS_CREATE = "ApiAskQuestions/create_update_question"
let API_ASKQUESTIONS_VOTE = "ApiAskQuestions/vote_action"

//Rated Article Apis
let API_RATEDARTICLE_LIST = "ApiFromTheWeb/lists"
let API_RATEDARTICLE_DETAIL = "ApiFromTheWeb/detail"
let API_RATEDARTICLE_ANSWERED = "RatedArticle/answered_articles"
let API_RATEDARTICLE_CREATE_UPDATE = "ApiFromTheWeb/create_update_article"
let API_RATEDARTICLE_DELETE = "ApiFromTheWeb/delete_article"
let API_RATEDARTICLE_VOTE = "ApiFromTheWeb/add_update_action"
let API_RATEDARTICLE_COMMENT = "ApiFromTheWeb/view_more_comments"
let API_RATEDARTICLE_ADD_COMMENT = "ApiFromTheWeb/add_comment"
let API_RATEDARTICLE_UPDATE_COMMENT = "ApiFromTheWeb/update_comment"
let API_RATEDARTICLE_DELETE_COMMENT = "ApiFromTheWeb/delete_comment"
let API_RATEDARTICLE_REPLY_LIST = "ApiFromTheWeb/get_comment_replies"
let API_RATEDARTICLE_DELETE_REPLY = "ApiFromTheWeb/delete_comment_reply"
let API_RATEDARTICLE_UPDATE_REPLY = "ApiFromTheWeb/update_comment_reply"
let API_RATEDARTICLE_ADD_REPLY = "ApiFromTheWeb/add_comment_reply"

//Voice APIs
let API_VOICE_LIST = "ApiYourVoice/lists"
let API_VOICE_DETAIL = "ApiYourVoice/detail"
let API_VOICE_COMMENT = "ApiYourVoice/view_more_comments"
let API_VOICE_ADDCOMMENT = "ApiYourVoice/add_comment"
let API_VOICE_UPDATE_COMMENT = "ApiYourVoice/update_comment"
let API_VOICE_DELETE_COMMENT = "ApiYourVoice/delete_comment"
let API_VOICE_ADD_COMMENT_REPLY = "ApiYourVoice/add_comment_reply"
let API_VOICE_REPLY_OF_COMMENT = "ApiYourVoice/get_comment_replies"
let API_VOICE_UPDATE_REPLY = "ApiYourVoice/update_comment_reply"
let API_VOICE_DELETE_REPLY = "ApiYourVoice/delete_comment_reply"
let API_VOICE_LIKE = "ApiYourVoice/like_unlike_voice"
let API_CREATE_BLOG = "ApiYourVoice/create_update_voice"

//Discussion API's
let API_DISSCUSSION_COMMENT = "ApiDiscussion/view_more_comments"
let API_DISSCUSSION_ADDCOMMENT = "ApiDiscussion/add_comment"
let API_DISSCUSSION_UPDATE_COMMENT = "ApiDiscussion/update_comment"
let API_DISSCUSSION_DELETE_COMMENT = "ApiDiscussion/delete_comment"
let API_DISSCUSSION_ADD_COMMENT_REPLY = "ApiDiscussion/add_comment_reply"
let API_DISSCUSSION_REPLY_OF_COMMENT = "ApiDiscussion/get_comment_replies"
let API_DISSCUSSION_UPDATE_REPLY = "ApiDiscussion/update_comment_reply"
let API_DISSCUSSION_DELETE_REPLY = "ApiDiscussion/delete_comment_reply"
let API_DISSCUSSION_CREATE = "ApiAskQuestions/create_update_question"
let API_DISSCUSSION_VOTE = "ApiDiscussion/vote_action"
let API_DISCUSSION_LIST = "ApiDiscussion/lists"
let API_DISCUSSION_DETAIL = "ApiDiscussion/detail"
let API_DISCUSSION_CREATE = "ApiDiscussion/create_update_wall"

//Competition APIs
let API_COMPETITION_LIST = "ApiPackages/lists"
let API_COMPETITION_INFO = "ApiPackages/package_info"
let API_COMPETITION_PURCHASE_PKG = "ApiPackages/purchase_package"

//Common APIs
let API_COMMON_TOPIC_LIST = "ApiCommon/topic_list"
let API_COMMON_SEARCH = "ApiCommon/searched_topics"
let API_COMMON_FOLLOW_TOPIC = "ApiCommon/follow_topic"
let API_TOPIC_LIST = "ApiCommon/topic_list"

//WALLET
let API_USER_PROFILE = "ApiWallet/user_profile"
let API_USER_POINT_HISTROY = "ApiWallet/user_point_history"
let API_UPDATE_PROFILE = "AppLogin/update_profile"
let API_USER_CURRENT_POINT = "ApiWallet/get_users_points"

//NOTIFICATION
let API_NOTIFICATION_LIST = "ApiCommon/notification_list"

