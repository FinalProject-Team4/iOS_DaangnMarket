//
//  SalesListData.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

class SalesListData {
  static let shared = SalesListData()
  
  private init() {}
  
  var onSaleData: [Post] = []
  var endOfSaleData: [Post] = []
  var hiddenData: [Post] = []
}
