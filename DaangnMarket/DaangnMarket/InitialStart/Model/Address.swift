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
  let address: Address
  let distance: Double
}

extension AddressWithDistance {
  enum AddressCodingKeys: String, CodingKey {
    case id, dong, gu, longitude, latitude, address, distance
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AddressCodingKeys.self)
    let id = try container.decode(Int.self, forKey: .id)
    let dong = try container.decode(String.self, forKey: .dong)
    let gu = try container.decode(String.self, forKey: .gu)
    let longitude = try container.decode(String.self, forKey: .longitude)
    let latitude = try container.decode(String.self, forKey: .latitude)
    let address = try container.decode(String.self, forKey: .address)
    self.address = Address(id: id, dong: dong, gu: gu, longitude: longitude, latitude: latitude, address: address)
    self.distance = try container.decode(Double.self, forKey: .distance)
  }
}
