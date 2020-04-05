//
//  TownModel.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/25.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Alamofire

class API {
  // MARK: Singleton
  static let `default` = API()
  
  private init() { }
  
  // MARK: Properties
  
  private var nextURL: String?
  
  // MARK: Interface
  
  func request(_ type: RequestAddress, completion: @escaping (Result<[Address], AFError>) -> Void) {
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
  
  func request(_ type: RequestMembers, completion: @escaping (Result<Bool, AFError>) -> Void) {
    AF.request(type.url, method: .post, parameters: type.parameters, encoder: JSONParameterEncoder.default)
      .validate()
      .response { (response) in
        switch response.result {
        case .success(_):
          let statusCode = response.response?.statusCode ?? 0
          print("Status Code :", statusCode)
          completion(.success(statusCode == 201))
        case .failure(let error):
          completion(.failure(error))
        }
    }
  }
}
