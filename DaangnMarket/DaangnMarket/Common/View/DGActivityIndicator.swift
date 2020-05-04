//
//  DGActivityIndicator.swift
//  DaangnMarket
//
//  Created by cskim on 2020/05/04.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class DGActivityIndicator: UIView {
  // MARK: Interface
  
  func startAnimating() {
    self.isHidden = false
    self.activityIndicator.startAnimating()
  }
  
  func stopAnimating() {
    self.isHidden = true
    self.activityIndicator.stopAnimating()
  }
  
  // MARK: Views
  
  private let activityIndicator = UIActivityIndicatorView(style: .large).then {
    $0.hidesWhenStopped = false
    $0.color = .white
  }
  
  // MARK: Life Cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.isHidden = true
    self.layer.cornerRadius = 4
    self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    self.snp.makeConstraints {
      $0.size.equalTo(77)
    }
    
    self.activityIndicator
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.center.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
