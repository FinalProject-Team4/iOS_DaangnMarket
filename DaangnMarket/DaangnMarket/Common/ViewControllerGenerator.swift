//
//  ViewControllerGenerator.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ViewControllerGenerator {
  // MARK: Singleton
  
  static let shared = ViewControllerGenerator()
  
  private init() { }
  
  // MARK: Interface
  
  enum ControllerType {
    case launch
    case `default`
    case initialStart
    case phoneAuth
    case signUp
    case townSetting
    case townShow
    case popover
    case writeUsed
    case findTown
    case productPost
    case notification
    case categoryFeed
    case chatting
  }
  
  func make(_ type: ControllerType, parameters: [String: Any] = [:]) -> UIViewController? {
    switch type {
    case .launch:
      return LaunchViewController()
    case .default:
      return self.makeTabBarController()
    case .initialStart:
      return UINavigationController(rootViewController: InitialStartViewController())
    case .phoneAuth:
      return UINavigationController(rootViewController: AuthViewController())
    case .signUp:
      guard let idToken = parameters["idToken"] as? String else { return nil }
      return UINavigationController(rootViewController: ConfigProfileViewController(idToken: idToken))
    case .townSetting:
      return UINavigationController(rootViewController: MyTownSettingViewController())
    case .popover:
      guard let homeVC = parameters["target"] as? UIViewController,
        let sender = parameters["sender"] as? UIView else { return nil }
      return self.makePopoverController(homeVC, sender)
    case .writeUsed:
      return UINavigationController(rootViewController: WriteUsedViewController())
    case .townShow:
      return UINavigationController(rootViewController: ChooseTownToShowViewController())
    case .findTown:
      return UINavigationController(rootViewController: FindMyTownViewController())
    case .productPost:
      let productPostVC = ProductPostViewController()
      productPostVC.hidesBottomBarWhenPushed = true
      return productPostVC
    case .notification:
      return NotificationViewController()
    case .categoryFeed:
      guard let category = parameters["category"] as? String else { return nil }
      return SelectedCategoryFeedViewController(category: category)
    case .chatting:
      return UINavigationController(rootViewController: ChatViewController())
    }
  }
  
  // MARK: Generator
  
  private func makeTabBarController() -> UIViewController {
    let homeFeedVC = UINavigationController(rootViewController: HomeFeedViewController()).then {
      $0.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
    }
    let categoryVC = UINavigationController(rootViewController: CategoryViewController()).then {
      $0.tabBarItem = UITabBarItem(title: "카테고리", image: UIImage(systemName: "line.horizontal.3"), tag: 1)
    }
    let writeUseVC = WriteClearViewController().then {
      $0.tabBarItem = UITabBarItem(title: "글쓰기", image: UIImage(systemName: "pencil"), tag: 2)
    }
    let chatVC = UINavigationController(rootViewController: ChatViewController()).then {
      $0.tabBarItem = UITabBarItem(title: "채팅", image: UIImage(systemName: "bubble.left.and.bubble.right"), tag: 3)
    }
    let mypageVC = MyPageViewController().then {
      $0.tabBarItem = UITabBarItem(title: "나의 당근", image: UIImage(systemName: "person"), tag: 4)
    }
    
    return MainTabBarController().then {
      $0.viewControllers = [homeFeedVC, categoryVC, writeUseVC, chatVC, mypageVC]
      $0.tabBar.tintColor = .black
    }
  }
  
  private func makePopoverController(_ homeVC: UIViewController, _ sender: UIView) -> UIViewController {
    let popover = PopoverViewController()
    popover.modalPresentationStyle = .popover
    
    guard let presentationController = popover.popoverPresentationController else { fatalError("popOverPresent casting error") }
    presentationController.delegate = homeVC as? UIPopoverPresentationControllerDelegate
    presentationController.sourceRect = sender.bounds
    presentationController.sourceView = sender
    presentationController.permittedArrowDirections = .up
    return popover
  }
}

