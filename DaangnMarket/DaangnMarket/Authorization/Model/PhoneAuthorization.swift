//
//  PhoneAuthorization.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/04.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation
import Firebase

enum PhoneAuthorizationError: Error {
  case invalidFormat
  case exceedNumberOfRequest
  case unknownID
  
  var localizedDescription: String {
    switch self {
    case .invalidFormat:
      return "전화번호가 잘못되었어요. 다시 한번 확인해주세요."
    case .exceedNumberOfRequest:
      return "문자 인증번호는 하루에 최대 6회 받을 수 있습니다."
    case .unknownID:
      return "Unknown Verification ID"
    }
  }
}

enum PhoneAuthorizationSuccess {
  case success
  case successLeftCount(Int)
  
  var localizedDescription: String {
    switch self {
    case .success:
      return "인증번호가 문자로 전송되었습니다. (최대 20초 소요)"
    case .successLeftCount(let authCount):
      return "일일 문자 인증 가능 건수가 \(authCount)건 남았습니다"
    }
  }
}

enum SignInError: Error {
  case invalidCode
  case unknownID
  case unknownUser
  case unknownToken
  
  var localizedDescription: String {
    switch self {
    case .invalidCode:
      return "인증문자를 다시 입력해주세요"
    case .unknownUser:
      return "Unknown User"
    case .unknownID:
      return "Unknown Verification ID"
    case .unknownToken:
      return "Unknown ID Token"
    }
  }
}

protocol PhoneAuthorizationManagerDelegate: class {
  func phoneAuthorization(_ phoneAuthorization: PhoneAuthorizationManager, formattedTimeForLeft time: String)
}

class PhoneAuthorizationManager: NSObject {
  // MARK: Properties
  
  private var authCount: Int
  private var verificationID: String?
  weak var delegate: PhoneAuthorizationManagerDelegate?
  
  // MARK: Initialize
  
  override init() {
    Auth.auth().do {
      $0.languageCode = "kr"
      $0.settings?.isAppVerificationDisabledForTesting = true
    }
    self.authCount = 6
    self.timeLeft = 5 * 60
    
    super.init()
  }
  
  // MARK: Timer
  
  private var timer: Timer?
  private var timeLeft: Int {
    didSet {
      let formatted = String(format: "%02d분 %02d초", self.timeLeft / 60, self.timeLeft % 60)
      self.delegate?.phoneAuthorization(self, formattedTimeForLeft: formatted)
    }
  }
  
  private func timerStart() {
    if let timer = timer {
      timer.invalidate()
      timeLeft = 5 * 60
    }
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
  }
  
  @objc func onTimerFires() {
    timeLeft -= 1
    if timeLeft <= 0 {
      timer?.invalidate()
      timer = nil
      timeLeft = 5 * 60
    }
  }
  
  func requestCode(phone: String, completion: @escaping (Result<PhoneAuthorizationSuccess, Error>) -> Void) {
    if self.authCount < 1 {
      return completion(.failure(PhoneAuthorizationError.exceedNumberOfRequest))
    }
    
    PhoneAuthProvider
      .provider()
      .verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
        if let error = error {
          completion(.failure(error))
        } else {
          self.timerStart()
          self.verificationID = verificationID
          self.authCount -= 1
          if self.authCount > 2 {
            completion(.success(.success))
          } else {
            completion(.success(.successLeftCount(self.authCount)))
          }
        }
    }
  }
  
  func signIn(with verificationCode: String, completion: @escaping (Result<String, Error>) -> Void) {
    guard let verificationID = verificationID else { return completion(.failure(SignInError.unknownID)) }
    
    PhoneAuthProvider
      .provider()
      .credential(withVerificationID: verificationID, verificationCode: verificationCode)
      .do {
        Auth.auth()
          .signIn(with: $0) { (authDataResult, error) in
            if let error = error {
              completion(.failure(error))
            } else {
              guard let user = authDataResult?.user else {
                return completion(.failure(SignInError.unknownUser))
              }
              user.getIDToken { (token, error) in
                if let error = error {
                  completion(.failure(error))
                } else if let token = token {
                  completion(.success(token))
                } else {
                  completion(.failure(SignInError.unknownToken))
                }
              }
            }
        }
    }
  }
  
  class func checkValidPhoneNumber(_ phone: String) throws {
    let regex = "^01([0|1|6|7|8|9]?)\\s?([0-9]{3,4})\\s?([0-9]{4})$"
    if !NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: phone) {
      throw PhoneAuthorizationError.invalidFormat
    }
  }
  
  class func convertValidFormat(_ phone: String) -> String {
    return phone
      .replacingCharacters(in: Range(NSRange(location: 0, length: 1), in: phone)!, with: "+82")
      .replacingOccurrences(of: " ", with: "")
  }
}
