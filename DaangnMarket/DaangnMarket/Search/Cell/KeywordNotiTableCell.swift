//
//  KeywordNotiTableCell.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/17.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class KeywordNotiTableCell: UITableViewCell {
  private lazy var keywordNotiButton = UIButton().then {
    $0.backgroundColor = .white
    $0.setImage(UIImage(systemName: "bell"), for: .normal)
    $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
    $0.tintColor = .black
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.backgroundColor = UIColor(named: ColorReference.lightBackground.rawValue)
    contentView.addSubview(keywordNotiButton)
    keywordNotiButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(44)
    }
  }
  
  func setupKeywordView(text: String) {
    let attributeText = NSMutableAttributedString()
      .bold("\(text)", fontSize: 13)
      .normal(" 알림 등록하기", fontSize: 13)
    keywordNotiButton.setAttributedTitle(attributeText, for: .normal)
  }
}
