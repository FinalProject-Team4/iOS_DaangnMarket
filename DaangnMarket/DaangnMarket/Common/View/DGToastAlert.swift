//
//  DGToastAlert.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/26.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class DGToastAlert: UIView {
  // MARK: Views
  
  private let titleLabel = UILabel().then {
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 16)
    $0.textAlignment = .center
  }
  
  // MARK: Initialize
  
  init(message: String) {
    super.init(frame: .zero)
    self.setupUI(message: message)
  }
  
  private func setupUI(message: String) {
    self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    self.layer.cornerRadius = 10
    self.titleLabel.text = message
    self.alpha = 0
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    self.titleLabel
      .then { self.addSubview($0) }
      .snp
      .makeConstraints {
        $0.edges
          .equalToSuperview()
          .inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
  }
  
  // MARK: Interface
  
  enum AlertPosition {
    case center, bottom
  }
  func show(at position: AlertPosition, from view: UIView) {
    self
      .then { view.addSubview($0) }
      .snp.makeConstraints {
        switch position {
        case .center:
          $0.center.equalToSuperview()
        case .bottom:
          $0.centerX.equalToSuperview()
          $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    UIView.animate(withDuration: 0.3) {
      self.alpha = 1
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      UIView.animate(withDuration: 0.3) {
        self.alpha = 0
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
