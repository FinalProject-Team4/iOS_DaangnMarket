//
//  NumberField.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/01.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class NumberField: UITextField {
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.font = .systemFont(ofSize: 15)
    self.keyboardType = .numberPad
    self.textAlignment = .center
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor(named: ColorReference.borderLine.rawValue)?.cgColor
    self.layer.cornerRadius = 4
    
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UINavigationBar.statusBarSize.width, height: 44))
    let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let dismiss = UIBarButtonItem(image: UIImage(systemName: ImageReference.keyboardDown.rawValue), style: .plain, target: self, action: #selector(didTapDismissButton(_:))).then {
      $0.tintColor = UIColor(named: ColorReference.item.rawValue)
    }
    toolBar.items = [flexible, dismiss]
    self.inputAccessoryView = toolBar
  }
  
  // MARK: Actions
  
  @objc private func didTapDismissButton(_ sender: UIBarButtonItem) {
    self.resignFirstResponder()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
