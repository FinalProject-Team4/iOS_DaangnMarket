//
//  WriteTablePriceCell.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/03/25.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

// MARK: - Class Level
class WriteTablePriceCell: UITableViewCell {
  static let cellID = "WriteTablePriceCell"
  
  // MARK: Views
  
  private let priceLabel = UILabel().then {
    $0.text = "₩ "
    $0.textColor = .gray
    $0.font = .systemFont(ofSize: 16)
  }
  
  private lazy var priceTF = UITextField().then {
    $0.delegate = self
    $0.keyboardType = .numberPad
    $0.placeholder = "가격 입력(선택사항)"
    $0.font = .systemFont(ofSize: 16)
  }
  
  private lazy var suggestButton = UIButton().then {
    $0.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
    $0.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
    $0.tintColor = .gray
    $0.setTitle(" 가격제안 받기", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16)
    $0.addTarget(self, action: #selector(didTapSuggestButton(_:)), for: .touchUpInside)
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
    contentView.addSubview(priceLabel)
    contentView.addSubview(priceTF)
    contentView.addSubview(suggestButton)
  }
  
  private func setupConstraints() {
    priceLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
    }
    
    priceTF.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalTo(priceLabel.snp.trailing)
      $0.width.equalToSuperview().multipliedBy(0.4)
    }
    
    suggestButton.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
      $0.trailing.equalToSuperview().offset(-20)
    }
  }
  
  // MARK: Actions
  
  @objc private func didTapSuggestButton(_ button: UIButton) {
    button.isSelected.toggle()
    if button.isSelected {
      button.tintColor = .orange
    } else {
      button.tintColor = .gray
    }
  }
  
  // MARK: Interface
  
  var cellData: String {
    return self.priceTF.text ?? "0"
  }
}

// MARK: - Extension Level
extension WriteTablePriceCell: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    NotificationCenter.default.post(name: .keyboardWillShow, object: nil)
    return true
  }
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    guard let txt = textField.text else { return }
    
    if !txt.isEmpty {
      priceLabel.textColor = .black
    } else {
      priceLabel.textColor = .gray
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if range.lowerBound < 8 {
      return true
    } else {
      textField.text = "99999999"
      return false
    }
  }
}
