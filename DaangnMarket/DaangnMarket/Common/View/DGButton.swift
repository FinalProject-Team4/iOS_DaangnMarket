//
//  DGButton.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class DGButton: UIButton {
  // MARK: Initialize
  init(title: String) {
    super.init(frame: .zero)
    self.setupUI(title: title)
  }
  
  private func setupUI(title: String) {
    self.setTitle(title, for: .normal)
    self.setTitleColor(.white, for: .normal)
    self.backgroundColor = UIColor(named: ColorReference.daangnMain.rawValue)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
