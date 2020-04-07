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
    case `default`
    case initialStart
    case phoneAuth
    case signUp
    case popover
  }
  
  func make(_ type: ControllerType, parameters: [String: Any] = [:]) -> UIViewController? {
    switch type {
    case .default:
      return self.makeTabBarController()
    case .initialStart:
      return UINavigationController(rootViewController: InitialStartViewController())
    case .phoneAuth:
      return UINavigationController(rootViewController: AuthViewController())
    case .signUp:
      guard let idToken = parameters["idToken"] as? String else { return nil }
      return UINavigationController(rootViewController: ConfigProfileViewController(idToken: idToken))
    case .popover:
      guard let homeVC = parameters["target"] as? UIViewController,
        let sender = parameters["sender"] as? UIView else { return nil }
      return self.makePopoverController(homeVC, sender)
    }
  }
  
  // MARK: Generator
  
  private func makeTabBarController() -> UIViewController {
    let homeFeedVC = UINavigationController(rootViewController: HomeFeedViewController()).then {
      $0.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
    }
    let categoryVC = CategoryViewController().then {
      $0.tabBarItem = UITabBarItem(title: "카테고리", image: UIImage(systemName: "line.horizontal.3"), tag: 1)
    }
    let writeUseVC = WriteUsedViewController().then {
      $0.tabBarItem = UITabBarItem(title: "글쓰기", image: UIImage(systemName: "pencil"), tag: 2)
    }
    let chatVC = ChatViewController().then {
      $0.tabBarItem = UITabBarItem(title: "채팅", image: UIImage(systemName: "bubble.left.and.bubble.right"), tag: 3)
    }
    let mypageVC = MyPageViewController().then {
      $0.tabBarItem = UITabBarItem(title: "나의 당근", image: UIImage(systemName: "person"), tag: 4)
    }
    
    return UITabBarController().then {
      $0.viewControllers = [homeFeedVC, categoryVC, writeUseVC, chatVC, mypageVC]
      $0.tabBar.tintColor = .black
    }
  }
  
  private func makePopoverController(_ homeVC: UIViewController, _ sender: UIView) -> UIViewController {
    let popover = PopoverViewController()
    popover.preferredContentSize = CGSize(width: 300, height: 150)
    popover.modalPresentationStyle = .popover
    guard let presentationController = popover.popoverPresentationController else { fatalError("popOverPresent casting error") }
    
    presentationController.delegate = homeVC as? UIPopoverPresentationControllerDelegate
    presentationController.sourceRect = sender.bounds
    presentationController.sourceView = sender
    presentationController.permittedArrowDirections = .up
    return popover
  }
}

