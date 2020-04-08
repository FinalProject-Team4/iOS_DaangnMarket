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

// MARK: - Reqeust Address

enum RequestAddress: APIRequest {
  case search(text: String, page: Int = 1)
  case GPS(lat: Double, lon: Double, distance: Double = 100_000, page: Int = 1)
  case distance(dongId: Int, distance: Double)
  
  var url: String {
    switch self {
    case .search(_, _):
      return host + "/location/locate/search/"
    case .GPS(_, _, _, _):
      return host + "/location/locate/gps/"
    case .distance(_, _):
      return host + "/location/locate/"
    }
  }
  
  var parameters: [String: Any] {
    switch self {
    case let .search(text, page):
      return [
        "dong_name": text,
        "page": page
      ]
    case let .GPS(latitude, longitude, distance, page):
      return [
        "latitude": latitude,
        "longitude": longitude,
        "distance": distance,
        "page": page
      ]
    case let .distance(dongId, distance):
      return [
        "dong_id": dongId,
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
