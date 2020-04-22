//
//  BackView.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class BackView: UIView {
  var topLine = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  
  var bottomLine = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }

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
    let viewWidth = UIScreen.main.bounds.width
    self.topLine.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.height.equalTo(0.5)
        $0.width.equalTo(viewWidth)
        $0.top.leading.equalToSuperview()
    }
    
    self.bottomLine.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.height.equalTo(0.5)
        $0.width.equalTo(viewWidth)
        $0.bottom.leading.equalToSuperview()
    }
  }
}
