//
//  ConfigProfileViewController.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/05.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ConfigProfileViewController: UIViewController {
  // MARK: Views
  
  private lazy var profileImageView = ProfileImageView().then {
    $0.addTarget(self, action: #selector(didTapSelectButton(_:)))
  }
  private lazy var nicknameTextField = UITextField().then {
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor(named: ColorReference.borderLine.rawValue)?.cgColor
    $0.layer.cornerRadius = 4
    $0.keyboardType = .default
    $0.font = .systemFont(ofSize: 17)
    $0.placeholder = "닉네임을 입력하세요."
    $0.textAlignment = .center
    $0.delegate = self
  }
  private lazy var labelContainer = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 16
    $0.alignment = .center
    $0.distribution = .fillProportionally
    $0.addArrangedSubview(self.descriptionLabel)
  }
  private let warningLabel = UILabel().then {
    $0.textColor = .red
    $0.font = .systemFont(ofSize: 17, weight: .bold)
  }
  private let descriptionLabel = UILabel().then {
    $0.textColor = UIColor(named: ColorReference.item.rawValue)
    $0.font = .systemFont(ofSize: 13)
    $0.text = "프로필 사진과 닉네임을 입력해주세요."
  }
  private let activityIndicator = DGActivityIndicator()
  
  // MARK: Properties
  
  private var profileImage: UIImage?
  private var username: String?
  private var idToken: String
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
  }
  
  // MARK: Initialize
  
  init(idToken: String) {
    self.idToken = idToken
    super.init(nibName: nil, bundle: nil)
  }
  
  private func setupUI() {
    self.setupAttributes()
    self.setupConstraints()
  }
  
  private func setupAttributes() {
    self.view.backgroundColor = .white
    self.navigationItem.title = "프로필 설정"
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "완료",
      style: .done,
      target: self,
      action: #selector(didTapDoneButton(_:))
    ).then { $0.tintColor = .black }
  }
  
  private func setupConstraints() {
    let paddingY: CGFloat = 44
    let paddingX: CGFloat = 16
    let spacing: CGFloat = 8
    let height: CGFloat = 44
    
    self.profileImageView
      .then { self.view.addSubview($0) }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.view.safeAreaLayoutGuide)
          .offset(paddingY)
        $0.centerX.equalToSuperview()
    }
    
    self.nicknameTextField
      .then { self.view.addSubview($0) }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.profileImageView.snp.bottom)
          .offset(spacing * 3)
        $0.leading.trailing
          .equalTo(self.view.safeAreaLayoutGuide)
          .inset(UIEdgeInsets(top: 0, left: paddingX, bottom: 0, right: paddingX))
        $0.height.equalTo(height)
    }
    
    self.labelContainer
      .then { self.view.addSubview($0) }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.nicknameTextField.snp.bottom)
          .offset(14)
        $0.centerX.equalToSuperview()
    }
    
    self.activityIndicator
      .then { self.view.addSubview($0) }
      .snp.makeConstraints {
        $0.center.equalToSuperview()
    }
  }
  
  // MARK: Actions
  
  @objc private func didTapDoneButton(_ sender: UIBarButtonItem) {
    guard let username = self.username else { return }
    let imageData = self.profileImage?.jpegData(compressionQuality: 0.2)
    
    self.activityIndicator.startAnimating()
    API.default.request(.signUp(idToken: self.idToken, username: username, avatar: imageData)) { (result) in
      switch result {
      case .success(let userInfo):
        print("=================== User Info ====================\n", userInfo)
        
        // 선택된 동네의 주변 동네 리스트 가져오기
        // SignUp할 때는 선택할 수 있는 동네가 1개로 제한됨
        guard var selected = AuthorizationManager.shared.firstTown else { return }
        selected.user = userInfo.username
        API.default.requestRegisterUserTown(userTown: selected, authToken: userInfo.authorization) { (result) in
          defer { self.activityIndicator.stopAnimating() }
          switch result {
          case .success(let userTown):
            // GCM Token 등록하기
            if let fcmToken = AuthorizationManager.shared.fcmToken {
              API.default.requestPushKeyRegister(authToken: userInfo.authorization, fcmToken: fcmToken) { (result) in
                switch result {
                case .success(_):
                  AuthorizationManager.shared.firstTown = userTown
                  self.navigationController?
                    .presentingViewController?
                    .presentingViewController?
                    .dismiss(animated: true)
                case .failure(let error):
                  self.presentAlert(title: "Register FCM Token Error", message: error.localizedDescription)
                }
              }
            } else {
              self.presentAlert(title: "No FCM Token Error")
            }
          case .failure(let error):
            self.presentAlert(title: "Register User Town Error", message: error.localizedDescription)
          }
        }
      case .failure(let error):
        self.activityIndicator.stopAnimating()
        self.presentAlert(title: "Sign Up Error", message: error.localizedDescription)
      }
    }
  }
  
  @objc private func didTapSelectButton(_ sender: UIButton) {
    let albumAction = UIAlertAction(title: "앨범에서 선택", style: .default, handler: nil)
    let deleteAction = UIAlertAction(title: "프로필 사진 삭제", style: .destructive, handler: nil)
    self.presentActionSheet(
      actions: [
        albumAction,
        deleteAction,
        UIAlertAction(title: "닫기", style: .cancel)
      ]
    )
  }
  
  // MARK: Useless
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UITextFieldDelegate

extension ConfigProfileViewController: UITextFieldDelegate {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    guard let text = textField.text else { return }
    
    self.username = text.isEmpty ? nil : text
    self.warningLabel.do {
      if text.isEmpty, self.labelContainer.subviews.contains($0) {
        self.labelContainer.removeArrangedSubview($0)
        $0.removeFromSuperview()
      } else if text.count < 2 {
        $0.text = "닉네임은 최소 2자 입니당."
        self.labelContainer.insertArrangedSubview($0, at: 0)
      } else if !self.checkValidNickname(text) {
        $0.text = "한글,영문,숫자만 입력해주세요."
        if !self.labelContainer.subviews.contains($0) {
          self.labelContainer.insertArrangedSubview($0, at: 0)
        }
      } else if self.labelContainer.subviews.contains($0) {
        self.labelContainer.removeArrangedSubview($0)
        $0.removeFromSuperview()
      }
    }
  }
  
  private func checkValidNickname(_ nickname: String) -> Bool {
    let regex = "^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9]*$"
    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: nickname)
  }
}
