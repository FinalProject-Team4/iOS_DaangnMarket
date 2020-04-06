//
//  UserDefaults+Extension.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

extension UserDefaults {
  func swapAt(_ key1: String, _ key2: String) {
    guard let value1 = self.data(forKey: key1),
      let value2 = self.data(forKey: key2) else { return }
    self.set(value1, forKey: key2)
    self.set(value2, forKey: key1)
  }
}
