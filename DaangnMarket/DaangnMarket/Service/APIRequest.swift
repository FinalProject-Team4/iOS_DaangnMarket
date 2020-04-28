//
//  APIRequest.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/04.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

protocol APIRequest {
  var host: String { get }
  var url: String { get }
}
extension APIRequest {
  var host: String { "http://13.125.217.34" }
}

// MARK: - Reqeust Town

enum RequestTown: APIRequest {
  case search(text: String, page: Int = 1)
//  case GPS(lat: Double, lon: Double, distance: Double = 100_000, page: Int = 1)
  case GPS(lat: Double, lon: Double, distance: Double = 100_000)
  case distance(dongId: Int, distance: Double = 4_800)
  
  var url: String {
    switch self {
    case .search(_, _):
      return host + "/location/"
    case .GPS(_, _, _):
      return host + "/location/range/"
    case .distance(_, _):
      return host + "/location/range/"
    }
  }
  
  var parameters: [String: Any] {
    switch self {
    case let .search(text, page):
      return [
        "dong": text,
        "page": page
      ]
//    case let .GPS(latitude, longitude, distance, page):
      case let .GPS(latitude, longitude, distance):
      return [
        "lati": latitude,
        "longi": longitude,
        "distance": distance,
//        "page": page
      ]
    case let .distance(dongId, distance):
      return [
        "locate": dongId,
        "distance": distance
      ]
    }
  }
}

// MARK: - Request Members

enum RequestMembers: APIRequest {
  case login(idToken: String)
  case signUp(idToken: String, username: String, avatar: Data?)
  
  var url: String {
    switch self {
    case .login(_):
      return host + "/members/login/"
    case .signUp(_, _, _):
      return host + "/members/signup/"
    }
  }
}

enum DaangnURL {
  enum Notification: APIRequest {
    case registerKey
    case noticeList
    
    var url: String {
      switch self {
      case .registerKey:
        return host + "/fcm/register/"
      case .noticeList:
        return host + "/fcm/list/notice/"
      }
    }
  }
  enum UserTown: APIRequest {
    case register
    case townList
    
    var url: String {
      switch self {
      case .register:
        return self.host + "/members/locate/"
      case .townList:
        return self.host + "/members/locate/"
      }
    }
  }
}
