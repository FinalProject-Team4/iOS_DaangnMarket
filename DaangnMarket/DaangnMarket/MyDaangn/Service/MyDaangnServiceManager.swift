//
//  MyDaangnServiceManager.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/28.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation
import Alamofire

final class MyDaangnServiceManager {
  // MARK: Property
  
  static let shared = MyDaangnServiceManager()
  
  func requestOtherItems(_ parameters: Parameters, completionHandler: @escaping (Result<OtherItems, Error>) -> Void) {
    AF.request("http://13.125.217.34/post/list/", method: .get, parameters: parameters)
      .validate()
      .responseDecodable { (response: DataResponse<OtherItems, AFError>) in
        switch response.result {
        case .success(let otherItems):
          completionHandler(.success(otherItems))
        case .failure(let error):
          completionHandler(.failure(error))
        }
    }
  }
  
  func requestLikeList(_ headers: HTTPHeaders, completionHandler: @escaping (Result<LikeListInfo, Error>) -> Void) {
    AF.request("http://13.125.217.34/post/like/list/", method: .get, headers: headers)
      .validate()
      .responseDecodable { (response: DataResponse<LikeListInfo, AFError>) in
        switch response.result {
        case .success(let likelist):
          completionHandler(.success(likelist))
        case .failure(let error):
          completionHandler(.failure(error))
        }
    }
  }
  
  func requestUpdate(_ parameters: [String: String], _ headers: HTTPHeaders, completion: @escaping (Result<Post, AFError>) -> Void) {
    AF.upload(
      multipartFormData: { (formData) in
        parameters.forEach {
          guard let data = $0.value.data(using: .utf8) else { return }
          formData.append(data, withName: $0.key)
        }
    }, to: "http://13.125.217.34/post/",
       method: .patch,
       headers: headers
    )
      .validate()
      .responseDecodable { (resonse: DataResponse<Post, AFError>) in
        switch resonse.result {
        case .success(let updateResult):
          completion(.success(updateResult))
        case .failure(let error):
          completion(.failure(error))
        }
    }
  }
}

