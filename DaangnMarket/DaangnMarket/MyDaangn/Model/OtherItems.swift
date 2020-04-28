//
//  OtherItems.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/28.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

struct OtherItems: Codable {
  let count: Int
  let next: String?
  let previous: String?
  let results: [Post]
  
  init() {
    self.count = 0
    self.next = nil
    self.previous = nil
    self.results = []
  }
}
