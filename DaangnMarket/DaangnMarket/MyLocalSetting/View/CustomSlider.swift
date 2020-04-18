//
//  CustomSlider.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/13.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class SliderView: UIView {
  var slider = CustomSlider().then {
    $0.minimumValue = 0.0
    $0.maximumValue = 3.0
    $0.minimumTrackTintColor = UIColor(named: ColorReference.daangnMain.rawValue)
    $0.maximumTrackTintColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  
  func addTarget(_ target: Any?, action: Selector) {
    slider.addTarget(target, action: action, for: .valueChanged)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.slider
      .then { self.addSubview($0) }
      .snp.makeConstraints { $0.edges.equalToSuperview() }
    let track = self.slider.trackRect(forBounds: self.slider.bounds)
    UIView()
      .then {
        self.addSubview($0)
        $0.backgroundColor = .white
      }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.slider)
          .offset(track.minY)
        $0.centerX.equalTo(track.width / 3)
        $0.width.equalTo(1)
        $0.height.equalTo(track.height)
      }
    UIView()
      .then {
        self.addSubview($0)
        $0.backgroundColor = .white
      }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.slider)
          .offset(track.minY)
        $0.centerX.equalTo(track.width * 2 / 3)
        $0.width.equalTo(1)
        $0.height.equalTo(track.height)
    }
  }
}

class CustomSlider: UISlider {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.isContinuous = false
  }
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    guard let point = touches.first?.location(in: self) else { return }
    let value = point.x / self.frame.width * 3
    UIView.animate(
      withDuration: 0.3,
      delay: 0,
      usingSpringWithDamping: 0.5,
      initialSpringVelocity: 0,
      options: [.curveLinear],
      animations: {
        self.value = Float(value.rounded())
        self.layoutIfNeeded() },
      completion: nil
    )
    MyTownSettingViewController.calculateNumberOfAourndTown(MyTownSetting.shared.isFirstTown, self.value)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func trackRect(forBounds bounds: CGRect) -> CGRect {
    return .init(x: 0, y: 0, width: 325, height: 12)
  }
}
