//
//  MainTabBarController.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/07.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
  }
}

extension MainTabBarController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    if viewController is WriteClearViewController {
      let typeVC = WriteTypeViewController()
      typeVC.modalPresentationStyle = .overCurrentContext
      tabBarController.present(typeVC, animated: false)
      return false
    }
    return true
  }
}
