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
  
  // MARK: Interface - Address
  
  var selectedAddress: Address? {
    return UserDefaults.standard.object(Address.self, forKey: .selectedAddress)
  }
  
  var anotherAddress: Address? {
    return UserDefaults.standard.object(Address.self, forKey: .anotherAddress)
  }
  
  var selectedAround: [Address]? {
    return UserDefaults.standard.object([Address].self, forKey: .selectedAround)
  }
  
  var anotherAround: [Address]? {
    return UserDefaults.standard.object([Address].self, forKey: .anotherAround)
  }
  
  func register(address: Address, around: [Address]) {
    if self.selectedAddress == nil, self.selectedAround == nil {
      UserDefaults.standard.set(address, forKey: .selectedAddress)
      UserDefaults.standard.set(around, forKey: .selectedAround)
    } else if self.anotherAddress == nil, self.anotherAround == nil {
      UserDefaults.standard.set(address, forKey: .anotherAddress)
      UserDefaults.standard.set(around, forKey: .anotherAround)
    } else {
      return
    }
  }
  
  func changeSelectedAddress() {
    UserDefaults.standard.swapAt(.selectedAddress, .anotherAddress)
    UserDefaults.standard.swapAt(.selectedAround, .anotherAround)
  }
  
  func removeAddress(forKey key: UserReference) {
    if key == .anotherAddress {
      UserDefaults.standard.remove(forKey: key)
      UserDefaults.standard.remove(forKey: key)
    } else {
      UserDefaults.standard.swapAt(.selectedAddress, .anotherAddress)
      UserDefaults.standard.swapAt(.selectedAround, .anotherAround)
      self.removeAddress(forKey: .anotherAddress)
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
