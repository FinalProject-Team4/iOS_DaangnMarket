//
//  AuthorizationManager.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

class AuthorizationManager {
  // MARK: Singleton
  
  static let shared = AuthorizationManager()
  
  private init() { }
  
  // MARK: Interface - Town
  
  var selectedTown: Town? {
    return UserDefaults.standard.object(Town.self, forKey: .selectedTown)
  }
  
  var anotherTown: Town? {
    return UserDefaults.standard.object(Town.self, forKey: .anotherTown)
  }
  
  var selectedAround: [Town]? {
    return UserDefaults.standard.object([Town].self, forKey: .selectedAround)
  }
  
  var anotherAround: [Town]? {
    return UserDefaults.standard.object([Town].self, forKey: .anotherAround)
  }
  
  func register(town: Town, around: [Town]) {
    if self.selectedTown == nil, self.selectedAround == nil {
      UserDefaults.standard.set(town, forKey: .selectedTown)
      UserDefaults.standard.set(around, forKey: .selectedAround)
    } else if self.anotherTown == nil, self.anotherAround == nil {
      UserDefaults.standard.set(town, forKey: .anotherTown)
      UserDefaults.standard.set(around, forKey: .anotherAround)
    } else {
      return
    }
  }
  
  func changeSelectedTown() {
    UserDefaults.standard.swapAt(.selectedTown, .anotherTown)
    UserDefaults.standard.swapAt(.selectedAround, .anotherAround)
  }
  
  func removeTown(forKey key: UserReference) {
    if key == .anotherTown {
      UserDefaults.standard.remove(forKey: key)
      UserDefaults.standard.remove(forKey: key)
    } else {
      UserDefaults.standard.swapAt(.selectedTown, .anotherTown)
      UserDefaults.standard.swapAt(.selectedAround, .anotherAround)
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
