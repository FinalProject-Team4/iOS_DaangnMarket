//
//  MyPageOptionButtonsTableViewCell.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol MyPageOptionButtonsTVCDelegate: class {
  func moveToPageForOption(tag: String)
}

class MyPageOptionButtonsTableViewCell: UITableViewCell {
  weak var delegate: MyPageOptionButtonsTVCDelegate?
  
  // MARK: Views
  
  private let backView = UIView().then {
    $0.backgroundColor = .white
  }
  private let myTownSettingButton = MyPageSettingButton(image: "placeholder", title: "내 동네 설정")
  private let confirmMyTownButton = MyPageSettingButton(image: "target", title: "동네 인증하기")
  private let gatheringButton = MyPageSettingButton(image: "apps", title: "모아보기")
  
  // MARK: Initialize
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.contentView.backgroundColor = UIColor(named: ColorReference.backLightGray.rawValue)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  func setupAttributes() {
    [myTownSettingButton, confirmMyTownButton, gatheringButton].forEach {
      $0.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
  }
  
  private func setupConstraints() {
    let spacing: CGFloat = 16
    let buttonSpacing: CGFloat = 32
    
    self.backView.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalToSuperview().inset(spacing / 2)
        $0.bottom.leading.trailing.equalToSuperview()
    }
    self.myTownSettingButton.then { backView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.equalToSuperview().offset(spacing)
    }
    self.confirmMyTownButton.then { backView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(myTownSettingButton.snp.bottom).offset(buttonSpacing)
        $0.leading.equalTo(myTownSettingButton)
    }
    self.gatheringButton.then { backView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(confirmMyTownButton.snp.bottom).offset(buttonSpacing)
        $0.leading.equalTo(confirmMyTownButton)
        $0.bottom.equalTo(backView).offset(-spacing)
    }
  }
  
  // MARK: Action
  
  @objc func didTapButton(_ sender: UIButton) {
    switch sender {
    case myTownSettingButton:
      delegate?.moveToPageForOption(tag: "myTownSettingButton")
    case confirmMyTownButton:
      delegate?.moveToPageForOption(tag: "confirmMyTownButton")
    case gatheringButton:
      delegate?.moveToPageForOption(tag: "gatheringButton")
    default:
      print("default")
    }
  }
}
