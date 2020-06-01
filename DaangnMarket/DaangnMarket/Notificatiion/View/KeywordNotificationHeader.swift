//
//  KeywordNotificationHeaderView.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol KeywordNotificationHeaderDelegate: class {
  func headerView(_ headerView: KeywordNotificationHeader, didTapRemoveButton button: UIButton)
}

class KeywordNotificationHeader: UITableViewCell {
  // MARK: Views
  
  private lazy var removeButton = UIButton().then {
    $0.setTitle("전체 삭제", for: .normal)
    $0.setTitleColor(UIColor(named: ColorReference.item.rawValue), for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
    $0.addTarget(self, action: #selector(didTapRemoveButton(_:)), for: .touchUpInside)
  }
  
  // MARK: Delegate
  
  weak var delegate: KeywordNotificationHeaderDelegate?
  
  // MARK: Initialize
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setupAttributes()
    self.setupConstraints()
  }
  
  private func setupAttributes() {
    self.backgroundColor = UIColor(named: ColorReference.notiBackground.rawValue)
    self.selectionStyle = .none
    self.separatorInset = UIEdgeInsets(
      top: 0,
      left: UIScreen.main.bounds.maxX,
      bottom: 0,
      right: 0
    )
  }
  
  private func setupConstraints() {
    self.removeButton
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.trailing.bottom
          .equalToSuperview()
          .inset(UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 12))
    }
  }
  
  // MARK: Actions
  
  @objc private func didTapRemoveButton(_ sender: UIButton) {
    self.delegate?.headerView(self, didTapRemoveButton: sender)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

