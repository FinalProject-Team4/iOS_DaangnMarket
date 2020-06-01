//
//  OtherItesmCollectionViewCell.swift
//  DaangnMarket
//
//  Created by Mac mini on 2020/04/05.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class OtherItemsCollectionViewCell: UICollectionViewCell {
  static let identifier = "OtherItemsCollectionCell"
  
  // MARK: Views
  
  private let imageView = UIImageView().then {
    $0.layer.cornerRadius = 4
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  private let titleLabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.systemFont(ofSize: 13)
  }
  private let priceLabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.boldSystemFont(ofSize: 12)
  }
  
  // MARK: Properties
  
  private let viewWidth = UIScreen.main.bounds.width
  let numberFormatter = NumberFormatter()
  
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
    let spacing: CGFloat = 10
    
    self.priceLabel.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.bottom.leading.trailing.equalToSuperview()
        $0.width.equalTo(contentView)
    }
    self.titleLabel.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.bottom.equalTo(priceLabel.snp.top).offset(-spacing)
        $0.leading.equalTo(priceLabel)
        $0.trailing.equalToSuperview()
    }
    self.imageView.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.bottom.equalTo(titleLabel.snp.top).offset(-spacing)
        $0.top.leading.trailing.equalToSuperview()
    }
  }
  
  // MARK: Interface
  
  func configure(otherItemData: Post) {
    if otherItemData.photos.isEmpty {
      imageView.image = UIImage(named: "DaangnDefaultItem")
    } else {
      imageView.kf.setImage(with: URL(string: otherItemData.photos[0]))
    }
    self.titleLabel.text = otherItemData.title
    self.numberFormatter.numberStyle = .decimal
    self.priceLabel.text = "\(numberFormatter.string(from: NSNumber(value: otherItemData.price))!)원"
  }
}
