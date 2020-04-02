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
  private lazy var phoneNumberField = NumberField().then {
    $0.delegate = self
    $0.placeholder = "휴대폰 번호(- 없이 숫자만 입력)"
  }
  private lazy var requestCodeButton = DGButton(type: .auth).then {
    $0.setTitle("인증문자 받기", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    $0.layer.cornerRadius = 4
    $0.isEnabled = false
    $0.addTarget(self, action: #selector(didTapAuthButton(_:)), for: .touchUpInside)
  }
  private lazy var authCodeField = NumberField().then {
    $0.delegate = self
    $0.placeholder = "인증번호 입력"
  }
  private let privacyPolicyLabel = UILabel().then {
    $0.attributedText = NSMutableAttributedString()
      .underline("이용약관", fontSize: 15)
      .normal(" 및 ", fontSize: 15)
      .underline("개인정보", fontSize: 15)
      .normal("취급방침", fontSize: 15)
    $0.textColor = UIColor(named: ColorReference.subText.rawValue)
  }
  private lazy var authButton = DGButton().then {
    $0.setTitle("동의하고 시작하기", for: .normal)
    $0.layer.cornerRadius = 4
    $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    $0.isEnabled = false
    $0.addTarget(self, action: #selector(didTapAuthButton(_:)), for: .touchUpInside)
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.phoneNumberField.becomeFirstResponder()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let bottomMargin = self.view.frame.maxY - self.scrollView.frame.maxY
    self.authButton.snp.updateConstraints {
      $0.bottom
        .equalToSuperview()
        .offset(-bottomMargin)
    }
  }
  
  // MARK: Initialize
  
  private func setupUI() {
    self.setupAttributes()
    self.setupNotification()
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
  
  private func setupNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShowNotification(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private func setupConstraints() {
    let height: (textField: CGFloat, button: CGFloat) = (45, 50)
    let padding: CGFloat = 16
    let spacing: CGFloat = 8
    
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
    
    self.phoneNumberField
      .then { self.scrollView.addSubview($0) }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.authDescription.snp.bottom)
          .offset(spacing * 2)
        $0.leading.trailing.equalTo(self.authDescription)
        $0.height.equalTo(height.textField)
    }
    
    self.requestCodeButton
      .then { self.scrollView.addSubview($0) }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.phoneNumberField.snp.bottom)
          .offset(spacing)
        $0.leading.trailing.equalTo(self.phoneNumberField)
        $0.height.equalTo(height.button)
    }
    
    self.authCodeField
      .then { self.scrollView.addSubview($0) }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.requestCodeButton.snp.bottom)
          .offset(spacing * 3)
        $0.leading.trailing.equalTo(self.requestCodeButton)
        $0.height.equalTo(height.textField)
    }
    
    self.privacyPolicyLabel
      .then { self.scrollView.addSubview($0) }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.authCodeField.snp.bottom)
          .offset(36)
        $0.centerX.equalTo(self.authCodeField)
    }
    
    self.authButton
      .then { self.scrollView.addSubview($0) }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.privacyPolicyLabel.snp.bottom)
          .offset(28)
        $0.leading.trailing.equalTo(self.authCodeField)
        $0.bottom.equalToSuperview()
        $0.height.equalTo(height.button)
    }
  }
  
  // MARK: Actions
  
  @objc private func didTapExitButton(_ sender: UIButton) {
    self.dismiss(animated: true)
  }
  
  @objc private func didTapAuthButton(_ sender: UIButton) {
    print("Auth")
  }
  
  @objc private func handleTapGesture(_ sender: UITapGestureRecognizer) {
    self.scrollView.endEditing(false)
  }
  
  // MARK: Keyboard Notification Handler
  
  @objc private func handleKeyboardWillShowNotification(_ noti: Notification) {
    guard let userInfo = noti.userInfo,
      let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
      let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
      else { return }
    
    UIView.animate(withDuration: duration) {
      self.scrollView.snp.updateConstraints {
        $0.bottom
          .equalToSuperview()
          .offset(-frame.height)
      }
      self.view.layoutIfNeeded()
    }
  }
  
  @objc private func handleKeyboardDidShowNotification(_ noti: Notification) {
    let firstResponder: UITextField = self.phoneNumberField.isFirstResponder ? self.phoneNumberField : self.authCodeField
    let convertedRect = firstResponder.convert(self.authCodeField.bounds, to: self.view)
    
    if convertedRect.minY < self.scrollView.frame.minY {
      let diff = self.scrollView.frame.minY - convertedRect.minY
      self.scrollView.setContentOffset(CGPoint(x: 0, y: diff), animated: true)
    }
    
    if firstResponder.isEqual(self.authCodeField) {
      let diff = self.scrollView.frame.midY - convertedRect.midY
      let newOffset = diff < 0 ? CGPoint(x: 0, y: -diff) : self.scrollView.contentOffset
      self.scrollView.setContentOffset(newOffset, animated: true)
    }
  }
  
  @objc private func handleKeyboardWillHideNotification(_ noti: Notification) {
    guard let userInfo = noti.userInfo,
      let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
      else { return }
    
//    UIView.animate(
//      withDuration: duration,
//      animations: {
//        self.scrollView.contentOffset = .zero
//    }) { (_) in
//      self.scrollView.snp.updateConstraints {
//        $0.bottom.equalToSuperview()
//      }
//    }
//    print("ScrollView offset :", scrollView.contentOffset)
    UIView.animate(withDuration: duration) {
      self.scrollView.snp.updateConstraints {
        $0.bottom.equalToSuperview()
      }
      self.view.layoutIfNeeded()
    }
  }
}

// MARK: - UITextFieldDelegate

extension AuthViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField.isEqual(self.phoneNumberField) {
      self.formatPhoneNumber(textField, replacementString: string)
    }
    return self.textShouldInput(textField, replacementString: string)
  }
  
  private func formatPhoneNumber(_ textField: UITextField, replacementString string: String) {
    guard let text = textField.text else { return }
    if string.isEmpty {
      if let whiteSpaceIndex = text.lastIndex(of: " "), whiteSpaceIndex == text.index(text.endIndex, offsetBy: -2) {
        textField.text?.remove(at: whiteSpaceIndex)
      }
    } else if [3, 8].contains(text.count) {
      textField.text?.append(" ")
    }
  }
  
  private func textShouldInput(_ textField: UITextField, replacementString string: String) -> Bool {
    guard let text = textField.text else { return false }
    if textField.isEqual(self.phoneNumberField) {
      return text.count < 13 || string.isEmpty
    } else {
      return text.count < 4 || string.isEmpty
    }
  }
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    guard let text = textField.text else { return }
    self.requestCodeButton.isEnabled = textField.isEqual(self.phoneNumberField) && text.count > 9
    self.authButton.isEnabled = textField.isEqual(self.authCodeField) && !text.isEmpty
  }
}
