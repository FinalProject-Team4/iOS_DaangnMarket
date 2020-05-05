//
//  MyProfileImageButton.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class MyProfileImageButton: UIButton {
  // MARK: Views
  
  var profileImageView = UIImageView().then {
    $0.layer.cornerRadius = 32
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
  }
  let cameraImage = UIButton().then {
    $0.setImage(UIImage(systemName: "camera.fill"), for: .normal)
    $0.layer.borderColor = UIColor.lightGray.cgColor
    $0.layer.borderWidth = 1
    $0.tintColor = .gray
    $0.backgroundColor = UIColor.white.withAlphaComponent(0.7)
    $0.layer.cornerRadius = 12
    $0.imageEdgeInsets = UIEdgeInsets(top: 3, left: 2, bottom: 7, right: 3)
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    profileImageView.image = UIImage(named: "sellerImage1")
  }
  
  private func setupConstraints() {
    let imageSize: CGFloat = 64
    let cameraSize: CGFloat = 24
    
    self.profileImageView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.width.height.equalTo(imageSize)
        $0.top.leading.trailing.bottom.equalToSuperview()
    }
    self.cameraImage.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.trailing.bottom.equalToSuperview()
        $0.width.height.equalTo(cameraSize)
    }
  }
}
