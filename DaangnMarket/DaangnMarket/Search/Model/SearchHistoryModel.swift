//
//  SearchHistoryModel.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

extension Notification.Name {
  static let addHistoryKeyword = Notification.Name("AddHistoryKeyword")
  static let removeHistoryKeyword = Notification.Name("RemoveHistoryKeyword")
}

class SearchHistory {
  static let shared = SearchHistory()
  
  var history: [String] = [] {
    didSet {
      if oldValue.count > self.history.count {
        NotificationCenter.default.post(name: .removeHistoryKeyword, object: nil)
      } else if oldValue.count < self.history.count {
        NotificationCenter.default.post(name: .addHistoryKeyword, object: nil)
      } else {
        print("전체 삭제 누름")
      }
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
