//
//  SearchHistoryModel.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

extension Notification.Name {
  static let HistoryNotification = Notification.Name("HistoryNewValue")
}

class SearchHistory {
  static let shared = SearchHistory()
  
  var history: [String] = [] {
    didSet {
      NotificationCenter.default.post(name: .HistoryNotification, object: nil)
    }
  }
  
  private init() { }
}

enum SearchType {
  case usedDeal, townInfo, person
}

enum SearchStatus {
  case standBy, searching, success, fail
}
