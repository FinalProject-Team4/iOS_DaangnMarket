//
//  WriteTableTitleCell.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/03/25.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

// MARK: - Class Level

class WriteTableTitleCell: UITableViewCell {
  static let cellID = "WriteTableTitleCell"
  
  // MARK: Views
  
  private lazy var titleTextView = UITextView().then {
    $0.delegate = self
    $0.isScrollEnabled = false
    $0.sizeToFit()
    $0.font = .systemFont(ofSize: 16)
  }
  
  private let placeholderLabel = UILabel().then {
    $0.text = "글 제목"
    $0.textColor = .lightGray
    $0.font = .systemFont(ofSize: 16)
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
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    self.backgroundColor = .white
    contentView.addSubview(titleTextView)
    contentView.addSubview(placeholderLabel)
  }
  
  private func setupConstraints() {
    titleTextView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalToSuperview().offset(-24)
    }
    placeholderLabel.snp.makeConstraints {
      $0.leading.equalTo(titleTextView).offset(4)
      $0.centerY.equalTo(titleTextView)
    }
  }
  
  // MARK: Interface
  
  var cellData: String {
    return self.titleTextView.text
  }
}

// MARK: - Extension Level

extension WriteTableTitleCell: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    if !textView.text.isEmpty {
      placeholderLabel.isHidden = true
    } else {
      placeholderLabel.isHidden = false
    }
    
    UIView.setAnimationsEnabled(false)
    self.tableView?.beginUpdates()
    self.tableView?.endUpdates()
    UIView.setAnimationsEnabled(true)
  }
}

