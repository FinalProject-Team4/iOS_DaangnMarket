//
//  SalesListEmptyCollectionViewCell.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class SalesListEmptyCollectionViewCell: UICollectionViewCell {
  // MARK: View
  
  private let messageLabel = UILabel().then {
    $0.textColor = UIColor(named: ColorReference.inputText.rawValue)
    $0.textAlignment = .center
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    self.contentView.backgroundColor = UIColor(named: ColorReference.backGray.rawValue)
    setupConstraints()
  }
  
  private func setupConstraints() {
    self.messageLabel.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.centerX.centerY.equalToSuperview()
    }
  }
  
  // MARK: Interface
  
  func configure(message: String) {
    self.messageLabel.text = message
  }
}
