//
//  MyTowns.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/05.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class MyTownSetting {
  // MARK: Shared
  
  static var shared = MyTownSetting()
  
  // MARK: TownSelectView Property

  var firstSelectTown = String()
  var secondSelectTown = String()

  var towns = [String: String]()
  
  // MARK: MyTownAroundView Property
  
  var distance = Double()
  var aroundFirtTown = [Town]()
  var aroundSecondTown = [Town]()
  
  enum DeleteTown {
    case oneTown
    case towTown
  }
  
  enum UpperAlerCallBtn {
    case firstBtn
    case secondBtn
  }
}
