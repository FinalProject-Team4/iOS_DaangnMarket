//
//  NoResultOfPersonView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class NoResultOfPersonView: UIView {
  private let label = UILabel().then {
      $0.text = "검색 결과가 없습니다."
      $0.textColor = .gray
      $0.font = .systemFont(ofSize: 16)
    }
    
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
      self.backgroundColor = UIColor(named: ColorReference.lightBackground.rawValue)
      self.addSubview(label)
    }
    
    private func setupConstraints() {
      label.snp.makeConstraints {
        $0.center.equalToSuperview()
      }
    }
  }
