//
//  MyPageListButton.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class MyPageListButton: UIButton {
  // MARK: Views
  
  private let buttonImageView = UIImageView().then {
    $0.layer.cornerRadius = 30
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
  }
  private let buttonTitleLabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.systemFont(ofSize: 14)
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init(image: String, title: String) {
    self.init()
    self.buttonImageView.image = UIImage(named: image)
    self.buttonTitleLabel.text = title
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    let buttonSize: CGFloat = 60
    let spacing: CGFloat = 6
    
    self.buttonImageView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.width.height.equalTo(buttonSize)
        $0.top.leading.trailing.equalToSuperview()
    }
    self.buttonTitleLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(buttonImageView.snp.bottom).offset(spacing)
        $0.centerX.equalTo(buttonImageView)
        $0.bottom.equalToSuperview()
    }
  }
}
