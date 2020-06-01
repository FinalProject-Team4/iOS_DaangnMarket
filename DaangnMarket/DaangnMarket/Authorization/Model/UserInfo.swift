//
//  UserInfo.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/05.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
  let authorization: String
  let uid: String
  let avatar: String?
  let phone: String
  let created: String
  let updated: String
  let username: String
}

extension UserInfo {
  enum CodingKeys: String, CodingKey {
    case authorization = "Authorization"
    case uid, avatar, phone, created, updated, username
  }
}
