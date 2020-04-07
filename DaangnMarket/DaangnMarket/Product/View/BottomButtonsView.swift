//
//  BottomButtonsView.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/02.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class BottomButtonsView: UIView {
  // MARK: Views
  
  private let heartButton = UIButton().then {
    $0.setImage(UIImage(systemName: "heart"), for: .normal)
    $0.tintColor = UIColor(named: ColorReference.noResultImage.rawValue)
  }
  private let lineView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  private let priceLabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.boldSystemFont(ofSize: 15)
  }
  private var noNegociableLabel = UILabel().then {
    $0.text = "가격제안 불가"
    $0.textColor = UIColor(named: ColorReference.noResultImage.rawValue)
    $0.font = UIFont.boldSystemFont(ofSize: 13)
  }
  private var negociableButton = UIButton().then {
    $0.setTitle("가격제안 가능", for: .normal)
    $0.setTitleColor(UIColor(named: ColorReference.daangnMain.rawValue), for: .normal)
    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
  }
  private let chatButton = DGButton().then {
    $0.setTitle("채팅으로 거래하기", for: .normal)
    $0.layer.cornerRadius = 5
    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
  }
  private let bottomLineView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  
  // MARK: Properties
  var isNegociable = false
  private var isFullHeart = false
  
  // MARK: Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  convenience init(price: String, nego: Bool) {
    self.init()
    self.priceLabel.text = price
    self.negociableButton.isHidden = !nego
    self.noNegociableLabel.isHidden = nego
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    heartButton.addTarget(self, action: #selector(didTapHeartButton(_:)), for: .touchUpInside)
    negociableButton.addTarget(self, action: #selector(didTapNegociableButton(_:)), for: .touchUpInside)
    chatButton.addTarget(self, action: #selector(didTapChatButton(_:)), for: .touchUpInside)
  }
  
  private func setupConstraints() {
    let spacing: CGFloat = 16
    let chatButtonWidth: CGFloat = 136
    let chatButtonHeight: CGFloat = 40
    let heartButtonSize: CGFloat = 24
    guard let negociableButtonHeight = negociableButton.titleLabel?.intrinsicContentSize.height else { return }
    
    self.chatButton.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.trailing.bottom.equalToSuperview().inset(spacing)
        $0.width.equalTo(chatButtonWidth)
        $0.height.equalTo(chatButtonHeight)
    }
    self.heartButton.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalToSuperview().offset(spacing)
        $0.centerY.equalTo(chatButton)
        $0.width.height.equalTo(heartButtonSize)
    }
    self.lineView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.width.equalTo(1)
        $0.height.equalTo(chatButton)
        $0.leading.equalTo(heartButton.snp.trailing).offset(spacing)
        $0.centerY.equalTo(heartButton)
    }
    self.priceLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(lineView)
        $0.leading.equalTo(lineView.snp.trailing).offset(spacing)
    }
    self.noNegociableLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.bottom.equalTo(lineView)
        $0.leading.equalTo(priceLabel)
    }
    self.negociableButton.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(priceLabel)
        $0.height.equalTo(negociableButtonHeight)
        $0.bottom.equalTo(noNegociableLabel)
    }
    self.bottomLineView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.height.equalTo(0.5)
        $0.width.equalTo(self)
        $0.top.equalTo(self)
    }
  }
  
  // MARK: Actions
  
  @objc private func didTapHeartButton(_ sender: Any) {
    isFullHeart.toggle()
    if isFullHeart == true {
      heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
      heartButton.tintColor = UIColor(named: ColorReference.daangnMain.rawValue)
    } else {
      heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
      heartButton.tintColor = .gray
    }
  }
  
  @objc private func didTapNegociableButton(_ sender: Any) {
    //let negoVC = NegociationViewController()
  }
  
  @objc private func didTapChatButton(_ sender: Any) {
  }
}
