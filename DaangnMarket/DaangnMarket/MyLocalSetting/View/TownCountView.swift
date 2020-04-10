//
//  TownCountView.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class TownCountView: UIView {
  // MARK: Views
  lazy var myTownLabel = UILabel().then {
    $0.text = MyTownSetting.shared.selectTownName ?? "동네오류"
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 17, weight: .regular)
  }
  lazy var aroundTownCountLabel = UILabel().then {
    $0.textAlignment = .center
    $0.attributedText = NSMutableAttributedString().underlineBold("근처 동네 \(MyTownSetting.shared.numberOfAroundTown ?? 0)개", fontSize: 17)
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupConstraints()
  }
  
  private func setupConstraints() {
    let viewSubUI = [myTownLabel, aroundTownCountLabel]
    viewSubUI.forEach { self.addSubview($0) }
    myTownLabel.snp.makeConstraints {
      $0.centerY.equalTo(self)
      $0.leading.equalTo(self)
    }
    aroundTownCountLabel.snp.makeConstraints {
      $0.centerY.equalTo(self)
      $0.leading.equalTo(myTownLabel.snp.trailing).offset(5)
      $0.trailing.equalTo(self.snp.trailing)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
