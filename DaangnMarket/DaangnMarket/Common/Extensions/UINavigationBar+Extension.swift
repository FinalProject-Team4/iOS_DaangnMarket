//
//  UINavigationBar+Extension.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/26.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

extension UINavigationBar {
  static var statusBarSize: CGSize {
    return CGSize(width: UIScreen.main.bounds.width, height: UIDevice.current.hasNotch ? 44 : 20)
  }
  static var navigationBarSize: CGSize {
    return CGSize(width: UIScreen.main.bounds.width, height: 44)
  }
  
  static var navigationItemSize: CGSize {
    return CGSize(width: 22, height: 22)
  }
}


