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
  private let mannerTempLabel = UILabel().then {
    $0.textColor = UIColor(named: ColorReference.mannerTemperature.rawValue)
    $0.font = UIFont(name: "Arial", size: 16)
    $0.font = UIFont.boldSystemFont(ofSize: 16)
  }
  private let mannerStatusBackView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
    $0.layer.cornerRadius = 3
  }
  private let mannerStatusView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.mannerTemperature.rawValue)
    $0.layer.cornerRadius = 3
  }
  private let mannerFaceImageView = UIImageView().then {
    $0.layer.cornerRadius = 12
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
  }
  private let mannerTitleLabel = UILabel().then {
    $0.text = "매너온도"
    $0.textColor = .gray
    $0.font = UIFont.systemFont(ofSize: 12)
  }
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
  
  func configure(image: UIImage?, sellerId: String, addr: String) {
    sellerImageView.image = image
    idLabel.text = sellerId
    addrLabel.text = addr
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    mannerTempLabel.text = "\(String(mannerTemp))º"
    mannerFaceImageView.image = UIImage(named: "mannerFace")
  }
  
  private func setupConstraints() {
    let spacing: CGFloat = 16
    let sellerImageSize: CGFloat = 36
    let mannerFaceSize: CGFloat = 24
    let mannerStatusBarHeight: CGFloat = 5
    
    self.sellerImageView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.equalTo(self).inset(spacing)
        $0.width.height.equalTo(sellerImageSize)
    }
    self.idLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(sellerImageView)
        $0.leading.equalTo(sellerImageView.snp.trailing).offset(spacing / 2)
    }
    self.addrLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(idLabel)
        $0.bottom.equalTo(sellerImageView)
    }
    self.mannerFaceImageView.then { self.addSubview($0) }
      .snp.makeConstraints {
        //$0.top.equalTo(sellerImageView)
        $0.top.trailing.equalTo(self).inset(spacing)
        $0.width.height.equalTo(mannerFaceSize)
    }
    self.mannerTempLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self).offset(spacing / 1.5)
        $0.trailing.equalTo(mannerFaceImageView.snp.leading).offset(-spacing)
    }
    self.mannerStatusBackView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(mannerTempLabel)
        $0.bottom.equalTo(mannerFaceImageView)
        $0.height.equalTo(mannerStatusBarHeight)
        $0.trailing.equalTo(mannerFaceImageView.snp.leading).offset(-spacing / 2)
    }
    self.mannerStatusView.then { mannerStatusBackView.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.height.equalTo(mannerStatusBackView)
        $0.width.equalTo(mannerStatusBackView).multipliedBy(CGFloat(mannerTemp / 100))
    }
    self.mannerTitleLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.trailing.equalTo(mannerFaceImageView)
        $0.centerY.equalTo(sellerImageView.snp.bottom)
        $0.bottom.equalTo(self).inset(spacing / 2)
    }
    self.bottomLineView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.height.equalTo(0.5)
        $0.width.equalTo(self).offset(-spacing * 2)
        $0.centerX.equalTo(self)
        $0.bottom.equalTo(self)
    }
  }
}
