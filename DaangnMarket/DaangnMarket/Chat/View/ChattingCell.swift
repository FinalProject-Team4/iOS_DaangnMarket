//
//  ChattingCell.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/18.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ChattingCell: UITableViewCell {
  // MARK: Views
  
  private let profileView = ProfileView().then {
    $0.profileImage = UIImage(named: ImageReference.daangni.rawValue)
    $0.badgeImage = UIImage(named: ImageReference.badge.rawValue)
  }
  private let usernameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 15, weight: .bold)
    $0.text = "당근이"
  }
  private let previewLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 15)
    $0.text = "비움을 실천하고 계신 cskim님, 정말 멋져요! 따뜻함이 배가 되는 당근마켓의 거래매너를 확인해보세요:)"
  }
  private let chatInfoLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13)
    $0.textColor = UIColor(named: ColorReference.item.rawValue)
    $0.text = "서울특별시 강남구 ・ Last week"
  }
  
  // MARK: Initialize
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setupAttributes()
    self.setupConstraints()
  }
  
  private func setupAttributes() {
    self.selectionStyle = .none
  }
  
  private func setupConstraints() {
    let padding: (x: CGFloat, y: CGFloat) = (16, 16)
    let profileSize: CGFloat = 52
    
    self.profileView
      .then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.bottom
          .equalToSuperview()
          .inset(UIEdgeInsets(top: padding.y, left: padding.x, bottom: padding.y, right: 0))
        $0.size.equalTo(profileSize)
    }
    
    self.usernameLabel
      .then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self.profileView)
        $0.leading
          .equalTo(self.profileView.snp.trailing)
          .offset(12)
    }
    self.usernameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    
    self.chatInfoLabel
      .then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.centerY.equalTo(self.usernameLabel)
        $0.leading
          .equalTo(self.usernameLabel.snp.trailing)
          .offset(8)
        $0.trailing
          .equalToSuperview()
          .offset(-padding.x)
    }
    self.chatInfoLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    
    self.previewLabel
      .then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.usernameLabel.snp.bottom)
          .offset(16)
        $0.leading.equalTo(self.usernameLabel)
        $0.trailing.equalTo(self.chatInfoLabel)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
