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

enum NotificationReceiveState: String {
  case notRunning, background, foreground
}

class NotificationTrigger {
  static let `default` = NotificationTrigger()
  
  private init() { }
  
  var tabBarController: MainTabBarController?
  var notiButton: UIButton?

  var receiveState: NotificationReceiveState = .notRunning
  var type: NotificationType? {
    didSet {
      if self.type != nil, self.receiveState != .notRunning {
        self.trigger()
      }
    }
  }
  
  func trigger() {
    defer {
      self.type = nil
      self.receiveState = .foreground
    }
    
    guard
      let tabBarController = self.tabBarController,
      let notiButton = self.notiButton,
      let type = self.type
      else { return print("Cannot Trigger") }
    
    tabBarController.selectedIndex = 0
    
    switch type {
    case .notice:
      notiButton.sendActions(for: .touchUpInside)
      print("Show to notice")
    case .chat:
      print("Show to Chat")
      return
    }
  }
}
