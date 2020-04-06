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
    let newWindow = UIWindow(frame: UIScreen.main.bounds)
    newWindow.rootViewController = viewController
    newWindow.makeKeyAndVisible()
    self.appDelegate.window = newWindow
  }
}

