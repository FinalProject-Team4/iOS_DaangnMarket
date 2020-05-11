//
//  AuthViewController.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/31.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
  // MARK: View
  
  private lazy var scrollView = UIScrollView().then {
    $0.keyboardDismissMode = .interactive
    $0.clipsToBounds = false
    $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:))))
  }
  private let authDescription = AuthDescriptionView()
  private lazy var authInputForm = AuthInputForm().then {
    $0.delegate = self
  }
  private lazy var upperAlert = DGUpperAlert()
  private let activityIndicator = DGActivityIndicator()
  
  // MARK: Model
  
  private lazy var phoneAuthManager = PhoneAuthorizationManager().then {
    $0.delegate = self
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.authInputForm.becomeFirstResponder()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let bottomMargin = self.view.frame.maxY - self.scrollView.frame.maxY
    self.authInputForm.updateBottomMargin(bottomMargin)
  }
  
  // MARK: Initialize
  
  private func setupUI() {
    self.setupAttributes()
    self.setupConstraints()
  }
  
  private func setupAttributes() {
    self.view.backgroundColor = .systemBackground
    UIBarButtonItem(
      image: UIImage(systemName: ImageReference.xmark.rawValue),
      style: .done,
      target: self,
      action: #selector(didTapExitButton(_:))
    ).do {
      $0.tintColor = .black
      self.navigationItem.leftBarButtonItem = $0
    }
    self.navigationItem.title = "로그인/가입"
    self.navigationController?.navigationBar.barTintColor = self.view.backgroundColor
  }
  
  private func setupConstraints() {
    let padding: CGFloat = 16
    
    self.scrollView
      .then { self.view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        $0.bottom.equalToSuperview()
    }
    
    self.authDescription
      .then { self.scrollView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.trailing
          .equalToSuperview()
          .inset(UIEdgeInsets(top: padding, left: padding, bottom: 0, right: padding))
        $0.width.equalToSuperview().offset(-padding * 2)
    }
    
    self.authInputForm
      .then { self.scrollView.addSubview($0) }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.authDescription.snp.bottom)
          .offset(padding)
        $0.leading.trailing.equalTo(self.authDescription)
        $0.bottom.equalToSuperview()
    }
    
    self.activityIndicator
      .then { self.view.addSubview($0) }
      .snp.makeConstraints {
        $0.center.equalToSuperview()
    }
  }
  
  // MARK: Actions
  
  @objc private func didTapExitButton(_ sender: UIButton) {
    self.dismiss(animated: true)
  }
  
  @objc private func handleTapGesture(_ sender: UITapGestureRecognizer) {
    self.scrollView.endEditing(false)
  }
}

// MARK: - AuthInputFormDelegate

extension AuthViewController: AuthInputFormDelegate {
  func authInputFormKeyboardWillShow(_ authInputForm: AuthInputForm, keyboardFrame frame: CGRect, animateDuration duration: TimeInterval) {
    UIView.animate(withDuration: duration) {
      self.scrollView.snp.updateConstraints {
        $0.bottom
          .equalToSuperview()
          .offset(-frame.height)
      }
      self.view.layoutIfNeeded()
    }
  }
  
  func authInputFormKeyboardDidShow(_ authInputForm: AuthInputForm, phoneNumberField: UITextField, authCodeField: UITextField) {
    let firstResponder: UITextField = phoneNumberField.isFirstResponder ? phoneNumberField : authCodeField
    let convertedRect = firstResponder.convert(authCodeField.bounds, to: self.view)
    
    if convertedRect.minY < self.scrollView.frame.minY {
      let diff = self.scrollView.frame.minY - convertedRect.minY
      self.scrollView.setContentOffset(CGPoint(x: 0, y: diff), animated: true)
    }
    
    if firstResponder.isEqual(authCodeField) {
      let diff = self.scrollView.frame.midY - convertedRect.midY
      let newOffset = diff < 0 ? CGPoint(x: 0, y: -diff) : self.scrollView.contentOffset
      self.scrollView.setContentOffset(newOffset, animated: true)
    }
  }
  
