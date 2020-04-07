//
//  TownCountView.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class TownCountView: UIView {
  lazy var myTownLabel = UILabel().then {
    $0.text = "군자동"
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 17, weight: .regular)
  }
  lazy var aroundTownCountLabel = UILabel().then {
    $0.textAlignment = .center
    $0.attributedText = NSMutableAttributedString().underlineBold("근처 동네 \(MyTownSetting.shared.numberOfAroundTown ?? 0)개", fontSize: 17)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupConstraints()
    MyTownSetting.shared.selectTownName = MyTownSetting.shared.towns["first"] ?? "동네없음"
//    MyTownSetting.shared.numberOfAroundTown = 40
//    print(MyTownSetting.shared.selectTownName)
//    MyTownSetting.shared.numberOfAroundTown = AuthorizationManager.shared.address.count
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
