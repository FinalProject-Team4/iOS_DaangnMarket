//
//  MyPageListButtonsTableViewCell.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol MyPageListButtonDelegate: class {
  func moveToPage(tag: String)
}

class MyPageListButtonsTableViewCell: UITableViewCell {
  weak var delegate: MyPageListButtonDelegate?
  
  static let identifier = "myPageListButtonTableCell"
  
  // MARK: Views
  
  private let salesListbutton = MyPageListButton(image: "SalesList", title: "판매내역")
  private let purchaseListButton = MyPageListButton(image: "PurchaseList", title: "구매내역")
  private let likeListButton = MyPageListButton(image: "LikeList", title: "관심목록")
  
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
    self.backgroundColor = .white
    [salesListbutton, likeListButton].forEach {
      $0.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
  }
  
  private func setupConstraints() {
    let viewWidth = UIScreen.main.bounds.width
    let buttonSize: CGFloat = 60
    let varSpacing: CGFloat = (viewWidth - (buttonSize * 3)) / 4
    let horSpacing: CGFloat = 24
    
    self.salesListbutton.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalToSuperview().offset(horSpacing)
        $0.leading.equalToSuperview().offset(varSpacing)
        $0.bottom.equalToSuperview().offset(-horSpacing)
    }
    
    self .purchaseListButton.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(salesListbutton.snp.trailing).offset(varSpacing)
        $0.centerY.equalTo(salesListbutton)
    }
    self.likeListButton.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(purchaseListButton.snp.trailing).offset(varSpacing)
        $0.centerY.equalTo(salesListbutton)
    }
  }
  
  // MARK: Action
  
  @objc private func didTapButton(_ sender: UIButton) {
    switch sender {
    case salesListbutton:
      delegate?.moveToPage(tag: "salesListButton")
    case likeListButton:
      delegate?.moveToPage(tag: "likeListButton")
    default:
      print("nothing")
    }
  }
}
