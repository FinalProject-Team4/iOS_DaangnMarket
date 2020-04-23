//
//  ChattingDateCell.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ChattingDateIndicator: UIView {
  // MARK: Interaface
  
  func configure(date: String) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateType = formatter.date(from: date) ?? Date()
    formatter.dateFormat = "yyyy년 M월 d일"
    self.dateLabel.text = formatter.string(from: dateType)
  }
  
  // MARK: Views
  
  private let leftLine = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  private let rightLine = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  private let dateLabel = UILabel().then {
    $0.textColor = UIColor(named: ColorReference.borderLine.rawValue)
    $0.font = .systemFont(ofSize: 13)
  }
  
  // MARK: Life Cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }
  
  // MARK: Initialize
  
  private func setupConstraints() {
    self.dateLabel
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.bottom.equalToSuperview().inset(20)
        $0.centerX.equalToSuperview()
    }
    
    self.leftLine
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalToSuperview().offset(16)
        $0.trailing.equalTo(self.dateLabel.snp.leading).offset(-16)
        $0.centerY.equalTo(self.dateLabel)
        $0.height.equalTo(1)
    }
    
    self.rightLine
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(self.dateLabel.snp.trailing).offset(16)
        $0.trailing.equalToSuperview().offset(-16)
        $0.centerY.equalTo(self.dateLabel)
        $0.height.equalTo(1)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
