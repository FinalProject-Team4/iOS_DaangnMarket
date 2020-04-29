//
//  selectTownView.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/03.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
protocol SecondTownButtonDelegate: class {
  func secondTownSetBtn(_ button: UIButton)
}

class TownSelectView: UIView {
  // MARK: Propoerty
  
  let noti = NotificationCenter.default
  weak var delegate: SecondTownButtonDelegate?
  
  // MARK: Views
  
  private let partitionLineView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.noResultImage.rawValue)
  }
  private let townSelectLabel = UILabel().then {
    $0.text = "동네 선택"
    $0.font = .systemFont(ofSize: 17, weight: .bold)
  }
  private let townSelectDescribeLabel = UILabel().then {
    $0.text = "지역은 최소 1개 이상 최대 2개까지 설정가능해요."
    $0.font = .systemFont(ofSize: 13, weight: .regular)
    $0.textColor = UIColor(named: ColorReference.noResultImage.rawValue)
  }
  var firstTownSelectBtn = FirstTownSelectButton().then {
//    $0.layer.cornerRadius = 5
    $0.addTarget(self, action: #selector(didTapSelectTownButton(_:)), for: .touchUpInside)
//    $0.backgroundColor = UIColor(named: ColorReference.daangnMain.rawValue)
    }
  var secondTownSelectBtn = SecondTownSelectButton().then {
//    $0.layer.cornerRadius = 5
    $0.addTarget(self, action: #selector(didTapSelectTownButton(_:)), for: .touchUpInside)
  }
  var addTownBtn = SecondTownSetButton().then {
    $0.addTarget(self, action: #selector(didTapSelectTownButton(_:)), for: .touchUpInside)
    $0.setImage(UIImage(systemName: "plus"), for: .normal)
    $0.tintColor = UIColor(named: ColorReference.noResultImage.rawValue)
    $0.layer.cornerRadius = 5
    $0.layer.borderColor = UIColor(named: ColorReference.noResultImage.rawValue)?.cgColor
    $0.layer.borderWidth = 1
    $0.backgroundColor = .white
  }
  lazy var upperAlert = DGUpperAlert()
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    inViewSetupConstraints()
  }
    
  private func inViewSetupConstraints() {
    [
      townSelectLabel, townSelectDescribeLabel, partitionLineView,
      firstTownSelectBtn, secondTownSelectBtn, addTownBtn
    ].forEach { self.addSubview($0) }
    townSelectLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(24)
    }
    townSelectDescribeLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(townSelectLabel.snp.bottom).offset(8)
    }
    partitionLineView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.width.equalTo(self.snp.width).multipliedBy(0.9)
      $0.height.equalTo(0.5)
    }
    firstTownSelectBtn.snp.makeConstraints {
      $0.top.equalTo(townSelectDescribeLabel.snp.bottom).offset(16)
      $0.leading.equalTo(self.snp.leading).offset(12)
      $0.width.equalTo(172)
      $0.height.equalTo(50)
    }
    secondTownSelectBtn.snp.makeConstraints {
      $0.top.equalTo(firstTownSelectBtn)
      $0.trailing.equalTo(self.snp.trailing).offset(-12)
      $0.width.equalTo(172)
      $0.height.equalTo(50)
    }
    addTownBtn.snp.makeConstraints {
      $0.top.equalTo(firstTownSelectBtn)
      $0.trailing.equalTo(self.snp.trailing).offset(-12)
      $0.width.equalTo(172)
      $0.height.equalTo(50)
    }
  }
  
  // MARK: Method
  
