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
    case chattingHistory
    case chatting
    case search
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
      guard let idToken = parameters["id_token"] as? String else { return nil }
      return UINavigationController(rootViewController: WriteUsedViewController(token: idToken))
    case .townShow:
      return UINavigationController(rootViewController: ChooseTownToShowViewController())
    case .findTown:
      return UINavigationController(rootViewController: FindMyTownViewController())
    case .productPost:
      guard let postVCData = parameters["postID"] as? Int, let  postImgData = parameters["postPhotos"] as? [String] else { return nil }
      let productPostVC = ProductPostViewController(postID: postVCData, postPhotos: postImgData)
      productPostVC.hidesBottomBarWhenPushed = true
      return productPostVC
    case .notification:
      guard let userInfo = parameters["userInfo"] as? UserInfo else { return nil }
      return NotificationViewController(userInfo: userInfo)
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
    case .chattingHistory:
      return UINavigationController(rootViewController: ChattingHistoryViewController())
    case .chatting:
      return ChattingViewController()
    case .likeList:
      let likeListVC = LikeListViewController()
      return likeListVC
    case .salesList:
      let salesListVC = SalesListViewController()
      return salesListVC
    case .search:
      return SearchViewController()
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
    let chatVC = UINavigationController(rootViewController: ChattingHistoryViewController()).then {
      $0.tabBarItem = UITabBarItem(title: "채팅", image: UIImage(systemName: "bubble.left.and.bubble.right"), tag: 3)
    }
    let mypageVC = UINavigationController(rootViewController: MyPageViewController()).then {
      $0.tabBarItem = UITabBarItem(title: "나의 당근", image: UIImage(systemName: "person"), tag: 4)
    }
    return MainTabBarController().then {
      $0.viewControllers = [homeFeedVC, categoryVC, writeUseVC, chatVC, mypageVC]
      $0.tabBar.tintColor = .black
      NotificationTrigger.default.tabBarController = $0
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

