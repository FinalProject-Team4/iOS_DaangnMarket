//
//  MyTowns.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/05.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class MyTownSetting {
  static var shared = MyTownSetting()
  static var findTownAddres: Address?
  var towns = [String: String]()
  var distance = Double()
  var numberOfAroundTown: Int?
  var selectTownName: String?
}
