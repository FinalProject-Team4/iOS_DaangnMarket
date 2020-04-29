//
//  ChatCell.swift
//  FirebaseChatSample
//
//  Created by cskim on 2020/04/20.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit

class ChattingCell: UITableViewCell {
  // MARK: Interaface
  
  func configure(message: String, date: String, time: String, profile: UIImage?, isMe: Bool, displayDateIndicator: Bool) {
    self.myMessage.isHidden = !isMe
    self.otherMessage.isHidden = isMe
    isMe ?
      self.myMessage.configure(message: message, time: time) :
      self.otherMessage.configure(message: message, time: time, profile: profile)
    
    self.dateIndicator.isHidden = !displayDateIndicator
    if displayDateIndicator {
      self.dateIndicator.configure(date: date)
      self.dateIndicator.snp.remakeConstraints {
        $0.top.leading.trailing.equalToSuperview()
      }
    }
  }
  
  // MARK: Views
  
  private let dateIndicator = ChattingDateIndicator()
  private let myMessage = MyMessageView()
  private let otherMessage = OtherMessageView()
  
  // MARK: Life Cycle
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setupUI()
    self.selectionStyle = .none
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.myMessage.do {
      $0.isHidden = true
      $0.clear()
    }
    self.otherMessage.do {
      $0.isHidden = true
      $0.clear()
    }
    self.dateIndicator.do {
      $0.isHidden = true
      $0.snp.remakeConstraints {
        $0.top.leading.trailing.equalToSuperview()
        $0.height.equalTo(0)
      }
    }
  }
  
  // MARK: Initialize
  
  private func setupUI() {
    self.dateIndicator
      .then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.trailing.equalToSuperview()
        $0.height.equalTo(0)
    }
    
    self.myMessage
      .then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self.dateIndicator.snp.bottom)
        $0.leading
          .greaterThanOrEqualToSuperview()
          .offset(40)
        $0.trailing.bottom
          .equalToSuperview()
          .inset(UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 16))
    }
    
    self.otherMessage
      .then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self.dateIndicator.snp.bottom)
        $0.leading.bottom
          .equalToSuperview()
          .inset(UIEdgeInsets(top: 0, left: 16, bottom: 6, right: 0))
        $0.trailing
          .lessThanOrEqualToSuperview()
          .offset(-30)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

