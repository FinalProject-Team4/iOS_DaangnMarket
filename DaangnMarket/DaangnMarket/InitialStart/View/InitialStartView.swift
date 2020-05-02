//
//  InitialStartView.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/26.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class InitialStartView: UIView {
  // MARK: Views
  
  private let animationView = DaangnAnimationView()
  private let titleLabel = UILabel().then {
    $0.text = "우리 동네 중고 직거래 당근마켓"
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 20, weight: .bold)
  }
  private let subTitleLabel = UILabel().then {
    $0.text = "당근마켓은 동네 직거래 마켓이에요.\n 내 동네를 설정하고 시작해보세요!"
    $0.textAlignment = .center
    $0.numberOfLines = 2
    $0.font = .systemFont(ofSize: 16)
  }
  private lazy var startButton = DGButton().then {
    $0.setTitle("내 동네 설정하고 시작하기", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
    $0.layer.cornerRadius = 8
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    let spacing: CGFloat = 16
    let buttonSize: CGFloat = 48
    
    self.animationView
      .then { self.addSubview($0) }
      .snp
      .makeConstraints {
        $0.top.leading.trailing.equalToSuperview()
        $0.size.equalTo(self.snp.width)
      }
    self.titleLabel
      .then { self.addSubview($0) }
      .snp
      .makeConstraints {
        $0.top.equalTo(self.animationView.snp.bottom).offset(spacing)
        $0.centerX.equalTo(self.animationView)
      }
    self.subTitleLabel
      .then { self.addSubview($0) }
      .snp
      .makeConstraints {
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(spacing / 2)
        $0.centerX.equalTo(self.titleLabel)
    }
    self.startButton
      .then { self.addSubview($0) }
      .snp
      .makeConstraints {
        $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(spacing * 2)
        $0.leading.trailing
          .equalToSuperview()
        .inset(UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing))
        $0.bottom.equalToSuperview()
        $0.height.equalTo(buttonSize)
    }
  }
  
  // MARK: Interface
  
  func addTarget(_ target: Any?, action: Selector) {
    self.startButton.addTarget(target, action: action, for: .touchUpInside)
  }
  
  func animate() {
    self.animationView.animate()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
