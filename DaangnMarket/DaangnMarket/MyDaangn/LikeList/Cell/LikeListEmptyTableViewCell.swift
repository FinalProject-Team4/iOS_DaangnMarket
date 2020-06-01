//
//  LikeListEmptyTableViewCell.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/29.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class LikeListEmptyTableViewCell: UITableViewCell {
  let backView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.backGray.rawValue)
  }
  let messageLabel = UILabel().then {
    $0.text = "아직 관심을 누른 중고거래가 없어요"
    $0.textColor = UIColor(named: ColorReference.inputText.rawValue)
    $0.textAlignment = .center
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupConstraints()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupConstraints() {
    let viewWidth = UIScreen.main.bounds.width
    let viewHeight = UIScreen.main.bounds.height
    self.backView.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.width.equalTo(viewWidth)
        $0.height.equalTo(viewHeight - 200)
        $0.top.leading.equalToSuperview()
    }
    
    self.messageLabel.then { self.backView.addSubview($0) }
      .snp.makeConstraints {
        $0.centerX.centerY.equalToSuperview()
    }
  }
}
