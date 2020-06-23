//
//  PageTableViewCell.swift
//  DaangnMarket
//
//  Created by Mac mini on 2020/04/11.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class PageTableViewCell: UITableViewCell {
  // MARK: Properties
  
  static let identifier = "pageTableCell"
  
  // MARK: Views
  
  private let backView = UIView().then {
    $0.backgroundColor = .white
  }
  
  private let itemImageView = UIImageView().then {
    $0.contentMode = .scaleToFill
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
  }
  private let titleLabel = UILabel().then {
    $0.textColor = .black
    $0.numberOfLines = 2
    $0.font = UIFont.boldSystemFont(ofSize: 16)
  }
  private let contentsLabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.numberOfLines = 0
  }
  private let closeDealingLabel = UILabel().then {
    $0.textColor = .white
    $0.text = "거래완료   "
    $0.textAlignment = .center
    $0.font = UIFont(name: "Helvetica", size: 10)
    $0.font = UIFont.boldSystemFont(ofSize: 10)
    $0.backgroundColor = UIColor(named: ColorReference.auth.rawValue)
    $0.layer.cornerRadius = 4
    $0.clipsToBounds = true
  }
  private let priceLabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont(name: "AppleSystemUIFont", size: 15)
    $0.font = UIFont.boldSystemFont(ofSize: 15)
  }
  private var stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .equalCentering
    $0.spacing = 5
  }
  private let addrTimeLabel = UILabel().then {
    $0.textColor = UIColor(named: ColorReference.navigationShadow.rawValue)
    $0.font = UIFont.systemFont(ofSize: 13)
  }
  
  private let chatLikeView = PageChatLikeView()
  
  
  // MARK: Initialize
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    self.backgroundColor = UIColor(named: ColorReference.backLightGray.rawValue)
    stackView.addArrangedSubview(priceLabel)
  }
  
  private func setupConstraints() {
    let spacing: CGFloat = 16
    let itemImageSize: CGFloat = 100
    
    self.backView.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.bottom.equalToSuperview().inset(5)
        $0.leading.trailing.equalToSuperview()
    }
    self.itemImageView.then { self.backView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.equalToSuperview().offset(spacing)
        $0.width.height.equalTo(itemImageSize)
    }
    self.addrTimeLabel.then { self.backView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(itemImageView.snp.bottom).offset(spacing / 2)
        $0.leading.equalTo(itemImageView)
        $0.bottom.equalToSuperview().offset(-spacing / 2)
    }
    self.stackView.then { self.backView.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(itemImageView.snp.trailing).offset(spacing)
        $0.bottom.equalTo(itemImageView.snp.bottom).offset(-spacing / 4)
    }

    self.titleLabel.then { self.backView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(itemImageView)
        $0.leading.equalTo(itemImageView.snp.trailing).offset(spacing)
    }
    self.contentsLabel.then { self.backView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo( titleLabel.snp.bottom).offset(spacing / 2)
        $0.leading.equalTo(titleLabel)
        $0.trailing.equalToSuperview().offset(-spacing)
        $0.bottom.equalTo(stackView.snp.top).offset(-spacing / 2)
    }
    self.chatLikeView.then { self.backView.addSubview($0) }
      .snp.makeConstraints {
        $0.trailing.equalToSuperview().offset(-spacing)
        $0.bottom.equalTo(addrTimeLabel)
    }
  }
  
  // MARK: Interface
  
  func configure(itemsData: Post) {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    
    titleLabel.text = itemsData.title
    contentsLabel.text = itemsData.content
    priceLabel.text = "\(numberFormatter.string(from: NSNumber(value: itemsData.price))!)원"
    addrTimeLabel.text = "\(PostData.shared.addressFilter(address: itemsData.address)) ・ \(PostData.shared.calculateDifferentTime(updated: itemsData.created))"
    if itemsData.photos.isEmpty {
      self.itemImageView.image = UIImage(named: "DaangnDefaultItem")
    } else {
      self.itemImageView.kf.setImage(with: URL(string: itemsData.photos[0]))
    }
    if itemsData.state == "end" {
      addCloseDealingLabel()
    } else {
      stackView.removeArrangedSubview(closeDealingLabel)
      closeDealingLabel.isHidden = true
    }
    
    self.chatLikeView.configure(chat: 0, like: itemsData.likes)
  }
  
  // MARK: Action
  
  private func addCloseDealingLabel() {
    stackView.insertArrangedSubview(closeDealingLabel, at: 0)
    closeDealingLabel.isHidden = false
  }
}
