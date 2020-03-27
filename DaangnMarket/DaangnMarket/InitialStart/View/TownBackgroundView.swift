//
//  TownBackgroundView.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/27.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class TownBackgroundView: UIView {
  // MARK: Views
  
  private let noResultView = TownNoResultView()
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    self.noResultView
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.centerX.equalToSuperview()
        $0.centerY.equalToSuperview().offset(-52)
    }
  }
  
  // MARK: Interface
  
  func addTarget(_ target: Any?, action: Selector) {
    self.noResultView.addTarget(target, action: action)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
