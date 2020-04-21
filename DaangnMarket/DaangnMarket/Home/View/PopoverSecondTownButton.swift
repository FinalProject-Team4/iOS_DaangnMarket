//
//  PopoverSecondTownButton.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/21.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class PopoverSecondTownButton: UIButton {
  // MARK: Views
  
  let townLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16)
    $0.textColor = UIColor(named: ColorReference.noResultImage.rawValue)
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  private func setupUI() {
    self.addSubview(townLabel)
    townLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(24)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
