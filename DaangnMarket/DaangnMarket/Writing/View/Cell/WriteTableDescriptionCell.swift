//
//  WriteTableDescriptionCell.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/03/25.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

// MARK: - Class Level
class WriteTableDescriptionCell: UITableViewCell {
  static let cellID = "WriteTableDescriptionCell"
  
  // MARK: Views
  
  private lazy var bodyTextView = UITextView().then {
    $0.delegate = self
    $0.isScrollEnabled = false
    $0.sizeToFit()
    $0.font = .systemFont(ofSize: 16)
  }
  
  private lazy var placeholderLabel = UILabel().then {
    $0.text = "\(location)에 올릴 게시글 내용을 작성해주세요.(가품 및 판매금지품목은 게시가 제한될 수 있어요.)"
    $0.numberOfLines = 0
    let attrString = NSMutableAttributedString(string: $0.text!)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 6
    attrString.addAttribute(
      NSAttributedString.Key.paragraphStyle,
      value: paragraphStyle,
      range: NSRange(location: 0, length: attrString.length)
//      NSMakeRange(_: 0, _: attrString.length)
    )
    $0.attributedText = attrString
    $0.font = .systemFont(ofSize: 16)
    $0.textColor = .lightGray
  }
  
  // MARK: Properties
  
  var keyboardHeight: CGFloat = 0
  private var location = AuthorizationManager.shared.firstTown?.locate.dong ?? "unknown"
  
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
    contentView.addSubview(bodyTextView)
    contentView.addSubview(placeholderLabel)
  }
  
  private func setupConstraints() {
    bodyTextView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalToSuperview().offset(-24)
    }
    placeholderLabel.snp.makeConstraints {
      $0.edges.equalTo(bodyTextView)
        .inset(UIEdgeInsets(top: 8, left: 4, bottom: -4, right: 0))
    }
  }
  
  // MARK: Interface
  
  var cellData: String {
    return self.bodyTextView.text
  }
}

// MARK: - Extension Level
extension WriteTableDescriptionCell: UITextViewDelegate {
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    self.tableView?.contentOffset.y = UIScreen.main.bounds.height * 0.4

    UIView.setAnimationsEnabled(false)
    self.tableView?.beginUpdates()
    self.tableView?.endUpdates()
    UIView.setAnimationsEnabled(true)
    return true
  }
  
  func textViewDidChange(_ textView: UITextView) {
    if !textView.text.isEmpty {
      placeholderLabel.isHidden = true
    } else {
      placeholderLabel.isHidden = false
    }
    
    self.tableView?.contentOffset.y = UIScreen.main.bounds.height * 0.4
    
    UIView.setAnimationsEnabled(false)
    self.tableView?.beginUpdates()
    self.tableView?.endUpdates()
    UIView.setAnimationsEnabled(true)
  }
}
