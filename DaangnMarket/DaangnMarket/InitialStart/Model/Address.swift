//
//  GPSAddress.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/25.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

struct Address: Codable {
  let id: Int
  let dong: String
  let gu: String
  let longitude: String
  let latitude: String
  let address: String
}

struct AddressWithDistance: Codable {
  let id: Int
  let dong: String
  let gu: String
  let longitude: String
  let latitude: String
  let address: String
  let distance: Double
}
