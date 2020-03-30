//
//  TownModel.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/25.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Alamofire

enum RequestType {
  case addressBySearch(text: String, page: Int = 1)
  case addressByGPS(lat: Double, lon: Double, distance: Double = 100_000, page: Int = 1)
  case addressByDistance(distance: Double)
  
  var url: String {
    switch self {
    case .addressBySearch(_, _):
      return "http://13.125.217.34/location/locate/search/"
    case .addressByGPS(_, _, _, _):
      return "http://13.125.217.34/location/locate/gps/"
    case .addressByDistance(_):
      return "http://13.125.217.34/location/locate/"
    }
  }
  
  var parameters: Parameters {
    switch self {
    case let .addressBySearch(text, page):
      return [
        "dong_name": text,
        "page": page
      ]
    case let .addressByGPS(latitude, longitude, distance, page):
      return [
        "latitude": latitude,
        "longitude": longitude,
        "distance": distance,
        "page": page
      ]
    case let .addressByDistance(distance):
      return [
        "distance": distance
      ]
    }
  }
}

class API {
  // MARK: Singleton
  static let `default` = API()
  
  private init() { }
  
  // MARK: Properties
  
  private var nextURL: String?
  
  // MARK: Interface
  
  func request(_ type: RequestType, completion: @escaping (Result<[Address], AFError>) -> Void) {
    AF.request(type.url, parameters: type.parameters)
      .validate()
      .responseDecodable { (response: DataResponse<AddressInfo, AFError>) in
        switch response.result {
        case .success(let addressInfo):
          completion(.success(addressInfo.results))
          self.nextURL = addressInfo.next
        case .failure(let error):
          completion(.failure(error))
        }
    }
  }
  
  func requestNext(completion: @escaping (Result<[Address], AFError>) -> Void) {
    guard let next = self.nextURL else { return }
    AF.request(next)
      .validate()
      .responseDecodable { (response: DataResponse<AddressInfo, AFError>) in
        switch response.result {
        case .success(let addressInfo):
          completion(.success(addressInfo.results))
          self.nextURL = addressInfo.next
        case .failure(let error):
          completion(.failure(error))
        }
    }
  }
}
