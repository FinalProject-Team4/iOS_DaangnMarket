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
    
    let homeFeedVC = HomeFeedViewController()
    let categoryVC = CategoryViewController()
    let writeUseVC = WriteUsedViewController()
    let chatVC = ChatViewController()
    let mypageVC = MyPageViewController()
    
    let homeFeedNaviController = UINavigationController(rootViewController: homeFeedVC)
    let tabbarController = UITabBarController()
    
    tabbarController.viewControllers = [homeFeedNaviController, categoryVC, writeUseVC, chatVC, mypageVC]
    tabbarController.tabBar.backgroundImage = UIImage()
    tabbarController.tabBar.items?[0].title = "홈"
    tabbarController.tabBar.items?[0].image = UIImage(systemName: "house")
    tabbarController.tabBar.items?[1].title = "카테고리"
    tabbarController.tabBar.items?[1].image = UIImage(systemName: "line.horizontal.3")
    tabbarController.tabBar.items?[2].title = "글쓰기"
    tabbarController.tabBar.items?[2].image = UIImage(systemName: "pencil")
    tabbarController.tabBar.items?[3].title = "채팅"
    tabbarController.tabBar.items?[3].image = UIImage(systemName: "bubble.left.and.bubble.right")
    tabbarController.tabBar.items?[4].title = "나의 당근"
    tabbarController.tabBar.items?[4].image = UIImage(systemName: "person")
    
    UITabBar.appearance().tintColor = .black
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = UINavigationController(rootViewController: InitialStartViewController())
    self.window?.makeKeyAndVisible()
    
    return true
  }
  
}

