//
//  MyPageSettingButtonsTableViewCel.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol MyPageSettinButtonsTVCDelegate: class {
  func moveToPageForSetting(tag: String)
}


class MyPageSettingButtonsTableViewCell: UITableViewCell {
  weak var delegate: MyPageSettinButtonsTVCDelegate?
  
  // MARK: Views
  
  private let backView = UIView().then {
    $0.backgroundColor = .white
  }
  private let shareButton = MyPageSettingButton(image: "share", title: "당근마켓 공유")
  private let noticeButton = MyPageSettingButton(image: "megaphone", title: "공지사항")
  private let settingButton = MyPageSettingButton(image: "settings", title: "설정")
  
  // MARK: Initialize
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.contentView.backgroundColor = UIColor(named: ColorReference.backLightGray.rawValue)
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
    [shareButton, noticeButton, settingButton].forEach {
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
    self.shareButton.then { backView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.equalToSuperview().offset(spacing)
    }
    self.noticeButton.then { backView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(shareButton.snp.bottom).offset(buttonSpacing)
        $0.leading.equalTo(shareButton)
    }
    self.settingButton.then { backView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(noticeButton.snp.bottom).offset(buttonSpacing)
        $0.leading.equalTo(noticeButton)
        $0.bottom.equalTo(backView).offset(-spacing)
    }
  }
  
  // MARK: Action
  
  @objc func didTapButton(_ sender: UIButton) {
    switch sender {
    case shareButton:
      delegate?.moveToPageForSetting(tag: "shareButton")
    case noticeButton:
      delegate?.moveToPageForSetting(tag: "noticeButton")
    case settingButton:
      delegate?.moveToPageForSetting(tag: "settingButton")
    default:
      print("default")
    }
  }
}
