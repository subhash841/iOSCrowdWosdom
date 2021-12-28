//
//  NotificationDelegate.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 12/13/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation
import UserNotifications
import UserNotificationsUI
//PUSH-NOTIFICATION FORMAT
//(
//    [post_id] => 18
//    [title] => commented on your question
//    [text] => hhg
//    [type] => Discussion / Prediction / Questions / Voice / Web
//    [sub_type] => Comment / Reply / Add / Like / Dislike / Neutral / Vote
//    [user_id] => 4922
//    [friend_id] => 5149
//    [image] =>
//)
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            if UserDefaults.standard.bool(forKey: IS_USER_LOGIN) {
                let rootViewController = APP_DELEGATE.window!.rootViewController as! UINavigationController
                let cardView = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
                
                cardView.selectedIndex = 1
                rootViewController.pushViewController(cardView, animated: false)
                DLog(message: "\(response.notification.request.content.userInfo)")
            }
            
            if let dict = response.notification.request.content.userInfo as? [String:Any] {
                let id = "\(dict["post_id"] as? String ?? "\(dict["post_id"] as? Int ?? 0)")"
                let type = dict["type"] as? String
                let subType = dict["subtype"] as? String
                let commentId = "\(dict["comment_id"] as? String ?? "\(dict["comment_id"] as? Int ?? 0)")"
                
                Common.shared.isFromNotification = true
                Common.shared.notificationType = type
                Common.shared.notificationPostId = id
                Common.shared.notificationSubType = subType
                Common.shared.notificationCommentId = commentId
                
                if subType == NotificationSubType.reply.rawValue {
                    if let alias = dict["alias"] as? String, let comment = dict["comment"] as? String {
                        Common.shared.notificationCommentAlias = alias
                        Common.shared.notificationComment = comment
                    }
                }
            }
            print("Open Action")
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("default")
        }
        completionHandler()
    }
    
}
