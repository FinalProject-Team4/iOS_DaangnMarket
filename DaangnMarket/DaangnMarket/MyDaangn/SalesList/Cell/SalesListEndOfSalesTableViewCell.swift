//
//  SalesListEndOfSalesTableViewCell.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol SalesListEndOfSalesTVCDelegate: class {
  func endOfSalesOption(postID: Int)
}

class SalesListEndOfSalesTableViewCell: UITableViewCell {
  weak var delegate: SalesListEndOfSalesTVCDelegate?
  private let numberFormatter = NumberFormatter()
  
  // MARK: Views
  
  private let backView = UIView().then {
    $0.backgroundColor = .white
  }
  let itemContentView = SalesListContentView()
  private let optionButton = UIButton().then {
    $0.setImage(UIImage(named: "menu"), for: .normal)
  }
  private let verLine = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  private var sendReviewButton = UIButton().then {
    $0.setTitle("거래 후기 보내기", for: .normal)
    $0.setTitleColor(UIColor(named: ColorReference.daangnMain.rawValue), for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 13)
  }
  
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
    self.backgroundColor = UIColor(named: ColorReference.backGray.rawValue)
    self.optionButton.addTarget(self, action: #selector(didTapOptionButton(_:)), for: .touchUpInside)
  }
  
  private func setupConstraints() {
    let spacing: CGFloat = 16
    let optionButtonSize: CGFloat = 20
    let bottomButtonHeight: CGFloat = 40
    let viewWidth = UIScreen.main.bounds.width
    
    self.backView.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.bottom.equalToSuperview().offset(-8)
        $0.top.leading.trailing.equalToSuperview()
    }
    self.optionButton.then { self.backView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.trailing.equalToSuperview().inset(spacing)
        $0.width.height.equalTo(optionButtonSize)
    }
    self.itemContentView.then { self.backView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.equalToSuperview().offset(spacing)
        $0.trailing.equalTo(optionButton).offset(-spacing)
    }
    self.verLine.then { self.backView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(itemContentView.snp.bottom)
        $0.leading.equalToSuperview()
        $0.width.equalTo(viewWidth)
        $0.height.equalTo(0.5)
    }
    self.sendReviewButton.then { self.backView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(verLine.snp.bottom)
        $0.leading.equalToSuperview()
        $0.width.equalTo(viewWidth)
        $0.height.equalTo(bottomButtonHeight)
        $0.bottom.equalToSuperview()
    }
  }
  
  // MARK: Action
  
  @objc func didTapOptionButton(_ sender: UIButton) {
    delegate?.endOfSalesOption(postID: self.itemContentView.postID)
    print("tvc:", itemContentView.postID)
  }
  
  // MARK: Interface
  
  func configure(endOfSale: Post) {
    if endOfSale.photos.isEmpty {
      self.itemContentView.itemImageView.image = UIImage(named: "DaangnDefaultItem")
    } else {
      self.itemContentView.itemImageView.kf.setImage(with: URL(string: endOfSale.photos[0]))
    }
    self.itemContentView.titleLabel.text = endOfSale.title
    self.itemContentView.addrTimeLabel.text = "\(PostData.shared.addressFilter(address: endOfSale.address)) ･ \(PostData.shared.calculateDifferentTime(updated: endOfSale.created))"
    self.numberFormatter.numberStyle = .decimal
    self.itemContentView.priceLabel.text = "\(numberFormatter.string(from: NSNumber(value: endOfSale.price))!)원"
    self.itemContentView.postID = endOfSale.postId
  }
}
