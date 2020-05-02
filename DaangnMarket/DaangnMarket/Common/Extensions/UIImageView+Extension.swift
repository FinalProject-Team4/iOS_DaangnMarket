//
//  UIImageView+Extension.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

extension UIImageView {
  convenience init(named name: String) {
    let image = UIImage(named: name)
    self.init(image: image)
  }
  
  convenience init(systemName name: String) {
    let image = UIImage(systemName: name)
    self.init(image: image)
  }
}

