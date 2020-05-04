//
//  ChattingMessageView.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class MyMessageView: UIView {
  // MARK: Interface
  
  func configure(message: String, time: String) {
    let formatter = DateFormatter().then {
      $0.locale = .init(identifier: "ko_kr")
    }
    formatter.dateFormat = "hh:mm:ss"
    guard let date = formatter.date(from: time) else { return }
    formatter.dateFormat = "a hh:mm"
    
    self.timeLabel.text = formatter.string(from: date)
    self.messageLabel.text = message
  }
  
  func clear() {
    self.timeLabel.text = ""
    self.messageLabel.text = ""
  }
  
  // MARK: Views
  
  private let messageBackground = UIView().then {
    $0.layer.cornerRadius = 12
    $0.backgroundColor = UIColor(named: ColorReference.daangnMain.rawValue)
  }
  private let messageLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 15)
    $0.textColor = .white
    $0.numberOfLines = 0
    $0.text = "My"
  }
  private let timeLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13)
    $0.textColor = UIColor(named: ColorReference.item.rawValue)
  }
  
  // MARK: Life Cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }
  
  // MARK: Initialize
  
  private func setupConstraints() {
    self.messageBackground
      .then { self.addSubview($0) }
      .snp.makeConstraints { $0.top.trailing.bottom.equalToSuperview() }
    
    self.messageLabel
      .then { self.messageBackground.addSubview($0) }
      .snp.makeConstraints {
        $0.edges
          .equalToSuperview()
          .inset(UIEdgeInsets(top: 9, left: 12, bottom: 9, right: 12))
    }
    self.messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    
    self.timeLabel
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalToSuperview()
        $0.trailing
          .equalTo(self.messageBackground.snp.leading)
          .offset(-8)
        $0.bottom
          .equalTo(self.messageBackground)
          .offset(-1)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