  func authInputFormKeyboardWillHide(_ authInputForm: AuthInputForm, keyboardFrame frame: CGRect, animateDuration duration: TimeInterval) {
    UIView.animate(withDuration: duration) {
      self.scrollView.snp.updateConstraints {
        $0.bottom.equalToSuperview()
      }
      self.view.layoutIfNeeded()
    }
  }
  
  func authInputForm(_ authInputForm: AuthInputForm, didSelectRequestCodeButton button: UIButton, phoneNumber: String) {
    do {
      try PhoneAuthorizationManager.checkValidPhoneNumber(phoneNumber)
      
      let formatted = PhoneAuthorizationManager.convertValidFormat(phoneNumber)
      self.phoneAuthManager.requestCode(phone: formatted) { (result) in
        switch result {
        case .success(let success):
          self.upperAlert.show(message: success.localizedDescription)
        case .failure(let error as PhoneAuthorizationError) where error == .exceedNumberOfRequest:
          self.presentAlert(
            title: error.localizedDescription,
            actions: [.init(title: "닫기", style: .default)]
          )
          self.upperAlert.show(message: error.localizedDescription)
        case .failure(let error):
          self.upperAlert.show(message: error.localizedDescription)
        }
      }
    } catch {
      self.upperAlert.show(message: error.localizedDescription)
    }
  }
  
  func authInputForm(_ authInputForm: AuthInputForm, didSelectAuthorizationButton button: UIButton, verificationCode: String) {
    self.activityIndicator.startAnimating()
    self.phoneAuthManager.signIn(with: verificationCode) { (result) in
      switch result {
      case .success(let idToken):
        API.default.request(.login(idToken: idToken)) { (result) in
          print("==================== Firebase Auth ID TOKEN ====================\n", idToken)
          switch result {
          case .success(let userInfo):
            print("=================== User Info ====================\n", userInfo)
            API.default.requestUserTown(authToken: userInfo.authorization) { (result) in
              defer { self.activityIndicator.stopAnimating() }
              switch result {
              case .success(let userTonws):
                userTonws.forEach {
                  if $0.activated {
                    AuthorizationManager.shared.firstTown = $0
                  } else {
                    AuthorizationManager.shared.secondTown = $0
                  }
                }
                AuthorizationManager.shared.register(userInfo)
                self.dismiss(animated: true)
//                // GCM Token 등록하기
//                if let fcmToken = AuthorizationManager.shared.fcmToken {
//                  API.default.requestPushKeyRegister(authToken: userInfo.authorization, fcmToken: fcmToken) { (result) in
//                    switch result {
//                    case .success(_):
//                      userTonws.forEach {
//                        if $0.activated {
//                          AuthorizationManager.shared.firstTown = $0
//                        } else {
//                          AuthorizationManager.shared.secondTown = $0
//                        }
//                      }
//                      AuthorizationManager.shared.register(userInfo)
//                      self.dismiss(animated: true)
//                    case .failure(let error):
//                      self.presentAlert(title: "Register FCM Token Error", message: error.localizedDescription)
//                    }
//                  }
//                } else {
//                  self.presentAlert(title: "No FCM Token Error")
//                }
              case .failure(let error):
                self.presentAlert(title: "Login Error", message: error.localizedDescription)
              }
            }
          case .failure(let error) where error.responseCode == 401:
            self.activityIndicator.stopAnimating()
            ViewControllerGenerator.shared
              .make(.signUp, parameters: ["id_token": idToken])?
              .do {
                $0.modalPresentationStyle = .fullScreen
                self.present($0, animated: true)
            }
          case .failure(let error):
            self.activityIndicator.stopAnimating()
            self.presentAlert(title: "Login Error", message: error.localizedDescription)
          }
        }
      case .failure(let error):
        self.activityIndicator.stopAnimating()
        self.presentAlert(title: "Auth Error", message: error.localizedDescription)
      }
    }
  }
}

// MARK: - PhoneAuthorizationManagerDelegate

extension AuthViewController: PhoneAuthorizationManagerDelegate {
  func phoneAuthorization(_ phoneAuthorization: PhoneAuthorizationManager, formattedTimeForLeft time: String) {
    self.authInputForm.updateRemainingTime(time)
  }
}
