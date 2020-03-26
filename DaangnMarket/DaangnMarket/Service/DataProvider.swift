//
//  TownModel.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/25.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Alamofire

enum RequestURL {
  enum Address {
    case search
    case gps
    case distance
    
    var url: String {
      let host = "http://13.125.217.34/"
      
      switch self {
      case .search:
        return host + "location/locate/search/"
      case .gps:
        return host + "location/locate/gps/"
      case .distance:
        return host + "location/locate/"
      }
    }
  }
}

enum DataProvider {
  static func requestAddress(latitude: Double, longitude: Double, distance: Double = 1_000, completion: @escaping (Result<[AddressWithDistance], AFError>) -> Void) {
    let parameters: Parameters = [
      "latitude": latitude,
      "longitude": longitude,
      "distance": distance
    ]
    AF.request(RequestURL.Address.gps.url, parameters: parameters)
      .validate()
      .responseDecodable { (response: DataResponse<[AddressWithDistance], AFError>) in
        completion(response.result)
    }
  }

  static func requestAddress(address: String, completion: @escaping (Result<[Address], AFError>) -> Void) {
    let parameters: Parameters = [
      "dong_name": address
    ]
    AF.request(RequestURL.Address.search.url, parameters: parameters)
      .validate()
      .responseDecodable { (response: DataResponse<[Address], AFError>) in
        completion(response.result)
    }
  }
  
  static func requestAddress(distance: Double, completion: @escaping (Result<[AddressWithDistance], AFError>) -> Void) {
    let parameters: Parameters = [
      "distance": distance
    ]
    AF.request(RequestURL.Address.distance.url, parameters: parameters)
      .validate()
      .responseDecodable { (response: DataResponse<[AddressWithDistance], AFError>) in
        completion(response.result)
    }
  }
}
