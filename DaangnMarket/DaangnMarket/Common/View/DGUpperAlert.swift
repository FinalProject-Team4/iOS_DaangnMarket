//
//  DGUpperAlert.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/02.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

/**
  상단에서 내려오는 검은색 알림창
 
  UIWindow에 추가되는 Alert이므로 인스턴스를 프로퍼티로 만들 경우 반드시 지연 저장 프로퍼티로 생성해야 한다.
  ````
  class SomeClass {
    lazy var upperAlert = DGUpperAlert(type: .requestCodeSuccess)
  }
  ````
 */
class DGUpperAlert: UIView {
  // MARK: Views
  
  private let titleLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 16, weight: .bold)
    $0.adjustsFontSizeToFitWidth = true
  }
  private var currentWindow: UIView {
    return (UIApplication.shared.delegate as? AppDelegate)?.window ?? UIView()
  }
  
  // MARK: Properties
  
  private var alertHeight: CGFloat {
    return UINavigationBar.statusBarSize.height + 68
  }
  
  // MARK: Initialize
  
  init() {
    super.init(frame: .zero)
    self.setupUI()
  }
  
  private func setupUI() {
    self.backgroundColor = UIColor(named: ColorReference.upperAlert.rawValue)
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    self
      .then { self.currentWindow.addSubview($0) }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.currentWindow)
          .offset(-alertHeight)
        $0.centerX.equalTo(self.currentWindow)
        $0.width.equalTo(self.currentWindow.frame.width)
        $0.height.equalTo(alertHeight)
    }
    
    let margin: CGFloat = 24
    self.titleLabel
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.trailing
          .equalToSuperview()
          .inset(
            UIEdgeInsets(
              top: UINavigationBar.statusBarSize.height + margin,
              left: margin,
              bottom: 0,
              right: margin
            )
        )
    }
  }
  
  // MARK: Interface
  
  private var isShowing = false
  private var alerts = [String]()
  private var repeatCount = 0
  
  /// Present alert
  ///
  /// 여러 번 호출하게 되면 evnet가 누적되어 하나의 알림창이 끝날 때 까지 기다렸다가 다음 알림창을 순차적으로 실행한다.
  func show(message: String) {
    if !self.isShowing {
      self.titleLabel.text = message
      self.isShowing = true

      UIView.animate(withDuration: 0.3) {
        self.transform = .init(translationX: 0, y: self.alertHeight)
      }
//      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // default
        UIView.animate(
          withDuration: 0.3,
          animations: {
            self.transform = .identity
        }) { (_) in
          self.isShowing = false
          if !self.alerts.isEmpty {
            self.show(message: self.alerts.removeFirst())
          }
        }
      }
    } else {
      self.alerts.append(message)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
