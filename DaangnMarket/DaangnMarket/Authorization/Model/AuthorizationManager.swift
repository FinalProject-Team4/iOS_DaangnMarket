//
//  AuthorizationManager.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation
import Then

class AuthorizationManager: Then {
  // MARK: Singleton
  
  static let shared = AuthorizationManager()
  
  private init() { }
  
  // MARK: Interface - Town
  
  var aroundTown = [Town]()
  
  var selectedTown: Town? {
    return UserDefaults.standard.object(Town.self, forKey: .selectedTown)
  }
  
  var anotherTown: Town? {
    return UserDefaults.standard.object(Town.self, forKey: .anotherTown)
  }
  
  func register(town: Town) {
    if self.selectedTown == nil {
      UserDefaults.standard.set(town, forKey: .selectedTown)
    } else if self.anotherTown == nil {
      UserDefaults.standard.set(town, forKey: .anotherTown)
    } else {
      return
    }
  }
  
  func changeSelectedTown() {
    UserDefaults.standard.swapAt(.selectedTown, .anotherTown)
  }
  
  func removeTown(forKey key: UserReference) {
    if key == .anotherTown {
      UserDefaults.standard.remove(forKey: key)
    } else {
      UserDefaults.standard.swapAt(.selectedTown, .anotherTown)
      self.removeTown(forKey: .anotherTown)
    }
  }
  
  // MARK: Interface - UserInfo
  
  var userInfo: UserInfo? {
    return UserDefaults.standard.object(UserInfo.self, forKey: .userInfo)
  }
  
  func register(_ userInfo: UserInfo) {
    UserDefaults.standard.set(userInfo, forKey: .userInfo)
  }
}
