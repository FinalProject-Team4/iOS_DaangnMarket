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
  
//  static var findTownAddres: Address?
  var towns = [String: String]()
  
  // MARK: MyTownAroundView Property
  
  var distance = Double()
  var numberOfAroundTown: Int?
  var selectTownName: String?
}
