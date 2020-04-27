//
//  WriteTypeButtonView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class WriteTypeButtonView: UIView {
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.tintColor = .black
  }
  
  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 16, weight: .bold)
  }
  
  private let subTitleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12)
    $0.textColor = UIColor(named: ColorReference.subText.rawValue)
  }
  
  init(image: UIImage, title: String, subTitle: String) {
    super.init(frame: .zero)
    imageView.image = image
    titleLabel.text = title
    subTitleLabel.text = subTitle
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    self.backgroundColor = .white
    [imageView, titleLabel, subTitleLabel].forEach {
      self.addSubview($0)
    }
  }
  
  private func setupConstraints() {
    imageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(24)
      $0.width.equalToSuperview().multipliedBy(0.1)
      $0.height.equalTo(imageView.snp.width)
    }
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.top)
      $0.leading.equalTo(imageView.snp.trailing).offset(12)
    }
    subTitleLabel.snp.makeConstraints {
      $0.bottom.equalTo(imageView.snp.bottom)
      $0.leading.equalTo(imageView.snp.trailing).offset(12)
    }
  }
}
