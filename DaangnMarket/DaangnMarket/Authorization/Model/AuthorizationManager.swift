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
  
  var hasSelectedAddress: Bool {
    return UserDefaults.standard.data(forKey: UserReference.selectedAddress.rawValue) != nil
  }
  
  var address: [Address] {
    var addresses = [Address]()
    if let selectedData = UserDefaults.standard.data(forKey: UserReference.selectedAddress.rawValue),
      let selectedAddress = try? JSONDecoder().decode(Address.self, from: selectedData) {
      addresses.append(selectedAddress)
    } else if let anotherData = UserDefaults.standard.data(forKey: UserReference.anotherAddress.rawValue),
      let anotherAddress = try? JSONDecoder().decode(Address.self, from: anotherData) {
      addresses.append(anotherAddress)
    }
    return addresses
  }
  
  func register(_ address: Address) {
    guard self.address.count < 2,
      let encoded = try? JSONEncoder().encode(address) else { return }
    UserDefaults.standard.set(
      encoded,
      forKey: self.address.isEmpty ? UserReference.selectedAddress.rawValue : UserReference.anotherAddress.rawValue
    )
  }
  
  func changeSelectedAddress() {
    UserDefaults.standard.swapAt(
      UserReference.selectedAddress.rawValue,
      UserReference.anotherAddress.rawValue
    )
  }
  
  func removeAddress() {
    guard self.address.count == 2 else { return }
    UserDefaults.standard.removeObject(forKey: UserReference.anotherAddress.rawValue)
  }
  
  // MARK: Interface - UserInfo
  
  var isLogined: Bool {
    return UserDefaults.standard.data(forKey: UserReference.userInfo.rawValue) != nil
  }
  
  var userInfo: UserInfo? {
    guard let userData = UserDefaults.standard.data(forKey: UserReference.userInfo.rawValue),
      let userInfo = try? JSONDecoder().decode(UserInfo.self, from: userData) else { return nil }
    return userInfo
  }
  
  func register(_ userInfo: UserInfo) {
    guard let encoded = try? JSONEncoder().encode(userInfo) else { return }
    UserDefaults.standard.set(encoded, forKey: UserReference.userInfo.rawValue)
  }
}
