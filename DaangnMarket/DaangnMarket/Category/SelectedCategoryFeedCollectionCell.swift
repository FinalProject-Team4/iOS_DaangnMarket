//
//  SelectedCategoryFeedCollectionCell.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/09.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class SelectedCategoryFeedCollectionCell: UICollectionViewCell {
  static let cellID = "SelectedCategoryFeedCollectionCell"
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupImageView(image: URL?) {
    let imageView = UIImageView().then {
      $0.image = UIImage(named: "image1")
      $0.contentMode = .scaleAspectFill
      $0.layer.cornerRadius = 8
      $0.clipsToBounds = true
      contentView.addSubview($0)
    }
    imageView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(imageView.snp.width)
    }
  }
  
  private func setupTilteLabel(text: String) {
    let titleLabel = UILabel().then {
      $0.text = text
      $0.font = .systemFont(ofSize: 14, weight: .bold)
      contentView.addSubview($0)
    }
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(180)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  private func setupTownLabel(text: String) {
    let townLabel = UILabel().then {
      $0.text = text
      $0.font = .systemFont(ofSize: 13)
      contentView.addSubview($0)
    }
    townLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-32)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  private func setupPriceLabel(text: Int) {
    let priceLabel = UILabel().then {
      $0.text = "\(text)"
      $0.font = .systemFont(ofSize: 15, weight: .bold)
      contentView.addSubview($0)
    }
    priceLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  // MARK: - Interface
  func inputData(image: URL?, title: String, town: String, price: Int) {
//    if let image = image {
//      setupImageView(image: image)
//    }
    setupImageView(image: nil)
    setupTilteLabel(text: title)
    setupTownLabel(text: town)
    setupPriceLabel(text: price)
  }
}
