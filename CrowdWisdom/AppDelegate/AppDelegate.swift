//
//  AppDelegate.swift
//  CrowdWisdom
//
//  Created by  user on 7/20/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import GoogleSignIn
import TwitterCore
import TwitterKit
import IQKeyboardManagerSwift
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let notificationDelegate = NotificationDelegate()

    //MARK:- App luanch
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        sleep(3)
//        configureNotification()
        if let uuid = Common.shared.keychain.get("UUID") {
            DLog(message: "Stored UUID: \(uuid)")
        } else {
            if let newUUID = createNewUUID() {
                Common.shared.keychain.set(newUUID, forKey: "UUID")
                DLog(message:"New UUID:\(newUUID)" )
            }
        }

        initializeNetwork()
//        application.statusBarStyle = .lightContent
        
        IQKeyboardManager.shared.enable = true
        
//       UILabel.appearance().font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: "Roboto"))
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GIDSignIn.sharedInstance()?.clientID = google_client_id
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET_KEY)
        FirebaseApp.configure()
        if UserDefaults.standard.bool(forKey: IS_USER_LOGIN) == true {
            if let userid = UserDefaults.standard.object(forKey: LOGGED_USER_ID) as? String {
                USERID = userid
                Common.shared.updateDeviceAPNsToken()
                Common.shared.getUserPoints()
                let rootViewController = self.window!.rootViewController as! UINavigationController
                let cardView = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
                rootViewController.pushViewController(cardView, animated: false)
                /*let cardView = storyboard.instantiateViewController(withIdentifier: "CardMainViewViewController") as! CardMainViewViewController
                rootViewController.pushViewController(cardView, animated: false)*/
            }
        }else{
            let rootViewController = self.window!.rootViewController as! UINavigationController
            let cardView = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
            USERID = "0"
            rootViewController.pushViewController(cardView, animated: false)
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let appId: String = SDKSettings.appId
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            return SDKApplicationDelegate.shared.application(app, open: url, options: options)
        } else{
            return GIDSignIn.sharedInstance().handle(url as URL?,
                                              sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                              annotation: options[UIApplication.OpenURLOptionsKey.annotation]) || TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        }
    }
    

    
    //MARK:-  Network reachability
    
    private func initializeNetwork() {
        
        do {
            Network.reachability = try Reachability(hostname: "www.google.com")
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                print(error)
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
    }
    
    @objc func statusManager(_ notification: NSNotification) {
        // do your work here once network flag changes
    }
        
    //MARK:- Applications States delegates
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        Common.shared.setDeviceAPNsToken(token: deviceTokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    func configureNotification() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            center.delegate = notificationDelegate
        }
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        DLog(message: userInfo)
    }
    
    func openView() {
        
    }
    
    func createNewUUID() -> String? {
        let theUUID = CFUUIDCreate(nil)
        let string = CFUUIDCreateString(nil, theUUID)
        return string as String?
    }
}

