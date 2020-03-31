//
//  DGButton.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class DGButton: UIButton {
  // MARK: Properties
  
  override var isEnabled: Bool {
    didSet {
      let originColor = self.backgroundColor
      self.backgroundColor = isEnabled ? originColor : UIColor(named: ColorReference.borderLine.rawValue)
    }
  }
  
  // MARK: Initialize
  enum DGButtonType {
    case `default`, auth
  }
  init(type: DGButtonType = .default) {
    super.init(frame: .zero)
    self.setTitleColor(.white, for: .normal)
    switch type {
    case .default:
      self.backgroundColor = UIColor(named: ColorReference.daangnMain.rawValue)
    case .auth:
      self.backgroundColor = UIColor(named: ColorReference.auth.rawValue)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
