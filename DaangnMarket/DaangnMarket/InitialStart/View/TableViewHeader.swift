//
//  TableViewHeader.swift
//  200320_teamHackerThon
//
//  Created by Demian on 2020/03/22.
//  Copyright © 2020 Demian. All rights reserved.
//

import UIKit

class TownHeaderView: UITableViewHeaderFooterView {
  // MARK: Views
  
  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 13)
    $0.textColor = UIColor(named: ColorReference.item.rawValue)
  }
  
  // MARK: Initialize
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    self.setupUI()
  }
  
  private func setupUI() {
    self.contentView.backgroundColor = .systemBackground
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    self.titleLabel
      .then { self.contentView.addSubview($0) }
      .snp
      .makeConstraints {
        $0.centerY.equalToSuperview()
        $0.leading.equalToSuperview().offset(16)
      }
  }
  
  // MARK: Interface
  
  func update(title: String) {
    self.titleLabel.text = title
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
