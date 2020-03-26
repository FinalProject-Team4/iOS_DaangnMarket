//
//  UIDevice+Extension.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/26.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

extension UIDevice {
  var hasNotch: Bool {
    let height = UIScreen.main.nativeBounds.height / UIScreen.main.nativeScale
    return height == 812 || height == 896
  }
}
