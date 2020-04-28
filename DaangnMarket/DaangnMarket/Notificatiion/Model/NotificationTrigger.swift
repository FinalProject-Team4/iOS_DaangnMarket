//
//  NotificationTrigger.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/28.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

enum NotificationType: String {
  case notice, chat
}

class NotificationTrigger {
  static let `default` = NotificationTrigger()
  
  private init() { }
  
  var tabBarController: MainTabBarController?
  var notiButton: UIButton?

  var type: NotificationType?
  
  func trigger() {
    guard let type = self.type else { return }
    defer { self.type = nil }
    
    tabBarController?.selectedIndex = 0
    switch type {
    case .notice:
      notiButton?.sendActions(for: .touchUpInside)
    case .chat:
      print("Show to Chat")
      return
    }
  }
}
