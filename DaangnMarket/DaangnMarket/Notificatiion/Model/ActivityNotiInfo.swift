//
//  ActivityNotification.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

struct ActivityNotiInfo: Codable {
  let count: Int
  let next: String?
  let previous: String?
  let results: [ActivityNoti]
}

struct ActivityNoti: Codable {
  let sender: String
  let receiver: String
  let title: String
  let body: String
  var created: String
}
