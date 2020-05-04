//
//  SalesListOnSaleTableViewCell.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol SalesListOnSaleTVCDelegate: class {
  func onSaleOption()
  func stateChange(postID: Int, state: String)
  func changeToEndOfSales(postID: Int, title: String)
}

class SalesListOnSaleTableViewCell: UITableViewCell {
  weak var delegate: SalesListOnSaleTVCDelegate?
  
  // MARK: Views
  
  private let backView = UIView().then {
    $0.backgroundColor = .white
  }
  private let itemContentView = SalesListContentView()
  private let optionButton = UIButton().then {
    $0.setImage(UIImage(named: "menu"), for: .normal)
  }
  private let verLine = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  private var stateButton = UIButton().then {
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 13)
  }
  private let endOfSalesButton = UIButton().then {
    $0.setTitle("거래완료", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 13)
  }
  private let horLine = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  
  // MARK: Properties
  
  let spacing: CGFloat = 16
  let optionButtonSize: CGFloat = 20
  let bottomButtonHeight: CGFloat = 40
  let viewWidth = UIScreen.main.bounds.width
  let numberFormatter = NumberFormatter()
  
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
    self.optionButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    self.stateButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    self.endOfSalesButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
  }
  
  private func setupConstraints() {
    let bottomButtonWidth: CGFloat = viewWidth / 2
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
    self.stateButton.then { self.backView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(verLine.snp.bottom)
        $0.leading.equalToSuperview()
        $0.width.equalTo(bottomButtonWidth)
        $0.height.equalTo(bottomButtonHeight)
    }
    self.endOfSalesButton.then { self.backView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(verLine.snp.bottom)
        $0.trailing.equalToSuperview()
        $0.width.equalTo(bottomButtonWidth)
        $0.height.equalTo(bottomButtonHeight)
    }
    self.horLine.then { self.backView.addSubview($0) }
      .snp.makeConstraints {
        $0.height.equalTo(23)
        $0.width.equalTo(0.5)
        $0.centerX.equalToSuperview()
        $0.centerY.equalTo(stateButton)
        $0.bottom.equalToSuperview().offset(-10)
    }
  }
  
  // MARK: Interface
  
  func configure(onSale: Post) {
    if onSale.photos.isEmpty {
      self.itemContentView.itemImageView.image = UIImage(named: "DaangnDefaultItem")
    } else {
      self.itemContentView.itemImageView.kf.setImage(with: URL(string: onSale.photos[0]))
    }
    self.itemContentView.titleLabel.text = onSale.title
    self.itemContentView.addrTimeLabel.text = "\(PostData.shared.addressFilter(address: onSale.address)) ･ \(PostData.shared.calculateDifferentTime(updated: onSale.created))"
    self.numberFormatter.numberStyle = .decimal
    self.itemContentView.priceLabel.text = "\(numberFormatter.string(from: NSNumber(value: onSale.price))!)원"
    self.itemContentView.postID = onSale.postId
    
    if onSale.state == "reserve" {
      self.stateButton.setTitle("판매중으로 변경", for: .normal)
      self.itemContentView.reservedState(reserved: true)
    } else if onSale.state == "sales" {
      self.stateButton.setTitle("예약중으로 변경", for: .normal)
      self.itemContentView.reservedState(reserved: false)
    }
  }
  
  // MARK: Action
  
  @objc func didTapButton(_ sender: UIButton) {
    switch sender {
    case optionButton:
      delegate?.onSaleOption()
      
    case stateButton:
      // 여기서 처리하지 말고, viewController에서 처리하고 재정렬된 값으로 reloadData하기!
      // -> 이러면 상태값을 여기서 각각 바꿔 줄 필요가 없어! 그냥 state만 바꿔주고 reload만 하면 됨!
      let nowState = stateButton.titleLabel?.text == "예약중으로 변경" ? "reserve" : "sales"
      delegate?.stateChange(postID: self.itemContentView.postID, state: nowState)
      
    case endOfSalesButton:
      delegate?.changeToEndOfSales(postID: self.itemContentView.postID, title: self.itemContentView.titleLabel.text!)
    default:
      break
    }
  }
}
