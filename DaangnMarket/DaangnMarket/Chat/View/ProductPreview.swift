//
//  RelatedProductPreview.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ProductPreview: UIView {
  // MARK: Interface
  
  func configure(title: String, price: Int, thumbnail: UIImage?) {
    self.productTitleLabel.text = title

    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    self.productPriceLabel.text = formatter.string(from: NSNumber(value: price)) ?? "-" + "원"
    
    self.thumbnailImageView.image = thumbnail
  }
  
  // MARK: Views
  
  private let thumbnailImageView = UIImageView().then {
    $0.layer.cornerRadius = 2
  }
  private let productTitleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 15)
  }
  private let productPriceLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14)
  }
  private let underline = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  
  // MARK: Life Cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }
  
  // MARK: Initialize
  
  private func setupConstraints() {
    self.thumbnailImageView
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.bottom.equalToSuperview().inset(16)
        $0.size.equalTo(48)
    }
    
    self.productTitleLabel
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self.thumbnailImageView).offset(2)
        $0.leading.equalTo(self.thumbnailImageView.snp.trailing).offset(16)
    }
    
    self.productPriceLabel
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(self.thumbnailImageView.snp.trailing).offset(16)
        $0.bottom.equalTo(self.thumbnailImageView).offset(-2)
    }
    
    self.underline
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.trailing.bottom.equalToSuperview()
        $0.height.equalTo(1)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
