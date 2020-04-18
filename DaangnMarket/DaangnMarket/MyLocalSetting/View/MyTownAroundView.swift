//
//  AroundMyTownView.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class MyTownAroundView: UIView {
  // MARK: UIViews
  
  let townCountView = TownCountView().then {
    $0.backgroundColor = .yellow
  }
  var descriptionLabel = UILabel().then {
    $0.textColor = UIColor(named: ColorReference.noResultImage.rawValue)
    $0.text = "선택한 동네의 이웃들만 피드에서 이 게시글을 볼 수 있어요."
    $0.font = .systemFont(ofSize: 13)
  }
  var distanceSlider = SliderView().then {
    $0.addTarget(self, action: #selector(slideAction(_:)))
  }
  var sliderLeftLabel = UILabel().then {
    $0.text = "내동네"
    $0.font = .systemFont(ofSize: 12)
  }
  var sliderRightLabel = UILabel().then {
    $0.text = "근처동네"
    $0.font = .systemFont(ofSize: 12)
  }
  let sliderFirstPartView = UIView().then {
    $0.backgroundColor = .white
  }
  let sliderSecondPartView = UIView().then {
    $0.backgroundColor = .white
  }
  let zeroStepTownImageView = UIImageView().then {
    $0.image = UIImage(named: "zeroStep")
    $0.alpha = 1.0
  }
  let firstStepTownImageView = UIImageView().then {
    $0.image = UIImage(named: "firstStep")
    $0.alpha = 0.0
  }
  let secondStepTownImageView = UIImageView().then {
    $0.image = UIImage(named: "secondStep")
    $0.alpha = 0.0
  }
  let thirdStepTownImageView = UIImageView().then {
    $0.image = UIImage(named: "thirdStep")
    $0.alpha = 0.0
  }

  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupConstraint()
    thumbPositionNoti()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(
      self,
      name: NSNotification.Name("AroundTownCountView"),
      object: nil
    )
  }
  
  private func setupConstraint() {
    let viewSubUI = [townCountView, descriptionLabel, distanceSlider, sliderLeftLabel, sliderRightLabel]
    let aroundTownImgaese = [zeroStepTownImageView, firstStepTownImageView, secondStepTownImageView, thirdStepTownImageView]
    viewSubUI.forEach { self.addSubview($0) }
    aroundTownImgaese.forEach { self.addSubview($0) }
    townCountView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(26)
      $0.height.equalTo(20)
    }
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(townCountView.snp.bottom).offset(9)
      $0.centerX.equalTo(self)
    }
    distanceSlider.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(26)
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(25)
      $0.height.equalTo(32)
    }
    sliderLeftLabel.snp.makeConstraints {
      $0.top.equalTo(distanceSlider.snp.bottom).offset(8)
      $0.leading.equalTo(distanceSlider.snp.leading)
      $0.bottom.equalToSuperview().offset(-296)
    }
    sliderRightLabel.snp.makeConstraints {
      $0.top.equalTo(distanceSlider.snp.bottom).offset(8)
      $0.trailing.equalTo(distanceSlider.snp.trailing)
      $0.bottom.equalToSuperview().offset(-296)
    }
    zeroStepTownImageView.snp.makeConstraints {
      $0.top.equalTo(sliderLeftLabel.snp.bottom).offset(15)
      $0.width.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-32)
    }
    firstStepTownImageView.snp.makeConstraints {
      $0.top.equalTo(sliderLeftLabel.snp.bottom).offset(15)
      $0.width.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-32)
    }
    secondStepTownImageView.snp.makeConstraints {
      $0.top.equalTo(sliderLeftLabel.snp.bottom).offset(15)
      $0.width.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-32)
    }
    thirdStepTownImageView.snp.makeConstraints {
      $0.top.equalTo(sliderLeftLabel.snp.bottom).offset(15)
      $0.width.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-32)
    }
  }
  
  // MARK: Notification
  
  private func thumbPositionNoti() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(thumbPositionOnSlide(_:)),
      name: NSNotification.Name("AroundTownCountView"),
      object: nil
    )
  }
  
  private func changeImgaesAlpha(_ sender: UISlider) {
    if sender.value <= 1.0 {
      zeroStepTownImageView.alpha = CGFloat(1.0 - sender.value)
      firstStepTownImageView.alpha = CGFloat(sender.value)
    } else if sender.value <= 2.0 {
      firstStepTownImageView.alpha = CGFloat(2.0 - sender.value)
      secondStepTownImageView.alpha = CGFloat(sender.value - 1.0)
    } else if sender.value <= 3.0 {
      secondStepTownImageView.alpha = CGFloat(3.0 - sender.value)
      thirdStepTownImageView.alpha = CGFloat(sender.value - 2.0)
    }
  }
  
  // MARK: Action
  
  @objc private func slideAction(_ sender: UISlider) {
    MyTownSettingViewController.calculateNumberOfAourndTown(MyTownSetting.shared.isFirstTown, sender.value)
    changeImgaesAlpha(sender)
  }
  @objc private func thumbPositionOnSlide(_ sender: Notification) {
    guard let userInfo = sender.userInfo,
      let thumbPosition = userInfo["SingleTon"] as? MyTownSetting else { return }
    print("first town thumb position", thumbPosition.numberOfAroundTownByFirst.1)
    print("second town thumb position", thumbPosition.numberOfAroundTownBySecond.1)
    switch thumbPosition.isFirstTown {
    case true:
      distanceSlider.slider.value = Float(thumbPosition.numberOfAroundTownByFirst.1)
    case false:
      distanceSlider.slider.value = Float(thumbPosition.numberOfAroundTownBySecond.1)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
