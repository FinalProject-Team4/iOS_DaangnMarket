//
//  SalesListContentView.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class SalesListContentView: UIView {
  // MARK: Views
  
  let itemImageView = UIImageView().then {
    $0.layer.cornerRadius = 5
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
  }
  let titleLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 16)
    $0.textColor = .black
  }
  let addrTimeLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 12)
    $0.textColor = UIColor(named: ColorReference.subText.rawValue)
  }
  let closeDealingLabel = UILabel().then {
    $0.textColor = .white
    $0.text = "거래완료   "
    $0.textAlignment = .center
    $0.font = UIFont.boldSystemFont(ofSize: 10)
    $0.backgroundColor = UIColor(named: ColorReference.auth.rawValue)
    $0.layer.cornerRadius = 4
    $0.clipsToBounds = true
  }
  let reservedLabel = UILabel().then {
    $0.textColor = .white
    $0.text = "예약중   "
    $0.textAlignment = .center
    $0.font = UIFont.boldSystemFont(ofSize: 10)
    $0.backgroundColor = UIColor(named: ColorReference.reservedMark.rawValue)
    $0.layer.cornerRadius = 4
    $0.clipsToBounds = true
    $0.isHidden = true
  }
  let priceLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 15)
    $0.textColor = .black
  }
  let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 5
  }
  
  // MARK: Property
  
  var postID = 0
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.stackView.addArrangedSubview(priceLabel)
    setupUI()
  }
 
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupConstraints()
  }
  
  private func setupConstraints() {
    let spacing: CGFloat = 16
    let imageSize: CGFloat = 92
    
    self.itemImageView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.equalToSuperview()
        $0.width.height.equalTo(imageSize)
        $0.bottom.equalToSuperview().offset(-spacing).priority(999)
    }
    self.titleLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(itemImageView)
        $0.leading.equalTo(itemImageView.snp.trailing).offset(spacing)
        $0.trailing.equalToSuperview()
    }
    self.addrTimeLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(titleLabel)
        $0.top.equalTo(titleLabel.snp.bottom).offset(10)
    }
    self.stackView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(addrTimeLabel)
        $0.top.equalTo(addrTimeLabel.snp.bottom).offset(10)
    }
  }
  
  func completedDeal(isCompleted: Bool) {
    if isCompleted {
      stackView.insertArrangedSubview(closeDealingLabel, at: 0)
    } else {
      stackView.removeArrangedSubview(closeDealingLabel)
    }
  }
  
  func reservedState(reserved: Bool) {
    if reserved {
      self.reservedLabel.isHidden = false
      stackView.insertArrangedSubview(reservedLabel, at: 0)
    } else {
      self.reservedLabel.isHidden = true
      stackView.removeArrangedSubview(reservedLabel)
    }
  }
}
