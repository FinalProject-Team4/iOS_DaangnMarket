//
//  ChattingCell.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/18.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ChattingHistoryCell: UITableViewCell {
  // MARK: Interface
  
  func configure(chatInfo chat: ChatInfo) {
    // Config Profile
    self.profileView.profileImage = UIImage(named: chat.profileImage ?? "")
    self.profileView.badgeImage = chat.username.contains("당근이") ? UIImage(named: ImageReference.badge.rawValue) : nil
    self.usernameLabel.text = chat.username
    
    // Config Content
    self.chatInfoLabel.text = chat.address + " ・ " + chat.updated
    self.previewLabel.text = chat.content
    
    if let thumbnail = chat.productImage {
      self.thumbnailImageView.image = UIImage(named: thumbnail)
      self.thumbnailImageView.snp.updateConstraints {
        $0.leading
          .equalTo(self.badgeLabel.snp.trailing)
          .offset(10)
        $0.width.equalTo(40)
      }
    }
    
    // Config ChatInfo
    if chat.badge > 0 {
      self.badgeLabel.text = chat.badge.description
      self.badgeLabel.snp.updateConstraints {
        $0.leading
          .equalTo(self.chatInfoLabel.snp.trailing)   // offset 8
          .offset(8)
        $0.width.equalTo(30)
      }
    }
    self.bookmarkView.isHidden = !chat.isBookmarked
  }
  
  // MARK: Views
  
  private let profileView = ProfileThumbnailView().then {
    $0.profileImage = UIImage(named: ImageReference.daangni.rawValue)
    $0.badgeImage = UIImage(named: ImageReference.badge.rawValue)
  }
  private let usernameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 15, weight: .bold)
  }
  private let previewLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 15)
  }
  private let chatInfoLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13)
    $0.textColor = UIColor(named: ColorReference.item.rawValue)
  }
  private let badgeLabel = UILabel().then {
    $0.layer.cornerRadius = 12
    $0.clipsToBounds = true
    $0.backgroundColor = UIColor(named: ColorReference.daangnMain.rawValue)
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 13, weight: .bold)
    $0.textAlignment = .center
  }
  private let thumbnailImageView = UIImageView().then {
    $0.layer.cornerRadius = 2
    $0.clipsToBounds = true
    $0.backgroundColor = .brown
  }
  private let bookmarkView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.daangnMain.rawValue)
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
    let thumbnailSize: CGFloat = 40
    
    self.setupProfileConstraint(padding: padding, profileSize: profileSize)
    self.setupChatConstraint(padding: padding, thumbnailSize: thumbnailSize)
    self.setupBookmarkConstraint()
  }
  
  private func setupProfileConstraint(padding: (x: CGFloat, y: CGFloat), profileSize: CGFloat) {
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
  }
  
  private func setupChatConstraint(padding: (x: CGFloat, y: CGFloat), thumbnailSize: CGFloat) {
    self.chatInfoLabel
      .then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.centerY.equalTo(self.usernameLabel)
        $0.leading
          .equalTo(self.usernameLabel.snp.trailing)
          .offset(8)
    }
    self.chatInfoLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    
    self.badgeLabel
      .then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self.usernameLabel)
        $0.leading.equalTo(self.chatInfoLabel.snp.trailing)   // offset 8
        $0.size.equalTo(CGSize(width: 0, height: 24))
    }
    
    self.thumbnailImageView
      .then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.centerY.equalTo(self.badgeLabel.snp.bottom)
        $0.leading.equalTo(self.badgeLabel.snp.trailing)      // offset 10
        $0.trailing
          .equalToSuperview()
          .offset(-padding.x)
        $0.size.equalTo(CGSize(width: 0, height: thumbnailSize))
    }
    
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
  
  private func setupBookmarkConstraint() {
    self.bookmarkView
      .then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.width.equalTo(8)
        $0.top.leading.bottom.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
