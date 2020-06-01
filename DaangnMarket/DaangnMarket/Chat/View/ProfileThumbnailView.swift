//
//  ProfileView.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/18.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ProfileThumbnailView: UIView {
  // MARK: Interface
  
  var profileImage: UIImage? {
    get { return self.profileImageView.image }
    set {
      self.profileImageView.image = newValue ?? UIImage(named: ImageReference.profileDefault.rawValue)
    }
  }
  
  var badgeImage: UIImage? {
    get { return self.badgeImageView.image }
    set { self.badgeImageView.image = newValue }
  }
  
  // MARK: Views
  
  private let profileImageView = UIImageView().then {
    $0.clipsToBounds = true
  }
  private let badgeImageView = UIImageView().then {
    $0.clipsToBounds = true
  }
  
  // MARK: Life Cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    [self.profileImageView, self.badgeImageView].forEach {
      $0.layer.cornerRadius = $0.frame.width / 2
    }
  }
  
  // MARK: Initialize
  
  private func setupConstraints() {
    let profileScale: CGFloat = 12.0 / 13.0
    let badgeScale: CGFloat = 5.0 / 13.0
    
    self.profileImageView
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.equalToSuperview()
        $0.width
          .equalToSuperview()
          .multipliedBy(profileScale)
        $0.height.equalTo(self.profileImageView.snp.width)
    }
    
    self.badgeImageView
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.trailing.bottom.equalToSuperview()
        $0.width
          .equalToSuperview()
          .multipliedBy(badgeScale)
        $0.height.equalTo(self.badgeImageView.snp.width)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
