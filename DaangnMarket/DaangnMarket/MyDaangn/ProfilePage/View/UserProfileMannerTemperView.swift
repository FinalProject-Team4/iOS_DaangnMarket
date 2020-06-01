//
//  UserProfileMannerTemperView.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/13.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class UserProfileMannerTemperView: UIView {
  // MARK: Properties
  
  private let viewWidth = UIScreen.main.bounds.width
  private let userMannerTemp = 36.5
  
  // MARK: Views
  
  private let mannerTemperInform = UIButton().then {
    let title = NSMutableAttributedString(string: "매너온도ℹ︎")
    let underline = NSUnderlineStyle.single.rawValue
    title.addAttribute(NSMutableAttributedString.Key.underlineStyle, value: underline, range: NSRange(location: 0, length: 4))
    $0.setAttributedTitle(title, for: .normal)
    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
  }
  private let firstTemperatureLabel = UILabel().then {
    $0.text = "첫 온도 36.5ºC"
    $0.font = UIFont(name: "Galvji", size: 12)
    $0.textColor = UIColor(named: ColorReference.subText.rawValue)
  }
  private let firstTemperatureMark = UILabel().then {
    $0.text = "▾"
    $0.font = UIFont.systemFont(ofSize: 30)
    $0.textColor = UIColor(named: ColorReference.subText.rawValue)
  }
  private let userMannerTempLabel = UILabel().then {
    $0.font = UIFont.boldSystemFont(ofSize: 16)
    $0.textColor = UIColor(named: ColorReference.mannerTemperature.rawValue)
  }
  private let userMannerTempImageView = UIImageView().then {
    $0.image = UIImage(named: "mannerFace")
    $0.layer.cornerRadius = 12
    $0.clipsToBounds = true
  }
  private let mannerTempBackView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
    $0.layer.cornerRadius = 5
  }
  private let mannerTempBarView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.mannerTemperature.rawValue)
    $0.layer.cornerRadius = 5
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
    userMannerTempLabel.text = "\(String(userMannerTemp))ºC"
  }
  
  private func setupConstraints() {
    let spacing: CGFloat = 16
    let backViewWidth: CGFloat = viewWidth - (spacing * 2)
    
    self.mannerTemperInform.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalToSuperview()
        $0.leading.equalToSuperview().offset(spacing)
    }
    self.mannerTempBackView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(mannerTemperInform.snp.bottom).offset(spacing * 2)
        $0.centerX.equalToSuperview()
        $0.width.equalTo(backViewWidth)
        $0.height.equalTo(9)
        $0.bottom.equalToSuperview().offset(-spacing)
    }
    self.mannerTempBarView.then { mannerTempBackView.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(mannerTempBackView)
        $0.height.equalTo(mannerTempBackView)
        $0.width.equalTo(mannerTempBackView).multipliedBy(CGFloat(userMannerTemp / 100))
    }
    self.userMannerTempImageView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.trailing.equalToSuperview().inset(spacing)
        $0.bottom.equalTo(mannerTempBackView.snp.top).offset(-spacing / 2)
        $0.width.height.equalTo(24)
    }
    self.userMannerTempLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.trailing.equalTo(userMannerTempImageView.snp.leading).offset(-spacing / 2)
        $0.centerY.equalTo(userMannerTempImageView)
    }
    self.firstTemperatureMark.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.bottom.equalTo(mannerTempBackView.snp.top).offset(8)
        $0.leading.equalTo(mannerTempBackView).offset(backViewWidth / 100 * 36.5 - 5)
    }
    self.firstTemperatureLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.bottom.equalTo(firstTemperatureMark.snp.top).offset(12)
        $0.centerX.equalTo(firstTemperatureMark)
    }
  }
}
