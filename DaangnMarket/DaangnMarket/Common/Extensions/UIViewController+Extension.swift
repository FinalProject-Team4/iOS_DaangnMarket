//
//  UIAlertController+Extension.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/03.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

extension UIViewController {
  func presentAlert(
    title: String = "",
    message: String = "",
    actions: [UIAlertAction] = [UIAlertAction(title: "확인", style: .default)]
  ) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    actions.forEach { alert.addAction($0) }
    self.present(alert, animated: true)
  }
  
  func presentActionSheet(
    title: String? = nil,
    message: String? = nil,
    actions: [UIAlertAction] = [UIAlertAction(title: "확인", style: .cancel)]
  ) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    actions.forEach { alert.addAction($0) }
    self.present(alert, animated: true)
  }
}
