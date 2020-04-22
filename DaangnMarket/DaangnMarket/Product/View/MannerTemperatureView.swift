//
//  MannerTemperatureView.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/13.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class MannerTemperatureView: UIView {
  // MARK: Properties
  
  private let mannerTemp = 36.5
  
  // MARK: Views
  
  private let mannerTempLabel = UILabel().then {
    $0.textColor = UIColor(named: ColorReference.mannerTemperature.rawValue)
    $0.font = UIFont(name: "Arial", size: 16)
    $0.font = UIFont.boldSystemFont(ofSize: 16)
  }
  private let mannerStatusBackView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
    $0.layer.cornerRadius = 3
  }
  private let mannerStatusView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.mannerTemperature.rawValue)
    $0.layer.cornerRadius = 3
  }
  private let mannerFaceImageView = UIImageView().then {
    $0.layer.cornerRadius = 12
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
  }
  private let mannerTitleLabel = UILabel().then {
    $0.text = "매너온도"
    $0.textColor = .gray
    $0.font = UIFont.systemFont(ofSize: 12)
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
    mannerTempLabel.text = "\(String(mannerTemp))º"
    mannerFaceImageView.image = UIImage(named: "mannerFace")
  }
  
  private func setupConstraints() {
    let spacing: CGFloat = 16
    let mannerFaceSize: CGFloat = 24
    let mannerStatusBarHeight: CGFloat = 5
    
    self.mannerTempLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalToSuperview().offset(spacing / 1.5)
        $0.leading.equalToSuperview()
    }
    self.mannerFaceImageView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(mannerTempLabel.snp.trailing).offset(spacing)
        $0.top.equalTo(mannerTempLabel)
        $0.trailing.equalToSuperview().inset(spacing)
        $0.width.height.equalTo(mannerFaceSize)
    }
    self.mannerStatusBackView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(mannerTempLabel)
        $0.bottom.equalTo(mannerFaceImageView).offset(3)
        $0.height.equalTo(mannerStatusBarHeight)
        $0.trailing.equalTo(mannerFaceImageView.snp.leading).offset(-spacing / 2)
    }
    self.mannerStatusView.then { mannerStatusBackView.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.height.equalTo(mannerStatusBackView)
        $0.width.equalTo(mannerStatusBackView).multipliedBy(CGFloat(mannerTemp / 100))
    }
    self.mannerTitleLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.trailing.equalTo(mannerFaceImageView)
        $0.top.equalTo(mannerFaceImageView.snp.bottom).offset(spacing / 3)
        $0.bottom.equalTo(self).offset(-spacing / 2)
    }
  }
}
