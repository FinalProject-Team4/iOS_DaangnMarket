//
//  GPSAddress.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/25.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

// MARK: - AddressInfo

struct AddressInfo: Decodable {
  let count: Int
  let next: String?
  let previous: String?
  let results: [Address]
  
  init() {
    self.count = 0
    self.next = nil
    self.previous = nil
    self.results = []
  }
}

// MARK: - Address

struct Address: Decodable {
  let id: Int
  let dong: String
  let gu: String
  let longitude: String
  let latitude: String
  let address: String
  let distance: Double?
}
