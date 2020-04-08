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
  var distanceSlider = CustomSlider().then {
    $0.minimumValue = 0.0
    $0.maximumValue = 3.0
    $0.minimumTrackTintColor = UIColor(named: ColorReference.daangnMain.rawValue)
    $0.maximumTrackTintColor = UIColor(named: ColorReference.borderLine.rawValue)
    $0.addTarget(self, action: #selector(slideAction(_:)), for: .valueChanged)
  }
  var sliderLeftLabel = UILabel().then {
    $0.text = "내동네"
    $0.font = .systemFont(ofSize: 12)
  }
  var sliderRightLabel = UILabel().then {
    $0.text = "근처동네"
    $0.font = .systemFont(ofSize: 12)
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
//      $0.trailing.equalToSuperview().offset(-25)
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
    MyTownSetting.shared.numberOfAroundTown = Int(sender.value)
    townCountView.aroundTownCountLabel.attributedText = NSMutableAttributedString().underlineBold("근처 동네 \(Int(sender.value))개", fontSize: 17)
//    MyTownSetting.shared.numberOfAroundTown = AuthorizationManager.shared.address.count
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class CustomSlider: UISlider {
  override func trackRect(forBounds bounds: CGRect) -> CGRect {
    return .init(x: 0, y: 0, width: 325, height: 12)
  }
}
