//
//  ChattingTableView.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ChattingTableView: UITableView {
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    UIView.setAnimationsEnabled(false)
    self.superview?.endEditing(true)
    UIView.setAnimationsEnabled(true)
  }
}
