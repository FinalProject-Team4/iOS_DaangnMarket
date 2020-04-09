//
//  CategoryItemView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/08.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class CategoryItemView: UIControl {
  // MARK: Views
  
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
  }
  
  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16)
  }
  
  // MARK: Properties
  var identifier: String?
  
  // MARK: Initialize
  
  init(headerText: String) {
    super.init(frame: .zero)
    titleLabel.text = headerText
    titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
    setTitleLabel()
  }
  
  init(image: UIImage, text: String) {
    super.init(frame: .zero)
    identifier = text
    imageView.image = image
    titleLabel.text = text
    setImageAndLabel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setImageAndLabel() {
    self.addSubview(imageView)
    self.addSubview(titleLabel)
    
    imageView.snp.makeConstraints {
      $0.leading.top.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-16)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(20)
    }
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(imageView.snp.trailing).offset(16)
      $0.top.bottom.equalTo(imageView)
    }
  }
  
  private func setTitleLabel() {
    self.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-16)
    }
  }
}
