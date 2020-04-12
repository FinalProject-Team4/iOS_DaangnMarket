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
    $0.text = MyTownSetting.shared.firstSelectTown
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
    changeNameNoti()
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
  
  // MARK: Action
  
  func changeNameNoti() {
    NotificationCenter.default.addObserver(self, selector: #selector(firstTownName), name: NSNotification.Name("FirstSelectTownCountView"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(secondTownName), name: NSNotification.Name("SecondSelectTownCountView"), object: nil)
  }
  
  @objc func firstTownName() {
    myTownLabel.text = MyTownSetting.shared.firstSelectTown
  }
  @objc func secondTownName() {
    myTownLabel.text = MyTownSetting.shared.secondSelectTown
  }

  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
