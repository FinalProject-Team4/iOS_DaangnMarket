//
//  UIApplication+Extension.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

extension UIApplication {
  var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }
  
  func switchRootViewController(_ viewController: UIViewController) {
    guard let window = self.appDelegate.window else { return }
    window.rootViewController = viewController
    UIView.transition(with: window, duration: 0.45, options: .transitionCrossDissolve, animations: nil)
  }
}

