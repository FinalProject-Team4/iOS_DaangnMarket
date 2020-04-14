//
//  UserProfileImageNameView.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/13.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class UserProfileImageNameView: UIView {
  // MARK: Views
  
  private let sellerImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.layer.cornerRadius = 38
    $0.clipsToBounds = true
  }
  private let sellerName = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont(name: "Apple Braille", size: 16)
    $0.font = UIFont.boldSystemFont(ofSize: 16)
  }
  private let mannerEvaluationButton = UIButton().then {
    $0.layer.borderColor = UIColor(named: ColorReference.borderLine.rawValue)?.cgColor
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = 3
    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    $0.setTitle("매너평가하기", for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }
  private let allShowingButton = UIButton().then {
    $0.layer.borderColor = UIColor(named: ColorReference.borderLine.rawValue)?.cgColor
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = 3
    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    $0.setTitle("모아보기", for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
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
    sellerImageView.image = UIImage(named: "sellerImage1")
    sellerName.text = PostData.shared.username
  }
  
  private func setupConstraints() {
    let spacing: CGFloat = 16
    let imageSize: CGFloat = 76
    let buttonHeight: CGFloat = 40
    let viewWidth = UIScreen.main.bounds.width
    
    self.sellerImageView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalToSuperview().offset(spacing * 1.5)
        $0.leading.equalToSuperview().offset(spacing)
        $0.width.height.equalTo(imageSize)
        $0.bottom.equalToSuperview().offset(-spacing)
    }
    self.sellerName.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(sellerImageView)
        $0.leading.equalTo(sellerImageView.snp.trailing).offset(spacing)
    }
    self.mannerEvaluationButton.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.bottom.equalTo(sellerImageView)
        $0.leading.equalTo(sellerName)
        $0.height.equalTo(buttonHeight)
        $0.width.equalTo(viewWidth / 3.3)
    }
    self.allShowingButton.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(mannerEvaluationButton)
        $0.leading.equalTo(mannerEvaluationButton.snp.trailing).offset(spacing / 2)
        $0.width.height.equalTo(mannerEvaluationButton)
    }
  }
}
