//
//  KeywordCollectionViewCell.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class KeywordCollectionViewCell: UICollectionViewCell {
  static let cellID = "KeywordCollectionViewCell"
  
  private let view = UIView().then {
    $0.backgroundColor = .white
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor(named: ColorReference.borderLine.rawValue)?.cgColor
    $0.layer.cornerRadius = 16
  }
  
  private let label = UILabel().then {
    $0.font = .systemFont(ofSize: 13)
    $0.textColor = .black
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.addSubview(view)
    view.addSubview(label)
    
    view.snp.makeConstraints {
      $0.edges.size.equalToSuperview()
    }
    label.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14))
    }
  }
  
  // MARK: Interface
  func configure(text: String) {
    label.text = text
  }
}

