//
//  HomeFeedTableViewCell.swift
//  DaangnMarket
//
//  Created by Demian on 2020/03/25.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class HomeFeedTableViewCell: UITableViewCell {
  let goodsImage = UIImageView().then {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 5
    $0.kf.setImage(with: URL(string: "http://13.125.217.34/media/images/fabinho2.jpg"))
    $0.contentMode = .scaleToFill
  }
  let goodsName = UILabel().then {
//    $0.text = "소나무 원목"
    $0.font = .systemFont(ofSize: 16)
    $0.textAlignment = .center
  }
  let sellerLoctionAndTime = UILabel().then {
//    $0.text = "화양동" + " • " + "4분전"
    $0.font = .systemFont(ofSize: 12)
    $0.textAlignment = .center
    $0.textColor = .lightGray
  }
  let goodsPrice = UILabel().then {
    $0.text = "20,000원"
    $0.font = .systemFont(ofSize: 15)
    $0.textAlignment = .center
  }
  let favoriteMark = UIImageView().then {
    $0.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
    $0.image = UIImage(systemName: "heart")
    $0.tintColor = .lightGray
  }
  let favoriteCount = UILabel().then {
    $0.frame = CGRect(x: 0, y: 0, width: 0, height: 16)
    $0.text = "3"
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = .lightGray
    $0.textAlignment = .center
  }
  let separateBar = UIView().then {
    $0.backgroundColor = .lightGray
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    setupContentUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupContentUI() {
    setupConstraints()
  }
  private func setupConstraints() {
    let UIs = [goodsImage, goodsName, sellerLoctionAndTime, goodsPrice, favoriteMark, favoriteCount, separateBar]
    UIs.forEach { self.contentView.addSubview($0) }
    goodsImage.snp.makeConstraints {
      $0.centerY.equalTo(self.contentView.snp.centerY)
      $0.leading.equalTo(self.contentView.snp.leading).offset(16)
      $0.width.height.equalTo(104)
    }
    goodsName.snp.makeConstraints {
      $0.top.equalTo(goodsImage)
      $0.leading.equalTo(goodsImage.snp.trailing).offset(16)
    }
    sellerLoctionAndTime.snp.makeConstraints {
      $0.top.equalTo(goodsName.snp.bottom).offset(5)
      $0.leading.equalTo(goodsName)
    }
    goodsPrice.snp.makeConstraints {
      $0.top.equalTo(sellerLoctionAndTime.snp.bottom).offset(7)
      $0.leading.equalTo(goodsName)
    }
    favoriteMark.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-30)
      $0.bottom.equalToSuperview().offset(-18)
    }
    favoriteCount.snp.makeConstraints {
      $0.centerY.equalTo(favoriteMark.snp.centerY)
      $0.leading.equalTo(favoriteMark.snp.trailing)
    }
    separateBar.snp.makeConstraints {
      $0.leading.equalTo(self.contentView.snp.trailing).offset(16)
      $0.trailing.equalTo(self.contentView.snp.trailing).offset(-16)
      $0.bottom.equalToSuperview()
      $0.height.equalTo(0.3)
      $0.centerX.equalToSuperview()
    }
  }
}
