//
//  MyTowns.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/05.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class MyTownSetting {
  private init() {}
  
  // MARK: Shared
  
  static var shared = MyTownSetting()
  
  // MARK: TownSelectView Property
  
  func register(isFirstTown: Bool) {
    UserDefaults.standard.set(isFirstTown, forKey: "isFirstTowns")
  }
  
  var isFirstTown: Bool {
    return UserDefaults.standard.bool(forKey: "isFirstTowns")
  }
  
//  var isFirstTown = Bool()

  var firstSelectTown = String()
  var secondSelectTown = String()

  var towns = [String: String]()
  
  // MARK: MyTownAroundView Property
  
  var firstTownByDistance: [Town]? {
    return UserDefaults.standard.object([Town].self, forKey: .firstTownByDistance)
  }
  
  var secondTownByDistance: [Town]? {
    return UserDefaults.standard.object([Town].self, forKey: .secondTownByDistance)
  }
  
  func register(townInfo: [Town]) {
    if self.firstTownByDistance == nil {
      UserDefaults.standard.set(townInfo, forKey: .firstTownByDistance)
    } else if self.secondTownByDistance == nil {
      UserDefaults.standard.set(townInfo, forKey: .secondTownByDistance)
    } else {
      return
    }
  }
  
  var firstAroundTownList = [Town]()
  var secondAroundTownList = [Town]()
  
  var slideValue = Float()
  var numberOfAroundTownByFirst = (Int(), Int())
  var numberOfAroundTownBySecond = (Int(), Int())
  
  enum DeleteTown {
    case oneTown
    case twoTown
  }
  
  enum UpperAlerCallBtn {
    case firstBtn
    case secondBtn
  }
}
