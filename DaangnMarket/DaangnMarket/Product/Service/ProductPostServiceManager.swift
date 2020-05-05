//
//  ProductPostServiceManager.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/28.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation
import Alamofire

final class ProductPostServiceManager {
  // MARK: Property
  
  static let shared = ProductPostServiceManager()
  
  func requestProductPost(_ parameters: Parameters, completionHandler: @escaping (Result<Post, Error>) -> Void) {
    AF.request(
      "http://13.125.217.34/post/detail/",
      parameters: parameters
    )
      .validate()
      .responseDecodable { (response: DataResponse<Post, AFError>) in
        switch response.result {
        case .success(let productPost):
          completionHandler(.success(productPost))
        case . failure(let error):
          completionHandler(.failure(error))
        }
    }
  }
  
  
}
