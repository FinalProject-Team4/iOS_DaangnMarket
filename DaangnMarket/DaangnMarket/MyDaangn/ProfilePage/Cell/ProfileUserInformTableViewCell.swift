//
//  ProfileUserInformTableViewCell.swift
//  DaangnMarket
//
//  Created by Mac mini on 2020/04/11.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ProfileUserInformTableViewCell: UITableViewCell {
  // MARK: Properties
  
  static let identifier = "ProfileUserInformTableCell"
  private let userMannerTemp = 47.2
  private let viewWidth = UIScreen.main.bounds.width
  var isSamePerson = Bool()
  
  // MARK: Views
  private var nameImageView = UserProfileImageNameView()
  private let mannerTemperView = UserProfileMannerTemperView()
  private let percentageView = UserProfilePercentageView()
  
  // MARK: Initialize
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupConstraints()
  }
  
  private func setupConstraints() {
    self.nameImageView.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.trailing.equalToSuperview()
    }
    self.mannerTemperView.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(nameImageView.snp.bottom)
        $0.leading.trailing.equalToSuperview()
    }
    self.percentageView.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(mannerTemperView.snp.bottom)
        $0.leading.trailing.equalToSuperview()
        $0.bottom.equalToSuperview()
    }
  }
  
  // MARK: Interface
  
  func configure(isMyProfile: Bool, name: String) {
    nameImageView.configure(isItMyProfile: isMyProfile, profileName: name)
  }
}

