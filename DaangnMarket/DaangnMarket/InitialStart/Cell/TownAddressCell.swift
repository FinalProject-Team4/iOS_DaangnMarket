//
//  TownAddressCell.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/25.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class TownAddressCell: UITableViewCell {
  // MARK: Views
  
  private let addressLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 15)
  }
  private let disclosureIndicator = UIImageView(systemName: ImageReference.arrowChevronRight.rawValue).then {
    $0.contentMode = .scaleAspectFit
    $0.tintColor = UIColor(named: ColorReference.item.rawValue)
  }
  
  // MARK: Initialize
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    let paddingX: CGFloat = 16
    let paddingY: CGFloat = 24
    
    self.addressLabel
      .then { self.contentView.addSubview($0) }
      .snp
      .makeConstraints {
        $0.top.leading.bottom
          .equalToSuperview()
          .inset(UIEdgeInsets(top: paddingY, left: paddingX, bottom: paddingY, right: 0))
    }
    self.disclosureIndicator
      .then { self.contentView.addSubview($0) }
      .snp
      .makeConstraints {
        $0.centerY.equalTo(self.addressLabel)
        $0.trailing.equalToSuperview().offset(-paddingX)
        $0.size.equalTo(CGSize(width: 6, height: 10))
    }
  }
  
  // MARK: Interface
  
  func update(address: String) {
    self.addressLabel.text = address
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
