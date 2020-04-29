//
//  TownCountView.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol ShowAroundTownsNameDelegate: class {
  func showAroundTownsName(aroundTowns: [Town])
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
    $0.addTarget(self, action: #selector(didTapShowAroundTownCount), for: .touchUpInside)
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupConstraints()
    changeNameNoti()
  }
  
  deinit {
//    noti.removeObserver(
//       self,
//       name: NSNotification.Name("FirstSelectTownCountView"),
//       object: nil
//    )
//    noti.removeObserver(
//      self,
//      name: NSNotification.Name("SecondSelectTownCountView"),
//      object: nil
//      )
//    noti.removeObserver(
//      self,
//      name: NSNotification.Name("AroundTownCountView"),
//      object: nil
//    )
    noti.removeObserver(
      self,
      name: CustomSlider.sliderShouldChangeValueNotification,
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
//    noti.addObserver(
//      self,
//      selector: #selector(setFirstTownName),
//      name: NSNotification.Name("FirstSelectTownCountView"),
//      object: nil
//    )
//    noti.addObserver(
//      self,
//      selector: #selector(setSecondTownName),
//      name: NSNotification.Name("SecondSelectTownCountView"),
//      object: nil
//    )
//    noti.addObserver(
//      self,
//      selector: #selector(setAroundTownCount(_:)),
//      name: NSNotification.Name("AroundTownCountView"),
//      object: nil
//    )
    noti.addObserver(
      self,
      selector: #selector(didChangeSliderValue(_:)),
      name: CustomSlider.sliderShouldChangeValueNotification,
      object: nil
    )
  }
  
  // MARK: Action
  
  var aroundTowns = [Town]()
  
  @objc private func didChangeSliderValue(_ noti: Notification) {
    guard let value = noti.userInfo?["value"] as? Int else { return }
    
    // 동네 개수 설정
    let manager = AuthorizationManager.shared
    
    if let firstTown = manager.firstTown, firstTown.activated {
      self.aroundTowns = manager.firstAroundTown
        .filter { ($0.distance ?? 0) <= 1_200 * (Double(value) + 1) }
    } else if let secondTown = manager.secondTown, secondTown.activated {
      self.aroundTowns = manager.secondAroundTown
      .filter { ($0.distance ?? 0) <= 1_200 * (Double(value) + 1) }
    }
    
    let townCount = NSMutableAttributedString()
      .underlineBold(
        "근처 동네 \(self.aroundTowns.count)개",
        fontSize: 17
    )
    self.aroundTownCountBtn.setAttributedTitle(townCount, for: .normal)
    // 데이터 update
  }
  
//  @objc private func setFirstTownName() {
//    myTownLabel.text = MyTownSetting.shared.firstSelectTown
//  }
//  @objc private func setSecondTownName() {
//    myTownLabel.text = MyTownSetting.shared.secondSelectTown
//  }
//  @objc private func setAroundTownCount(_ sender: Notification) {
//    guard let userInfo = sender.userInfo,
//      let sharedData = userInfo["SingleTon"] as? MyTownSetting else { return }
//    if sharedData.isFirstTown {
//      let btnChangeTitle = NSMutableAttributedString().underlineBold(
//        "근처 동네 \(sharedData.numberOfAroundTownByFirst.0)개", fontSize: 17
//      )
//      aroundTownCountBtn.setAttributedTitle(btnChangeTitle, for: .normal)
//    } else {
//      let btnChangeTitle = NSMutableAttributedString().underlineBold(
//        "근처 동네 \(sharedData.numberOfAroundTownBySecond.0)개", fontSize: 17
//      )
//      aroundTownCountBtn.setAttributedTitle(btnChangeTitle, for: .normal)
//    }
//  }
  
  @objc private func didTapShowAroundTownCount() {
    self.delegate?.showAroundTownsName(aroundTowns: self.aroundTowns)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
