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
  // MARK: Property
  
  static let shared = ServiceManager()
  
  // MARK: Request Post & PostInfo Data
  
  func requestPostData(_ url: URL, _ parameters: Parameters, completionHandler: @escaping (Result<PostInfo, Error>) -> Void) {
      AF.request(url, parameters: parameters)
      .validate()
      .responseDecodable { (response: DataResponse<PostInfo, AFError>) in
        switch response.result {
        case .success(let postInfo):
          completionHandler(.success(postInfo))
        case . failure(let error):
          print(error)
          completionHandler(.failure(error))
        }
    }
  }
}

