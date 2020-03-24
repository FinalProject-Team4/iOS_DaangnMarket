//
//  UIImageView+Extension.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

extension UIImageView {
  convenience init(named: String) {
    let image = UIImage(named: named)
    self.init(image: image)
  }
}

