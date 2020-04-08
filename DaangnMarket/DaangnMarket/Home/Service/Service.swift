//
//  Service.swift
//  DaangnMarket
//
//  Created by Demian on 2020/03/26.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import Alamofire

final class ServiceManager {
  static let shared = ServiceManager()
  
  private let host = "http://13.125.217.34/"
  private let postsListPath = "post/list/"
//  let parameters: Parameters = ["page": 1]
  
  func requestUser(_ parameters: Parameters, completionHandler: @escaping (Result<PostInfo, Error>) -> Void) {
    let url = host + postsListPath
    AF.request(url, parameters: parameters)
      .validate()
      .responseDecodable { (response: DataResponse<PostInfo, AFError>) in
        switch response.result {
        case .success(let data):
          completionHandler(.success(data))
        case . failure(let error):
          completionHandler(.failure(error))
        }
      }
  }
}

