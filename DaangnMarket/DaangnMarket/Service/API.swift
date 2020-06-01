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
  
  func request(_ type: RequestTown, completion: @escaping (Result<[Town], AFError>) -> Void) {
    AF.request(type.url, parameters: type.parameters)
      .validate()
      .responseDecodable { (response: DataResponse<TownInfo, AFError>) in
        switch response.result {
        case .success(let townInfo):
          completion(.success(townInfo.results))
          self.nextURL = townInfo.next
        case .failure(let error):
          completion(.failure(error))
        }
    }
  }
  
  func requestNext(completion: @escaping (Result<[Town], AFError>) -> Void) {
    guard let next = self.nextURL else { return }
    AF.request(next)
      .validate()
      .responseDecodable { (response: DataResponse<TownInfo, AFError>) in
        switch response.result {
        case .success(let townInfo):
          completion(.success(townInfo.results))
          self.nextURL = townInfo.next
        case .failure(let error):
          completion(.failure(error))
        }
    }
  }
  
  func request(_ type: RequestMembers, completion: @escaping (Result<UserInfo, AFError>) -> Void) {
    switch type {
    case let .login(idToken):
      let parameters = ["id_token": idToken]
      self.requestLogin(url: type.url, parameters: parameters) { completion($0) }
    case let .signUp(idToken, username, avatar):
      let parameters = [
        "id_token": idToken,
        "username": username
      ]
      self.requestSignUp(url: type.url, imageData: avatar, parameters: parameters) { completion($0) }
    }
  }
  
  private func requestLogin(url: String, parameters: [String: String], completion: @escaping (Result<UserInfo, AFError>) -> Void) {
    AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
      .validate()
      .responseDecodable { (response: DataResponse<UserInfo, AFError>) in
        switch response.result {
        case .success(let user):
          completion(.success(user))
        case .failure(let error):
          completion(.failure(error))
        }
    }
  }
  
  private func requestSignUp(url: String, imageData: Data?, parameters: [String: String], completion: @escaping (Result<UserInfo, AFError>) -> Void) {
    AF.upload(
      multipartFormData: { (formData) in
        parameters.forEach {
          guard let data = $0.value.data(using: .utf8) else { return }
          formData.append(data, withName: $0.key)
        }
        if let imageData = imageData {
          formData.append(imageData, withName: "avatar")
        }
    },
      to: url,
      method: .post
    )
      .validate()
      .responseDecodable { (response: DataResponse<UserInfo, AFError>) in
        switch response.result {
        case .success(let userInfo):
          completion(.success(userInfo))
        case .failure(let error):
          completion(.failure(error))
        }
    }
  }
  
  // MARK: Notification
  
  func requestActivityNoti(token: String, completion: @escaping (Result<ActivityNotiInfo, AFError>) -> Void) {
    let header = HTTPHeader(name: "Authorization", value: token)
    AF.request(DaangnURL.Notification.noticeList.url, headers: [header])
      .validate()
      .responseDecodable { (response: DataResponse<ActivityNotiInfo, AFError>) in
        switch response.result {
        case .success(let notiInfo):
          completion(.success(notiInfo))
        case .failure(let error):
          completion(.failure(error))
        }
    }
  }
  
  func requestNextActivityNoti(nextURL: String, token: String, completion: @escaping (Result<ActivityNotiInfo, AFError>) -> Void) {
    let header = HTTPHeader(name: "Authorization", value: token)
    AF.request(nextURL, headers: [header])
      .validate()
      .responseDecodable { (response: DataResponse<ActivityNotiInfo, AFError>) in
        switch response.result {
        case .success(let notiInfo):
          completion(.success(notiInfo))
        case .failure(let error):
          completion(.failure(error))
        }
    }
  }
  
  func requestPushKeyRegister(authToken: String, fcmToken: String, completion: @escaping (Result<Any, AFError>) -> Void) {
    let header = HTTPHeader(name: "Authorization", value: authToken)
    AF.request(DaangnURL.Notification.registerKey.url, method: .post, parameters: ["registration_id": fcmToken], headers: [header])
      .validate()
      .responseJSON { (response) in
        print("=============== \(#function) ===============")
        print("HTTP Status Code :", response.response!.statusCode)
        print("FCM Token :", fcmToken)
        print("Auth Token :", authToken)
        switch response.result {
        case .success(let value):
          completion(.success(value))
        case .failure(let error):
          completion(.failure(error))
        }
    }
  }
  
  // MARK: User Town  

  func requestRegisterUserTown(userTown: UserTown, authToken: String, completion: @escaping (Result<UserTown, AFError>) -> Void) {
    let parameters: Parameters = [
      "locate": userTown.locate.id.description,
      "distance": userTown.distance.description,
      "verified": userTown.verified,
      "activated": userTown.activated
    ]
    let header = HTTPHeader(name: "Authorization", value: authToken)
    AF.request(DaangnURL.UserTown.register.url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders([header]))
      .validate()
      .responseDecodable { (response: DataResponse<UserTown, AFError>) in
        switch response.result {
        case .success(let userTown):
          completion(.success(userTown))
        case .failure(let error):
          completion(.failure(error))
        }
    }
  }
  
  func requestUserTown(authToken: String, completion: @escaping (Result<[UserTown], AFError>) -> Void) {
    let header = HTTPHeader(name: "Authorization", value: authToken)
    AF.request(DaangnURL.UserTown.register.url, headers: HTTPHeaders([header]))
      .validate()
      .responseDecodable { (response: DataResponse<[UserTown], AFError>) in
        switch response.result {
        case .success(let userTowns):
          completion(.success(userTowns))
        case .failure(let error):
          completion(.failure(error))
        }
    }
  }
}
