//
//  TownCountView.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol ShowAroundTownsNameDelegate: class {
  func showAroundTownsName()
}

class TownCountView: UIView {
  // MARK: Property
  
  let noti = NotificationCenter.default
  weak var delegate: ShowAroundTownsNameDelegate?
  
  // MARK: Views
  
  lazy var myTownLabel = UILabel().then {
    $0.textAlignment = .center
    $0.font = .systemFont(ofSize: 17, weight: .regular)
  }
  lazy var aroundTownCountBtn = UIButton().then {
//    let initTownCount = AuthorizationManager.shared.aroundTown.filter { Float($0.distance!/1_200) <= 1.0 }
//    var btnTitle = NSMutableAttributedString().underlineBold("근처 동네 \(initTownCount.count)개", fontSize: 17)
//    $0.setAttributedTitle(btnTitle, for: .normal)
    $0.addTarget(self, action: #selector(didTapShowAroundTownCount), for: .touchUpInside)
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupConstraints()
    changeNameNoti()
  }
  
  deinit {
    noti.removeObserver(
       self,
       name: NSNotification.Name("FirstSelectTownCountView"),
       object: nil
    )
    noti.removeObserver(
      self,
      name: NSNotification.Name("SecondSelectTownCountView"),
      object: nil
      )
    noti.removeObserver(
      self,
      name: NSNotification.Name("AroundTownCountView"),
      object: nil
    )
  }
  
  private func setupConstraints() {
    [myTownLabel, aroundTownCountBtn].forEach { self.addSubview($0) }
    myTownLabel.snp.makeConstraints {
      $0.centerY.equalTo(self)
      $0.leading.equalTo(self)
    }
    aroundTownCountBtn.snp.makeConstraints {
      $0.centerY.equalTo(self)
      $0.leading.equalTo(myTownLabel.snp.trailing).offset(5)
      $0.trailing.equalTo(self.snp.trailing)
    }
  }
  
  // MARK: Notification Observer
  
  private func changeNameNoti() {
    noti.addObserver(
      self,
      selector: #selector(setFirstTownName),
      name: NSNotification.Name("FirstSelectTownCountView"),
      object: nil
    )
    noti.addObserver(
      self,
      selector: #selector(setSecondTownName),
      name: NSNotification.Name("SecondSelectTownCountView"),
      object: nil
    )
    noti.addObserver(
      self,
      selector: #selector(setAroundTownCount(_:)),
      name: NSNotification.Name("AroundTownCountView"),
      object: nil
    )
  }
  
  // MARK: Action
  
  @objc private func setFirstTownName() {
    myTownLabel.text = MyTownSetting.shared.firstSelectTown
  }
  @objc private func setSecondTownName() {
    myTownLabel.text = MyTownSetting.shared.secondSelectTown
  }
  @objc private func setAroundTownCount(_ sender: Notification) {
    guard let userInfo = sender.userInfo,
      let sharedData = userInfo["SingleTon"] as? MyTownSetting else { return }
    if sharedData.isFirstTown {
      let btnChangeTitle = NSMutableAttributedString().underlineBold(
        "근처 동네 \(sharedData.numberOfAroundTownByFirst.0)개", fontSize: 17
      )
      aroundTownCountBtn.setAttributedTitle(btnChangeTitle, for: .normal)
    } else {
      let btnChangeTitle = NSMutableAttributedString().underlineBold(
        "근처 동네 \(sharedData.numberOfAroundTownBySecond.0)개", fontSize: 17
      )
      aroundTownCountBtn.setAttributedTitle(btnChangeTitle, for: .normal)
    }
  }
  @objc private func didTapShowAroundTownCount() {
    self.delegate?.showAroundTownsName()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
