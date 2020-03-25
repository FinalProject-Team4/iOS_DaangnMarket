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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let homeFeedVC = HomeFeedViewController()
    let homeFeedNaviController = UINavigationController(rootViewController: homeFeedVC)
    let tabbarController = UITabBarController()
    
    tabbarController.viewControllers = [homeFeedNaviController]
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = tabbarController
    self.window?.makeKeyAndVisible()
    
    return true
  }
  
}

