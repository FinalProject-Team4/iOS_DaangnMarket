//
//  AppDelegate.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/03/20.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import Then
import SnapKit
import Kingfisher
import Alamofire
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = ViewControllerGenerator.shared.make(.launch)
    self.window?.makeKeyAndVisible()
    
    UNUserNotificationCenter.current().delegate = self
    Messaging.messaging().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (_, _) in })
    application.registerForRemoteNotifications()
    
    NotificationTrigger.default.receiveState = .notRunning
    
    return true
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    NotificationTrigger.default.receiveState = .foreground
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    NotificationTrigger.default.receiveState = .background
  }
  
  // MARK: Notification
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if
      let aps = userInfo["aps"] as? [String: Any],
      let alert = aps["alert"] as? [String: String],
      let body = alert["body"],
      let title = alert["title"]
    {
      print("Title :", title)
      print("Body :", body)
      
      let content = UNMutableNotificationContent()
      content.title = title
      content.body = body
      
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
      let request = UNNotificationRequest(identifier: "FCM Contents", content: content, trigger: trigger)
      UNUserNotificationCenter.current().add(request) { (error) in
        if let error = error {
          print(error.localizedDescription)
        }
      }
    }
    
    completionHandler(UIBackgroundFetchResult.newData)
  }
}

// MARK: - MessagingDelgate

extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    print("==================== FCM TOKEN ====================\n", fcmToken)
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: ["token": fcmToken])
    guard let authToken = AuthorizationManager.shared.userInfo?.authorization else {
      AuthorizationManager.shared.fcmToken = fcmToken
      return
    }
    API.default.requestPushKeyRegister(authToken: authToken, fcmToken: fcmToken) { (result) in
      switch result {
      case .success(let value):
        print("Register Succcess :", value)
      case .failure(let error):
        print("Register Fail :", error.localizedDescription)
      }
    }
  }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    // Foreground에서 알림 도착

    completionHandler([.alert, .badge, .sound])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    // Background 및 Foreground에서 알림 눌렀을 때 호출

    if let notiType = response.notification.request.content.userInfo["type"] as? String {
      NotificationTrigger.default.type = NotificationType(rawValue: notiType)
      completionHandler()
    }
  }
}
