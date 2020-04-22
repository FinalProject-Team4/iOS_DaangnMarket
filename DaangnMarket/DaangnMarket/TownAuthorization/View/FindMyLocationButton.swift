//
//  FindMyLocationButton.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class FindMyLocationButton: UIButton {
  private let scopeImageView = UIImageView().then {
    $0.image = UIImage(named: ImageReference.scope.rawValue)
    $0.backgroundColor = .white
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    self.backgroundColor = .white
    self.addSubview(scopeImageView)
    scopeImageView.snp.makeConstraints {
      $0.size.equalTo(24)
      $0.center.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
