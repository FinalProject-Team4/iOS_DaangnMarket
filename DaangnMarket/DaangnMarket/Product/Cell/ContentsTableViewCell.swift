//
//  ContentsTableViewCell.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/03.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ContentsTableViewCell: UITableViewCell {
  static let indentifier = "ContentsTableCell"
  
  // MARK: Views
  
  private let titleLabel = UILabel().then {
    $0.font = UIFont.boldSystemFont(ofSize: 20)
    $0.textColor = .black
  }
  private let informLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 13)
    $0.textColor = .gray
  }
  private let contentsLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 16)
    $0.textColor = .black
    $0.numberOfLines = 0
  }
  private let countLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 13)
    $0.textColor = .gray
  }
  private let bottomLineView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  
  // MARK: Initialize
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupConstraints()
  }
  
  private func setupConstraints() {
    let spacing: CGFloat = 16
    self.titleLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self).offset(spacing * 1.5)
        $0.leading.trailing.equalTo(self).inset(spacing)
    }
    self.informLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(titleLabel.snp.bottom).offset(spacing)
        $0.leading.equalTo(titleLabel)
    }
    self.contentsLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(informLabel.snp.bottom).offset(spacing)
        $0.leading.equalTo(titleLabel)
        $0.trailing.equalTo(self).offset(-spacing)
    }
    self.countLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(contentsLabel.snp.bottom).offset(spacing)
        $0.leading.equalTo(titleLabel)
        $0.bottom.equalTo(self).offset(-spacing / 2)
    }
    self.bottomLineView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.height.equalTo(0.3)
        $0.width.equalTo(self).offset(-spacing * 2)
        $0.centerX.equalTo(self)
        $0.bottom.equalTo(self)
    }
  }
  
  // MARK: Interface
  
  func configure(contentsData: Post) {
    titleLabel.text = contentsData.title
    informLabel.text = "\(PostData.shared.calculateDifferentTime(updated: contentsData.created))﹒\(contentsData.category)"
    contentsLabel.text = contentsData.content
    countLabel.text = "관심 \(contentsData.likes)﹒조회 \(contentsData.viewCount)"
  }
}
