//
//  PopoverFirstTownButton.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/21.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class PopoverFirstTownButton: UIButton {
  // MARK: Views
  
  let townLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16)
//    $0.textColor = UIColor(named: ColorReference.noResultImage.rawValue)
  }
  let partitionLine = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.noResultImage.rawValue)
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  private func setupUI() {
    self.addSubview(townLabel)
    townLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(24)
    }
    self.addSubview(partitionLine)
    partitionLine.snp.makeConstraints {
      $0.height.equalTo(0.5)
      $0.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
