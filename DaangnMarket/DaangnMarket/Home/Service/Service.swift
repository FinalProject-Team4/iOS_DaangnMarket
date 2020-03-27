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
  private let postsListGpsPath = "post/list/"
  private let page = 1
  
  func requestUser(completionHandler: @escaping (Result<[PostsInfo], Error>) -> Void) {
    let url = host + postsListGpsPath
    let parameters = ["page": page]
    AF.request(url, parameters: parameters)
      .validate()
      .responseDecodable { (response: DataResponse<[PostsInfo], AFError>) in
        switch response.result {
        case .success(let data):
          completionHandler(.success(data))
        case . failure(let error):
          completionHandler(.failure(error))
        }
      }
  }
}

