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
    case profilePage
    case sellingItems
    case notification
    case categoryFeed
    case chatting
    case salesList
    case likeList
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
      guard let idToken = parameters["id_token"] as? String else { return nil }
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
      guard let postVCData = parameters["postData"] as? Post else { return nil }
      let productPostVC = ProductPostViewController(postData: postVCData)
      productPostVC.hidesBottomBarWhenPushed = true
      return productPostVC
    case .notification:
      return NotificationViewController()
    case .profilePage:
      guard let ownSelfData = parameters["ownSelf"] as? Bool, let nameData = parameters["name"] as? String, let profileData = parameters["profileData"] as? [Post] else { return nil }
      let profilePageVC = ProfilePageViewController(ownSelf: ownSelfData, name: nameData, profileData: profileData)
      profilePageVC.hidesBottomBarWhenPushed = true
      return profilePageVC
    case .sellingItems:
      guard let sellingItemsData = parameters["sellingData"] as? [Post] else { return nil }
      let sellingItemsVC = SellingItemsViewController(sellingData: sellingItemsData)
      return sellingItemsVC
    case .categoryFeed:
      guard let category = parameters["category"] as? String else { return nil }
      return SelectedCategoryFeedViewController(category: category)
    case .chatting:
      return UINavigationController(rootViewController: ChatViewController())
    case .likeList:
      guard let likeListData = parameters["likeListData"] as? [Post] else { return nil }
      let likeListVC = LikeListViewController(likeListData: likeListData)
      return likeListVC
    case .salesList:
      guard let salesListData = parameters["salesListData"] as? [Post] else { return nil }
      let salesListVC = SalesListViewController(salesListData: salesListData)
      return salesListVC
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
    let mypageVC = UINavigationController(rootViewController: MyPageViewController()).then {
      $0.tabBarItem = UITabBarItem(title: "나의 당근", image: UIImage(systemName: "person"), tag: 4)
    }
    
    return MainTabBarController().then {
      $0.viewControllers = [homeFeedVC, categoryVC, writeUseVC, chatVC, mypageVC]
      $0.tabBar.tintColor = .black
    }
  }
  
  private func makePopoverController(_ homeVC: UIViewController, _ sender: UIView) -> UIViewController {
    let popover = PopoverViewController()
    //    popover.preferredContentSize = CGSize(width: 300, height: 150)
    popover.modalPresentationStyle = .popover
    guard let presentationController = popover.popoverPresentationController else { fatalError("popOverPresent casting error") }
    
    presentationController.delegate = homeVC as? UIPopoverPresentationControllerDelegate
    presentationController.sourceRect = sender.bounds
    presentationController.sourceView = sender
    presentationController.permittedArrowDirections = .up
    return popover
  }
}

