//
//  UITableViewCell+Extension.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

extension UITableViewCell {
  var tableView: UITableView? {
    return parentView(of: UITableView.self)
  }
}
