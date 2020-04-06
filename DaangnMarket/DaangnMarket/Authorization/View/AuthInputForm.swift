//
//  AuthInputForm.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/04.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol AuthInputFormDelegate: class {
  func authInputFormKeyboardWillShow(_ authInputForm: AuthInputForm, keyboardFrame frame: CGRect, animateDuration duration: TimeInterval)
  func authInputFormKeyboardDidShow(_ authInputForm: AuthInputForm, phoneNumberField: UITextField, authCodeField: UITextField)
  func authInputFormKeyboardWillHide(_ authInputForm: AuthInputForm, keyboardFrame frame: CGRect, animateDuration duration: TimeInterval)
  func authInputForm(_ authInputForm: AuthInputForm, didSelectRequestCodeButton button: UIButton, phoneNumber: String)
  func authInputForm(_ authInputForm: AuthInputForm, didSelectAuthorizationButton button: UIButton, verificationCode: String)
}

class AuthInputForm: UIView {
  // MARK: Interface
  
  func updateRemainingTime(_ time: String) {
    self.requestCodeButton.setTitle("인증문자 다시 받기 \(time)", for: .normal)
  }
  
  func updateBottomMargin(_ margin: CGFloat) {
    self.authButton.snp.updateConstraints {
      $0.bottom.equalToSuperview().offset(-margin)
    }
  }
  
  // MARK: Views
  
  private lazy var phoneNumberField = NumberField().then {
    $0.delegate = self
    $0.placeholder = "휴대폰 번호(- 없이 숫자만 입력)"
  }
  private lazy var requestCodeButton = DGButton(type: .auth).then {
    $0.setTitle("인증문자 받기", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    $0.layer.cornerRadius = 4
    $0.isEnabled = false
    $0.addTarget(self, action: #selector(didTapRequestCodeButton(_:)), for: .touchUpInside)
  }
  private lazy var authCodeField = NumberField().then {
    $0.delegate = self
    $0.placeholder = "인증번호 입력"
    $0.clearsOnBeginEditing = true
  }
  private let authFieldStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
    $0.alignment = .fill
    $0.distribution = .fill
  }
  private let warningLabel = UILabel().then {
    $0.text = "⚠︎ 인증문자를 다시 입력해주세요."
    $0.textColor = .red
    $0.font = .systemFont(ofSize: 13)
    $0.textAlignment = .center
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
  
  // MARK: Properties
  
  weak var delegate: AuthInputFormDelegate?
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
    self.setupNotification()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  private func setupNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShowNotification(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private func setupConstraints() {
    let height: (textField: CGFloat, button: CGFloat) = (45, 50)
    let spacing: CGFloat = 8
    
    self.phoneNumberField
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.trailing.equalToSuperview()
        $0.height.equalTo(height.textField)
    }
    
    self.requestCodeButton
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.phoneNumberField.snp.bottom)
          .offset(spacing)
        $0.leading.trailing.equalToSuperview()
        $0.height.equalTo(height.button)
    }
    
    self.authCodeField
      .then { self.authFieldStackView.addArrangedSubview($0) }
      .snp.makeConstraints { $0.height.equalTo(height.textField) }
    
    self.authFieldStackView
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.requestCodeButton.snp.bottom)
          .offset(spacing * 3)
        $0.leading.trailing.equalToSuperview()
    }
    
    self.privacyPolicyLabel
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.authFieldStackView.snp.bottom)
          .offset(36)
        $0.centerX.equalToSuperview()
    }
    
    self.authButton
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.privacyPolicyLabel.snp.bottom)
          .offset(28)
        $0.leading.trailing.equalToSuperview()
        $0.bottom.equalToSuperview()
        $0.height.equalTo(height.button)
    }
  }
  
  // MARK: Actions
  
  @objc private func didTapRequestCodeButton(_ sender: UIButton) {
    self.endEditing(false)
    self.delegate?.authInputForm(self, didSelectRequestCodeButton: sender, phoneNumber: self.phoneNumberField.text ?? "")
  }
  
  @objc private func didTapAuthButton(_ sender: UIButton) {
    self.endEditing(false)
    
    if let text = self.authCodeField.text, text.count < 6 {
      self.authFieldStackView.addArrangedSubview(self.warningLabel)
      self.authCodeField.layer.borderColor = UIColor.red.cgColor
    } else {
      self.delegate?.authInputForm(self, didSelectAuthorizationButton: sender, verificationCode: self.authCodeField.text ?? "")
    }
  }
  
  // MARK: Keyboard Notification Handler
  
  @objc private func handleKeyboardWillShowNotification(_ noti: Notification) {
    guard let userInfo = noti.userInfo,
      let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
      let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
      else { return }
    self.delegate?.authInputFormKeyboardWillShow(self, keyboardFrame: frame, animateDuration: duration)
  }
  
  @objc private func handleKeyboardDidShowNotification(_ noti: Notification) {
    self.delegate?.authInputFormKeyboardDidShow(self, phoneNumberField: self.phoneNumberField, authCodeField: self.authCodeField)
  }
  
  @objc private func handleKeyboardWillHideNotification(_ noti: Notification) {
    guard let userInfo = noti.userInfo,
      let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
      let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
      else { return }
    self.delegate?.authInputFormKeyboardWillHide(self, keyboardFrame: frame, animateDuration: duration)
  }
  
  // MARK: Methos
  
  @discardableResult
  override func becomeFirstResponder() -> Bool {
    return self.phoneNumberField.becomeFirstResponder()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UITextFieldDelegate

extension AuthInputForm: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    self.authCodeField.layer.borderColor = UIColor(named: ColorReference.borderLine.rawValue)?.cgColor
    self.warningLabel.do {
      self.authFieldStackView.removeArrangedSubview($0)
      $0.removeFromSuperview()
    }
  }
  
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
      return text.count < 6 || string.isEmpty
    }
  }
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    guard let text = textField.text else { return }
    self.requestCodeButton.isEnabled = textField.isEqual(self.phoneNumberField) && text.count > 9
    self.authButton.isEnabled = textField.isEqual(self.authCodeField) && !text.isEmpty
  }
}
