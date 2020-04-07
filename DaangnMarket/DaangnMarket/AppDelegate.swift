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
    let rootVC: UIViewController?
    if AuthorizationManager.shared.hasSelectedAddress {
      rootVC = ViewControllerGenerator.shared.make(.default)
    } else {
      rootVC = ViewControllerGenerator.shared.make(.initialStart)
    }
    self.window?.rootViewController = rootVC
    self.window?.makeKeyAndVisible()
    
    return true
  }
}
