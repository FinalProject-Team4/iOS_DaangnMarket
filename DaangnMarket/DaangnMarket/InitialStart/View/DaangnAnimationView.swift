//
//  DaangnAnimationView.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class DaangnAnimationView: UIView {
  // MARK: Views

  private let mainImageView = UIImageView(named: ImageReference.daangnMain.rawValue).then {
    $0.contentMode = .scaleAspectFit
  }
  private let animatingCircles: [UIView] = (0...2).map { _ in
    return UIView().then {
      $0.alpha = 0
      $0.backgroundColor = .orange
    }
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupUI()
  }
  
  private func setupUI() {
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    self.mainImageView
      .then { self.addSubview($0) }
      .snp
      .makeConstraints {
        $0.edges.equalToSuperview()
      }
    self.animatingCircles.forEach { circle in
      circle
        .then { self.addSubview($0) }
        .snp
        .makeConstraints {
          $0.centerX.equalToSuperview()
          $0.centerY.equalToSuperview().offset(55)
          $0.size.equalTo(self.snp.width).multipliedBy(0.08)
        }
    }
  }
  
  // MARK: Life Cycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.animatingCircles.forEach {
      $0.layer.cornerRadius = self.frame.width * 0.08 / 2
    }
  }
  
  // MARK: Methods
  
  func animate() {
    let durationTime = 4.0
    let beforeScale: CGFloat = 2
    let afterScale: CGFloat = 7
    
    let circle1 = animatingCircles[0]
    let circle2 = animatingCircles[1]
    let circle3 = animatingCircles[2]
    UIView.animateKeyframes(
      withDuration: durationTime,
      delay: 0.0,
      options: [.repeat],
      animations: {
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
          circle1.alpha = 0.5
          circle1.transform = .init(scaleX: beforeScale, y: beforeScale)
        }
        UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.6) {
          circle1.alpha = 0.0
          circle1.transform = .init(scaleX: afterScale, y: afterScale)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.55) {
          circle2.alpha = 0.5
          circle2.transform = .init(scaleX: beforeScale, y: beforeScale)
        }
        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.85) {
          circle2.alpha = 0.0
          circle2.transform = .init(scaleX: afterScale, y: afterScale)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.8) {
          circle3.alpha = 0.5
          circle3.transform = .init(scaleX: beforeScale, y: beforeScale)
        }
        UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 1.1) {
          circle3.alpha = 0.0
          circle3.transform = .init(scaleX: afterScale, y: afterScale)
        }
    }) { _ in
      UIView.animate(withDuration: 1.0) {
        circle1.transform = .identity
        circle2.transform = .identity
        circle3.transform = .identity
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
