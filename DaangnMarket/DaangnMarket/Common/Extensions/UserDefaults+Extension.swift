//
//  UserDefaults+Extension.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

extension UserDefaults {
  func swapAt(_ key1: UserReference, _ key2: UserReference) {
    guard let value1 = self.data(forKey: key1.rawValue),
      let value2 = self.data(forKey: key2.rawValue) else { return }
    self.set(value1, forKey: key2)
    self.set(value2, forKey: key1)
  }
  
  func object<T: Decodable>(_ type: T.Type, forKey key: UserReference) -> T? {
    guard let data = self.data(forKey: key.rawValue) else { return nil }
    guard let object = try? JSONDecoder().decode(type, from: data) else { return nil }
    return object
  }
  
  func set<T: Encodable>(_ object: T, forKey key: UserReference) {
    guard let data = try? JSONEncoder().encode(object) else { return }
    self.set(data, forKey: key.rawValue)
  }
  
  func remove(forKey key: UserReference) {
    if self.data(forKey: key.rawValue) != nil {
      self.removeObject(forKey: key.rawValue)
    }
  }
}
