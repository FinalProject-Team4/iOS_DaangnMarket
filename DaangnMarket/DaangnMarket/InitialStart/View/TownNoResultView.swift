//
//  TownNoResultView.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/26.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class TownNoResultView: UIView {
  // MARK: Views
  
  private let imageView = UIImageView(systemName: ImageReference.searchNoResult.rawValue).then {
    $0.tintColor = UIColor(named: ColorReference.noResultImage.rawValue)
  }
  private let titleLabel = UILabel().then {
    $0.text = "검색 결과가 없습니당.\n동네 이름을 다시 확인해 주세요!"
    $0.textColor = UIColor(named: ColorReference.item.rawValue)
    $0.textAlignment = .center
    $0.numberOfLines = 2
    $0.font = .systemFont(ofSize: 17)
  }
  private let searchButton = UIButton().then {
    $0.setTitle("동네 이름 다시 검색하기", for: .normal)
    $0.setTitleColor(UIColor(named: ColorReference.daangnMain.rawValue), for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    self.imageView
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalToSuperview()
        $0.centerX.equalToSuperview()
        $0.size.equalTo(56)
    }
    self.titleLabel
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self.imageView.snp.bottom).offset(8)
        $0.leading.trailing.equalToSuperview()
    }
    self.searchButton
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self.titleLabel.snp.bottom).offset(16)
        $0.centerX.equalTo(self.titleLabel)
        $0.bottom.equalToSuperview()
    }
  }
  
  // MARK: Interface
  
  func addTarget(_ target: Any?, action: Selector) {
    self.searchButton.addTarget(target, action: action, for: .touchUpInside)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
