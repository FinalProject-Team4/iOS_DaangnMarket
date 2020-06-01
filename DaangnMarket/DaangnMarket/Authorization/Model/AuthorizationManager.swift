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
  
  //  var aroundTown = [Town]()
  
  var firstAroundTown = [Town]()
  var secondAroundTown = [Town]()
  
  var firstTown: UserTown? {
    get {
      return UserDefaults.standard.object(UserTown.self, forKey: .firstTown)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: .firstTown)
    }
  }
  
  var secondTown: UserTown? {
    get {
      return UserDefaults.standard.object(UserTown.self, forKey: .secondTown)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: .secondTown)
    }
  }
  
  var activatedTown: UserTown? {
    if let firstTown = self.firstTown, firstTown.activated {
      return firstTown
    } else if let secondTown = self.secondTown, secondTown.activated {
      return secondTown
    } else {
      return nil
    }
  }
  
  func updateFirstTown(distance: Double? = nil, verified: Bool? = nil, activated: Bool? = nil) {
    guard var firstTown = self.firstTown else { return }
    if let distance = distance {
      firstTown.distance = Int(distance)
    }
    if let verified = verified {
      firstTown.verified = verified
    }
    if let activated = activated {
      firstTown.activated = activated
    }
    self.firstTown = firstTown
  }
  
  func updateSecondTown(distance: Double? = nil, verified: Bool? = nil, activated: Bool? = nil) {
    guard var secondTown = self.secondTown else { return }
    if let distance = distance {
      secondTown.distance = Int(distance)
    }
    if let verified = verified {
      secondTown.verified = verified
    }
    if let activated = activated {
      secondTown.activated = activated
    }
    self.secondTown = secondTown
  }
  
  func register(town: UserTown) {
    if self.firstTown == nil {
      UserDefaults.standard.set(town, forKey: .firstTown)
    } else if self.secondTown == nil {
      UserDefaults.standard.set(town, forKey: .secondTown)
    } else {
      return
    }
  }
  
  func changeSelectedTown() {
    UserDefaults.standard.swapAt(.firstTown, .secondTown)
  }
  
  func removeTown(forKey key: UserReference) {
    if key == .secondTown {
      UserDefaults.standard.remove(forKey: key)
    } else {
      UserDefaults.standard.swapAt(.firstTown, .secondTown)
      //      self.removeTown(forKey: .secondTown)
      UserDefaults.standard.remove(forKey: .secondTown)
    }
  }
  
  // MARK: Interface - UserInfo
  
  var userInfo: UserInfo? {
      return UserDefaults.standard.object(UserInfo.self, forKey: .userInfo)
  }
  
  func register(_ userInfo: UserInfo) {
    UserDefaults.standard.set(userInfo, forKey: .userInfo)
  }
  
  // MARK: Interface - Notification
  
  var fcmToken: String? {
    get {
      return UserDefaults.standard.string(forKey: "fcmToken")
    }
    set {
      guard let token = newValue else { return }
      UserDefaults.standard.set(token, forKey: "fcmToken")
    }
  }
}
