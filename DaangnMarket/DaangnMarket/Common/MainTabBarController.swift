//
//  MainTabBarController.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/07.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

// customtabBar

class MainTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    self.tabBar.backgroundImage = UIImage()
  }
}

extension MainTabBarController: UITabBarControllerDelegate {
  func deSelecteTabBarIdx(_ idx: Int) {
    
  }
  
  
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    if viewController is WriteClearViewController {
      if let token = AuthorizationManager.shared.userInfo?.authorization {
        let typeVC = WriteTypeViewController(token: token)
        typeVC.modalPresentationStyle = .overCurrentContext
        tabBarController.present(typeVC, animated: false)
        return false
      } else {
        let alert = DGAlertController(title: "회원가입 또는 로그인후 이용할 수 있습니다.")
        let signInAction = DGAlertAction(title: "로그인/가입", style: .orange) {
          guard let authVC = ViewControllerGenerator.shared.make(.phoneAuth) else { return }
          tabBarController.present(authVC, animated: false)
        }
        let cancelAction = DGAlertAction(title: "취소", style: .white) {
          self.dismiss(animated: false) {
            tabBarController.selectedIndex = 0
          }
        }
        [signInAction, cancelAction].forEach { alert.addAction($0) }
        tabBarController.present(alert, animated: false)
      }
    }
    return true
  }
}
