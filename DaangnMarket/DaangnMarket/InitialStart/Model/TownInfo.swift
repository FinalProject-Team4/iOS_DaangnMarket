//
//  TownInfo.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/25.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

// MARK: - TownInfo

struct TownInfo: Codable {
  let count: Int
  let next: String?
  let previous: String?
  let results: [Town]
  
  init() {
    self.count = 0
    self.next = nil
    self.previous = nil
    self.results = []
  }
}

// MARK: - Town

struct Town: Codable {
  let id: Int
  let dong: String
  let gu: String
  let longitude: String
  let latitude: String
  let address: String
  let distance: Double?
}

struct UserTown: Codable {
  var user: String
  var verified: Bool
  var activated: Bool
  var distance: Int
  var locate: Town
}
