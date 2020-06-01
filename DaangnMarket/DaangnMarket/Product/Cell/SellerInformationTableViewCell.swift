//
//  SellerInformationTableViewCell.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/03.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class SellerInformationTableViewCell: UITableViewCell {
  static let identifier = "SellerInformTableCell"
  // MARK: Views
  
  private let sellerImageView = UIImageView().then {
    $0.layer.cornerRadius = 18
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
  }
  private let idLabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
  }
  private let addrLabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.systemFont(ofSize: 13)
  }
  
  private let mannerTempView = MannerTemperatureView()
  
  private let bottomLineView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  
  // MARK: Properties
  
  private let mannerTemp = 36.5
  
  // MARK: Initialize
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    let sellerImageSize: CGFloat = 36
    
    self.sellerImageView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.equalTo(self).inset(spacing)
        $0.width.height.equalTo(sellerImageSize)
        $0.bottom.equalTo(self).offset(-spacing)
    }
    self.idLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(sellerImageView)
        $0.leading.equalTo(sellerImageView.snp.trailing).offset(spacing / 2)
    }
    self.mannerTempView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.trailing.equalTo(self)
    }
    self.addrLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(idLabel)
        $0.bottom.equalTo(sellerImageView)
    }
    
    self.bottomLineView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.height.equalTo(0.3)
        $0.width.equalTo(self).offset(-spacing * 2)
        $0.centerX.equalTo(self)
        $0.bottom.equalTo(self)
    }
  }
  
  
  // MARK: Interface
  
  func configure(image: UIImage?, sellerId: String, addr: String) {
    sellerImageView.image = image
    idLabel.text = sellerId
    addrLabel.text = PostData.shared.addressFilter(address: addr)
  }
}
