//
//  MyPageUserInformTableViewCell.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol MyPageUserInformDelegate: class {
  func goToPage(tag: String)
}

class MyPageUserInformTableViewCell: UITableViewCell {
  weak var delegate: MyPageUserInformDelegate?
  
  // MARK: Views
  
//  private let profileImageButton = MyProfileImageView()
  private let profileImageButton = MyProfileImageButton()
  private let userNameLabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.boldSystemFont(ofSize: 19)
  }
  private let addressLabel = UILabel().then {
    $0.textColor = UIColor(named: ColorReference.subText.rawValue)
    $0.font = UIFont.boldSystemFont(ofSize: 13)
  }
  private let nameAddrStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 5
  }
  private let showProfileButton = UIButton().then {
    $0.setTitle("프로필 보기", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.layer.borderColor = UIColor(named: ColorReference.borderLine.rawValue)?.cgColor
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = 5
    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
  }
  
  // MARK: Initialize
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    userNameLabel.text = "라이언"
    addressLabel.text = "흥인동"
    nameAddrStackView.addArrangedSubview(userNameLabel)
    nameAddrStackView.addArrangedSubview(addressLabel)
    [profileImageButton, showProfileButton].forEach {
      $0.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
  }
  
  private func setupConstraints() {
    let varSpacing: CGFloat = 16
    let horSpacing: CGFloat = 24
    
    self.profileImageButton.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalToSuperview().offset(horSpacing)
        $0.leading.equalToSuperview().offset(varSpacing)
        $0.bottom.equalToSuperview().offset(-horSpacing).priority(999)
    }
    self.nameAddrStackView.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(profileImageButton.snp.trailing).offset(varSpacing)
        $0.centerY.equalTo(profileImageButton)
    }
    self.showProfileButton.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.trailing.equalToSuperview().offset(-varSpacing)
        $0.centerY.equalTo(profileImageButton)
        $0.width.equalTo(100)
        $0.height.equalTo(44)
    }
  }
  
  @objc func didTapButton(_ sender: UIButton) {
    switch sender {
    case profileImageButton:
      print("profile사진 수정 페이지 띄우기")
    case showProfileButton:
//      sender.currentAttributedTitle
      delegate?.goToPage(tag: "showProfileButton")
      print("프로필보기 click!")
    default:
      print("default")
    }
  }
}
