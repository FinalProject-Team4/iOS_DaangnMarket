//
//  FindMyTownNavigationBar.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/26.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class DGNavigationBar: UIView {
  // MARK: Views
  
  private let leftButtonFrame = UIStackView()
  private let rightButtonFrame = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 16
    $0.alignment = .fill
    $0.distribution = .fillEqually
  }
  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 17, weight: .semibold)
  }
  private let shadowLine = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.navigationShadow.rawValue)
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    self.leftButtonFrame
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalToSuperview().offset(16)
        $0.centerY.equalToSuperview()
        $0.size.equalTo(UINavigationBar.navigationItemSize)
    }
    self.rightButtonFrame
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.trailing.equalToSuperview().offset(-16)
        $0.centerY.equalToSuperview()
        $0.height.equalTo(UINavigationBar.navigationItemSize.height)
    }
    self.titleLabel
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.center.equalToSuperview()
    }
    self.snp.makeConstraints {
      $0.size.equalTo(UINavigationBar.navigationBarSize)
    }
    self.shadowLine
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.trailing.bottom.equalToSuperview()
        $0.height.equalTo(0.5)
    }
  }
  
  // MARK: Interface
  
  var leftButton: UIButton? {
    get { return self.leftButtonFrame.arrangedSubviews.first as? UIButton }
    set {
      self.leftButtonFrame.arrangedSubviews.forEach {
        self.leftButtonFrame.removeArrangedSubview($0)
      }
      self.leftButtonFrame.addArrangedSubview(newValue ?? UIButton())
    }
  }
  
  var rightButton: UIButton? {
    get { return self.rightButtonFrame.arrangedSubviews.first as? UIButton }
    set {
      self.rightButtonFrame.arrangedSubviews.forEach {
        self.rightButtonFrame.removeArrangedSubview($0)
        $0.removeFromSuperview()
      }
      self.rightButtonFrame.addArrangedSubview(newValue ?? UIButton())
    }
  }
  
  var rightButtons: [UIButton]? {
    get {
      return self.rightButtonFrame
        .arrangedSubviews
        .compactMap { $0 as? UIButton }
    }
    set {
      self.rightButtonFrame.arrangedSubviews.forEach {
        self.rightButtonFrame.removeArrangedSubview($0)
        $0.removeFromSuperview()
      }
      newValue?.forEach {
        self.rightButtonFrame.addArrangedSubview($0)
      }
    }
  }
  
  var title: String {
    get { self.titleLabel.text ?? "" }
    set { self.titleLabel.text = newValue }
  }
  
  var isShadowHidden: Bool = false {
    didSet {
      self.shadowLine.backgroundColor = isShadowHidden ?
        .clear :
        UIColor(named: ColorReference.navigationShadow.rawValue)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
