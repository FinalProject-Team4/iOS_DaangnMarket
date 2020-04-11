//
//  CustomNavigationBarView.swift
//  DaangnMarket
//
//  Created by Mac mini on 2020/04/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol CustomNavigationBarViewDelegate: class {
  func goBackPage()
}

class CustomNavigationBarView: UIView {
  // MARK: Views
  
  weak var delegate: CustomNavigationBarViewDelegate?
  
  var backButton = UIButton().then {
    $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
    $0.imageView?.contentMode = .scaleAspectFit
    $0.tintColor = .black
  }
  var sendOptionButton = UIButton().then {
    $0.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
    $0.imageView?.contentMode = .scaleAspectFit
    $0.tintColor = .black
  }
  var otherOptionButton = UIButton(type: .custom).then {
    let image = UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate)
    $0.setImage(image, for: .normal)
    $0.imageView?.contentMode = .scaleAspectFit
    $0.tintColor = .black
  }
  lazy var gradientLayer = CAGradientLayer().then {
    $0.frame = self.bounds
  }
  var lineView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
    $0.isHidden = true
  }
  
  // MARK: Properties
  
  let viewWidth = UIScreen.main.bounds.width
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  convenience init(isImages: Bool) {
    self.init()
    if isImages {
      setupBlackBackground()
    } else {
      setupWhiteBackground()
    }
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupWhiteBackground() {
    gradientLayer.backgroundColor = UIColor.white.cgColor
    gradientLayer.colors = [UIColor.white.cgColor]
    [backButton, sendOptionButton, otherOptionButton].forEach {
      $0.tintColor = .black
    }
  }
  
  func setupBlackBackground() {
    gradientLayer.backgroundColor = UIColor.clear.cgColor
    gradientLayer.colors = [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.clear.cgColor]
    [backButton, sendOptionButton, otherOptionButton].forEach {
      $0.tintColor = .white
    }
  }
  
  func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  func setupAttributes() {
    self.frame = CGRect(x: 0, y: 0, width: viewWidth, height: 90)
    self.layer.addSublayer(gradientLayer)
    let buttonSize: CGFloat = 23
    let size: CGFloat = 15
    otherOptionButton.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
    [backButton, sendOptionButton].forEach {
      $0.imageEdgeInsets = UIEdgeInsets(top: buttonSize, left: buttonSize, bottom: buttonSize, right: buttonSize)
    }
    backButton.addTarget(self, action: #selector(didTapBackButton(_:)), for: .touchUpInside)
    sendOptionButton.addTarget(self, action: #selector(didTapSendOptionButton(_:)), for: .touchUpInside)
    otherOptionButton.addTarget(self, action: #selector(didTapOtherOptionButton(_:)), for: .touchUpInside)
  }
  
  func setupConstraints() {
    let spacing: CGFloat = 16
    self.backButton.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self).offset(spacing * 3.5)
        $0.leading.equalTo(self).offset(spacing)
    }
    self.otherOptionButton.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(backButton).offset(4)
        $0.trailing.equalTo(self).offset(-spacing)
        $0.width.height.equalTo(15)
    }
    self.sendOptionButton.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.trailing.equalTo(otherOptionButton.snp.leading).offset(-spacing)
        $0.top.equalTo(backButton)
    }
    self.lineView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.height.equalTo(0.5)
        $0.width.equalTo(self)
        $0.bottom.equalTo(self)
    }
  }
  // MARK: Actions
  
  @objc func didTapBackButton(_ sender: Any) {
    delegate?.goBackPage()
  }
  @objc func didTapSendOptionButton(_ sender: Any) {
    print("didTapSendOptionButton")
  }
  @objc func didTapOtherOptionButton(_ sender: Any) {
    print("didTapOtherOptionButton")
  }
}
