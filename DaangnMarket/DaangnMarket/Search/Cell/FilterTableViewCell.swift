//
//  FilterTableViewCell.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/17.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
  private let headerView = UIView().then {
    $0.backgroundColor = .white
  }
  
  private let searchFilterButton = UIButton().then {
    $0.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
    $0.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
    $0.tintColor = .black
    $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
    $0.setTitle("검색 필터", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 13)
  }
  
  private let soldoutFilterButton = UIButton().then {
    $0.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
    $0.tintColor = .gray
    $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
    $0.setTitle("거래완료 안보기", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 13)
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
    contentView.backgroundColor = .red
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    self.isUserInteractionEnabled = false
    contentView.addSubview(headerView)
    headerView.addSubview(searchFilterButton)
    headerView.addSubview(soldoutFilterButton)
  }
  
  private func setupConstraints() {
    headerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    searchFilterButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8)
      $0.bottom.equalToSuperview().offset(-8)
      $0.leading.equalToSuperview().offset(14)
    }
    soldoutFilterButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8)
      $0.bottom.equalToSuperview().offset(-8)
      $0.trailing.equalToSuperview().offset(-14)
    }
  }
}
