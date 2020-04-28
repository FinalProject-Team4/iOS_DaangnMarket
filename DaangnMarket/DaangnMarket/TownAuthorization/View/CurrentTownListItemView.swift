//
//  CurrentTownListItemView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class CurrentTownListItemView: UIControl {
  // MARK: Interface
  func didSelectItem () {
    imageView.image = UIImage(systemName: "checkmark.circle.fill")
    imageView.tintColor = UIColor(named: ColorReference.daangnMain.rawValue)
  }
  func didDeSelectItem() {
    imageView.image = UIImage(systemName: "checkmark.circle")
    imageView.tintColor = .lightGray
  }

  
  // MARK: Views
  private let imageView = UIImageView().then {
    $0.image = UIImage(systemName: "checkmark.circle")
    $0.tintColor = .lightGray
    $0.transform = .init(scaleX: 1.2, y: 1.2)
  }
  
  private let label = UILabel().then {
    $0.font = .systemFont(ofSize: 16)
  }
  
  init(_ item: String) {
    super.init(frame: .zero)
    label.text = item
    setupUI()
  }
  
  private func setupUI() {
    self.backgroundColor = .white
    self.addSubview(imageView)
    self.addSubview(label)
    imageView.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview()
      $0.size.equalTo(24)
    }
    label.snp.makeConstraints {
      $0.leading.equalTo(imageView.snp.trailing).offset(16)
      $0.centerY.equalTo(imageView)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
