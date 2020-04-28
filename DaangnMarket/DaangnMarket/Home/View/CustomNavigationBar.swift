//
//  CustomNavigationBar.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/09.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
protocol NavigationBarButtonDelegate: class {
  func navigationBarButton(_ naviBarButton: UIButton)
}

class CutomNavigationBar: UIView {
  weak var delegate: NavigationBarButtonDelegate?
  
  // MARK: Views
  
  let selectedTownButton = UIButton().then {
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    $0.addTarget(self, action: #selector(didTapButtonsInNaviBar(_:)), for: .touchUpInside)
  }
  let selectedTownArrowImage = UIImageView().then {
    $0.frame.size = CGSize(width: 5, height: 5)
    $0.image = UIImage(systemName: "chevron.down")
    $0.transform = .init(scaleX: 0.7, y: 0.7)
    $0.tintColor = .black
  }
  let searchButton = UIButton(type: .system).then {
    $0.frame.size = CGSize(width: 22, height: 22)
    $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
    $0.tintColor = .black
    $0.restorationIdentifier = "magnifyingglass"
    $0.addTarget(self, action: #selector(didTapButtonsInNaviBar(_:)), for: .touchUpInside)
  }
  let categoryFilterButton = UIButton(type: .system).then {
    $0.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
    $0.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
    $0.tintColor = .black
    $0.addTarget(self, action: #selector(didTapButtonsInNaviBar(_:)), for: .touchUpInside)
  }
  let notificationButton = UIButton(type: .system).then {
    $0.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
    $0.setImage(UIImage(systemName: "bell"), for: .normal)
    $0.tintColor = .black
    $0.addTarget(self, action: #selector(didTapButtonsInNaviBar(_:)), for: .touchUpInside)
    NotificationTrigger.default.notiButton = $0
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupConstraints()
  }
  
  private func setupConstraints() {
    let naviBarItems = [selectedTownArrowImage, selectedTownButton, notificationButton, categoryFilterButton, searchButton]
    naviBarItems.forEach { self.addSubview($0) }
    selectedTownButton.snp.makeConstraints {
      $0.leading.equalTo(self).offset(15)
      $0.bottom.equalTo(self).offset(-5)
    }
    selectedTownArrowImage.snp.makeConstraints {
      $0.centerY.equalTo(selectedTownButton)
      $0.leading.equalTo(selectedTownButton.snp.trailing).offset(5)
    }
    notificationButton.snp.makeConstraints {
      $0.centerY.equalTo(selectedTownButton)
      $0.trailing.equalTo(self).offset(-15)
    }
    categoryFilterButton.snp.makeConstraints {
      $0.centerY.equalTo(selectedTownButton)
      $0.trailing.equalTo(notificationButton.snp.leading).offset(-15)
    }
    searchButton.snp.makeConstraints {
      $0.centerY.equalTo(selectedTownButton)
      $0.trailing.equalTo(categoryFilterButton.snp.leading).offset(-15)
    }
  }
  
  // MARK: Action
  
  @objc private func didTapButtonsInNaviBar(_ naviBarButton: UIButton) {
    self.delegate?.navigationBarButton(naviBarButton)
  }
  
  @objc private func didReceiveNotificationResponse() {
    self.delegate?.navigationBarButton(self.notificationButton)
  }
  
  override func draw(_ rect: CGRect) {
    // Draw Underbar
    UIBezierPath().do {
      $0.lineWidth = 0.3
      $0.move(to: CGPoint(x: rect.minX, y: rect.maxY))
      $0.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
      $0.close()
      UIColor(named: ColorReference.borderLine.rawValue)?.setStroke()
      $0.stroke()
    }
  }
  
  required init?(coder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
   }
}
