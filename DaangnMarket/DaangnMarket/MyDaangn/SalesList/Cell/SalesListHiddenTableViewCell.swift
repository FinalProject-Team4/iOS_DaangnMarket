//
//  SalesListHiddenTableViewCell.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol SalesListHiddenTVCDelegate: class {
  func hiddenSalesOption()
}

class SalesListHiddenTableViewCell: UITableViewCell {
  weak var delegate: SalesListHiddenTVCDelegate?
  private let numberFormatter = NumberFormatter()
  
  // MARK: Views
  
  private let backView = UIView().then {
    $0.backgroundColor = .white
  }
  var itemContentView = SalesListContentView()
  private let optionButton = UIButton().then {
    $0.setImage(UIImage(named: "menu"), for: .normal)
  }
  private let verLine = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  private var hiddenButton = UIButton().then {
    $0.setTitle("숨기기 해제", for: .normal)
    $0.setTitleColor(.black, for: .normal)
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
    self.hiddenButton.then { self.backView.addSubview($0) }
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
    delegate?.hiddenSalesOption()
  }
  
  // MARK: Interface
  
  func configure(hiddenData: Post) {
    self.itemContentView.itemImageView.image = UIImage(named: "image4")
    self.itemContentView.titleLabel.text = hiddenData.title
    self.itemContentView.addrTimeLabel.text = "\(hiddenData.address) ･ \(PostData.shared.calculateDifferentTime(updated: hiddenData.created))"
    self.numberFormatter.numberStyle = .decimal
    self.itemContentView.priceLabel.text = "\(numberFormatter.string(from: NSNumber(value: hiddenData.price))!)원"
  }
}
