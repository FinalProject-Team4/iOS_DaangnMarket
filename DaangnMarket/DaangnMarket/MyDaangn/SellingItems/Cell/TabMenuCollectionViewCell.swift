//
//  TabMenuCollectionViewCell.swift
//  DaangnMarket
//
//  Created by Mac mini on 2020/04/11.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class TabMenuCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  
  static let identifier = "tabMenuCollectionCell"
  
  // MARK: View
  
  var tabMenuLabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    $0.textColor = UIColor(named: ColorReference.subText.rawValue)
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
    setupConstraints()
  }
  private func setupConstraints() {
    self.tabMenuLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.centerX.centerY.equalTo(self)
    }
  }
}