//  private func changeSelectedTownBtnColor(_ item: UIView) {
//    item.backgroundColor = UIColor(named: ColorReference.daangnMain.rawValue)
//    item.layer.borderWidth = 1
//    item.layer.borderColor = UIColor(named: ColorReference.daangnMain.rawValue)?.cgColor
//    if item == firstTownSelectBtn {
//      firstTownSelectBtn
//        .selectedFirstTownLabel
//        .textColor = .white
//      firstTownSelectBtn
//        .deleteSelectedFirstTownButton
//        .tintColor = .white
//    } else if item == secondTownSelectBtn {
//      secondTownSelectBtn
//        .selectedSecondTownLabel
//        .textColor = .white
//      secondTownSelectBtn
//        .deleteSelectedSecondTownButton
//        .tintColor = .white
//    }
//  }
//  private func changeUnSelectedTownBtnColor(_ item: UIView) {
//    item.layer.borderWidth = 1
//    item.layer.borderColor = UIColor(named: ColorReference.noResultImage.rawValue)?.cgColor
//    item.backgroundColor = .white
//    if item == firstTownSelectBtn {
//      firstTownSelectBtn
//        .selectedFirstTownLabel
//        .textColor = .black
//      firstTownSelectBtn
//        .deleteSelectedFirstTownButton
//        .tintColor = UIColor(named: ColorReference.noResultImage.rawValue)
//    } else if item == secondTownSelectBtn {
//      secondTownSelectBtn
//        .selectedSecondTownLabel
//        .textColor = .black
//      secondTownSelectBtn
//        .deleteSelectedSecondTownButton
//        .tintColor = UIColor(named: ColorReference.noResultImage.rawValue)
//    }
//  }
  
  // MARK: Action

  @objc func didTapSelectTownButton(_ sender: UIButton) {
//    defer {
//      noti.post(
//        name: NSNotification.Name("AroundTownCountView"),
//        object: nil,
//        userInfo: [
//          "SingleTon": MyTownSetting.shared
//        ]
//      )
//    }
    
    switch sender {
    case firstTownSelectBtn:
      self.setupAroundViewFirstTown()
      
//      MyTownSetting.shared.register(isFirstTown: true)
//      noti.post(
//        name: NSNotification.Name("FirstSelectTownCountView"),
//        object: nil
//      )
//      print(MyTownSetting.shared.numberOfAroundTownByFirst)
      
//      changeBtnColor(firstTownSelectBtn)
      willDisplayUpperAlert(.firstBtn)
    case secondTownSelectBtn:
      self.setupAroundViewAboutSecondTown()
      
//      MyTownSetting.shared.register(isFirstTown: false)
//      noti.post(
//        name: NSNotification.Name("SecondSelectTownCountView"),
//        object: nil
//      )
//      print(MyTownSetting.shared.numberOfAroundTownBySecond)
//      changeBtnColor(secondTownSelectBtn)
      willDisplayUpperAlert(.secondBtn)
    case addTownBtn:
      self.delegate?.secondTownSetBtn(sender)
    default:
      return
    }
    changeBtnColor(sender)
  }
  
  func setupAroundViewFirstTown() {
    let manager = AuthorizationManager.shared
    guard let firstTown = manager.firstTown else { return }
    
    // Slider 위치 설정
    let aroundView = self.superview?
      .subviews
      .compactMap { $0 as? MyTownAroundView }
      .first
      
    let sliderValue = Float(firstTown.distance / 1_200) - 1
    aroundView?.distanceSlider
      .slider
      .value = sliderValue
    
    // 현재 동네 이름 설정
    aroundView?.townCountView.myTownLabel.text = firstTown.locate.dong
    
    // 근처 동네 개수 설정
    let filtered = manager.firstAroundTown
      .filter { ($0.distance ?? 0) <= 1_200 * (Double(sliderValue) + 1) }
    let townCount = NSMutableAttributedString()
      .underlineBold(
        "근처 동네 \(filtered.count)개",
        fontSize: 17
    )
    let countView = self.superview?
      .subviews
      .compactMap { $0 as? MyTownAroundView }
      .first?
      .townCountView
      
    countView?.aroundTownCountBtn
      .setAttributedTitle(townCount, for: .normal)
    countView?.aroundTowns = filtered
    
    // Activate 상태 설정
    manager.updateFirstTown(activated: true)
    manager.updateSecondTown(activated: false)
  }
  
  func setupAroundViewAboutSecondTown() {
    let manager = AuthorizationManager.shared
    guard let secondTown = manager.secondTown else { return }
    
    // Slider 설정
    let aroundView = self.superview?
      .subviews
      .compactMap { $0 as? MyTownAroundView }
      .first
      
    let sliderValue = Float(secondTown.distance / 1_200) - 1
    aroundView?.distanceSlider
      .slider
      .value = sliderValue
    
    // 현재 동네 이름 설정
    aroundView?.townCountView.myTownLabel.text = secondTown.locate.dong
    
    // 근처 동네 개수 설정
    let filtered = manager.secondAroundTown
      .filter { ($0.distance ?? 0) <= 1_200 * (Double(sliderValue) + 1) }
    let townCount = NSMutableAttributedString()
      .underlineBold(
        "근처 동네 \(filtered.count)개",
        fontSize: 17
    )
    let countView = self.superview?
      .subviews
      .compactMap { $0 as? MyTownAroundView }
      .first?
      .townCountView
      
    countView?.aroundTownCountBtn
      .setAttributedTitle(townCount, for: .normal)
    countView?.aroundTowns = filtered
    
    // Activate 상태 설정
    manager.updateFirstTown(activated: false)
    manager.updateSecondTown(activated: true)
  }
  
  @objc func hidePlusImage() {
    secondTownSelectBtn.setImage(UIImage(), for: .normal)
  }
  
  func changeBtnColor(_ sender: UIButton) {
    self.firstTownSelectBtn.isSelected = sender is FirstTownSelectButton
    self.secondTownSelectBtn.isSelected = sender is SecondTownSelectButton
//    switch sender {
//    case firstTownSelectBtn:
//      changeSelectedTownBtnColor(firstTownSelectBtn)
//      changeUnSelectedTownBtnColor(secondTownSelectBtn)
//    case secondTownSelectBtn:
//      if !MyTownSetting.shared.secondSelectTown.isEmpty {
//        changeSelectedTownBtnColor(secondTownSelectBtn)
//        changeUnSelectedTownBtnColor(firstTownSelectBtn)
//      }
//    default: break
//    }
  }
  
  private func willDisplayUpperAlert(_ selectButton: MyTownSetting.UpperAlerCallBtn) {
    let dong: String
    switch selectButton {
    case .firstBtn:
      dong = AuthorizationManager.shared.firstTown?.locate.dong ?? "unknown"
    case .secondBtn:
      dong = AuthorizationManager.shared.secondTown?.locate.dong ?? "unknown"
    }
    upperAlert.show(message: "\(dong)으로 설정되었습니다.")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
