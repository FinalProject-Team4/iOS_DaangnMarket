//
//  NotificationCell.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/15.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol NotificationCellDelegate: class {
  func notificationCell(_ cell: NotificationCell, didSelectDeleteAt row: Int)
}

class NotificationCell: UITableViewCell {
  // MARK: Delegate
  
  weak var delegate: NotificationCellDelegate?
  
  // MARK: Interface
  
  @discardableResult
  func configure(thumbnail: UIImage?, content: String, date: String) -> Self { return self }
  
  var indexPath = IndexPath()
}
