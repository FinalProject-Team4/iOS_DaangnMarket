//
//  ProfileImageView.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/05.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ProfileImageView: UIView {
  // MARK: Interface
  
  func addTarget(_ target: Any?, action: Selector) {
    self.selectButton.addTarget(target, action: action, for: .touchUpInside)
  }
  
  // MARK: Views
  
  private let imageView = UIImageView(named: ImageReference.profileDefault.rawValue).then {
    $0.contentMode = .scaleAspectFit
    $0.tintColor = UIColor(white: 0.9, alpha: 1)
    $0.clipsToBounds = true
    $0.backgroundColor = UIColor(white: 0.8, alpha: 1)
  }
  private let selectButton = UIButton().then {
    $0.setImage(UIImage(systemName: ImageReference.camera.rawValue), for: .normal)
    $0.tintColor = UIColor(named: ColorReference.item.rawValue)
    $0.backgroundColor = .white
    $0.clipsToBounds = true
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor(named: ColorReference.borderLine.rawValue)?.cgColor
  }
  
  // MARK: Life Cycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
    self.selectButton.layer.cornerRadius = self.selectButton.frame.width / 2
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    let profileSize: CGFloat = 130
    
    self.snp.makeConstraints {
      $0.size.equalTo(profileSize)
    }
    
    self.imageView
      .then { self.addSubview($0) }
      .snp.makeConstraints { $0.edges.equalToSuperview() }
    
    self.selectButton
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.trailing.bottom.equalTo(self.imageView)
        $0.size.equalTo(32)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
