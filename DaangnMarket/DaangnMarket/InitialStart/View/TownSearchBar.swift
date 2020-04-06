//
//  TownSearchBar.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/25.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol TownSearchBarDelegate: class {
  func townSearchBar(_ townSearchBar: TownSearchBar, willSearchWith text: String)
}

class TownSearchBar: UIView {
  // MARK: Views
  
  private lazy var inputField = UITextField().then {
    $0.placeholder = "동명(읍, 면)으로 검색 (ex. 서초동)"
    $0.font = .systemFont(ofSize: 18)
    $0.clearButtonMode = .whileEditing
    $0.delegate = self
    $0.returnKeyType = .search
  }
  private lazy var searchButton = UIButton().then {
    $0.setImage(UIImage(systemName: ImageReference.search.rawValue), for: .normal)
    $0.tintColor = UIColor(named: ColorReference.item.rawValue)
    $0.addTarget(self, action: #selector(didTapSearchButton(_:)), for: .touchUpInside)
  }
  private let underline = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  
  // MARK: Properties
  
  weak var delegate: TownSearchBarDelegate?
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    let padding: CGFloat = 16
    let spacing: CGFloat = 16
    let searchSize: CGFloat = 24
    
    self.inputField
      .then { self.addSubview($0) }
      .snp
      .makeConstraints {
        $0.top.leading.bottom
          .equalToSuperview()
          .inset(UIEdgeInsets(top: padding, left: padding, bottom: padding, right: 0))
    }
    self.searchButton
      .then { self.addSubview($0) }
      .snp
      .makeConstraints {
        $0.top.trailing.bottom
          .equalToSuperview()
          .inset(UIEdgeInsets(top: padding, left: 0, bottom: padding, right: padding))
        $0.leading
          .equalTo(self.inputField.snp.trailing)
          .offset(spacing)
        $0.size.equalTo(searchSize)
    }
    self.underline
      .then { self.addSubview($0) }
      .snp
      .makeConstraints {
        $0.leading.equalTo(self.inputField)
        $0.trailing.equalTo(self.searchButton)
        $0.bottom.equalToSuperview()
        $0.height.equalTo(0.4)
    }
    
    let height: CGFloat = 56
    self.snp.makeConstraints {
      $0.height.equalTo(height)
    }
  }
  
  // MARK: Actions
  
  @objc private func didTapSearchButton(_ sender: UIButton) {
    self.delegate?.townSearchBar(self, willSearchWith: self.inputField.text ?? "")
    self.endEditing(false)
  }
  
  // MARK: Interface
  
  @discardableResult
  func clear() -> Self {
    self.inputField.text = ""
    return self
  }
  
  func startEditing() {
    self.inputField.becomeFirstResponder()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UITextFieldDelegate

extension TownSearchBar: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.delegate?.townSearchBar(self, willSearchWith: textField.text ?? "")
    textField.resignFirstResponder()
    return true
  }
}
