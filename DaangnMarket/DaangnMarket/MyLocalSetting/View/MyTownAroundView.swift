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
 

  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupConstraint()
  }
  
  private func setupConstraint() {
    let viewSubUI = [townCountView, descriptionLabel, distanceSlider, sliderLeftLabel, sliderRightLabel]
    viewSubUI.forEach { self.addSubview($0) }
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
      $0.top.equalTo(distanceSlider.snp.bottom).offset(10)
      $0.leading.equalTo(distanceSlider.snp.leading)
    }
    sliderRightLabel.snp.makeConstraints {
      $0.top.equalTo(distanceSlider.snp.bottom).offset(10)
      $0.trailing.equalTo(distanceSlider.snp.trailing)
    }
  }
  
  // MARK: Action
  
  @objc private func slideAction(_ sender: UISlider) {
    let aroundTownCount = AuthorizationManager.shared.aroundTown.filter { Float($0.distance!/1_200) <= sender.value.rounded() }
    MyTownSetting.shared.numberOfAroundFirstTownByDistance = aroundTownCount
    NotificationCenter.default.post(
      name: NSNotification.Name("AroundTownCountView"),
      object: nil
    )
    print("slide value", sender.value)
    print("change num of town when slide action", MyTownSetting.shared.numberOfAroundFirstTownByDistance.count)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
