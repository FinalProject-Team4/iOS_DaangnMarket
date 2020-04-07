//
// NSMutableAttributedString+Extension.swift
// DaangnMarket
//
// Created by cskim on 2020/03/31.
// Copyright © 2020 Jisng. All rights reserved.
//
import UIKit

extension CALayer {
  func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
    let border = CALayer()
    switch edge {
    case .top:
      border.frame = CGRect(
        x: 0,
        y: 0,
        width: frame.width,
        height: thickness
      )
    case .bottom:
      border.frame = CGRect(
        x: frame.width * 0.05,
        y: frame.height - thickness,
        width: frame.width * 0.9,
        height: thickness
      )
    default:
      break
    }
    border.backgroundColor = color.cgColor
    addSublayer(border)
  }
}

extension UIView {
  func parentView<T: UIView>(of type: T.Type) -> T? {
    guard let view = superview else {
      return nil
    }
    return (view as? T) ?? view.parentView(of: T.self)
  }
  
  var parentViewController: UIViewController? {
    var responder: UIResponder? = self
    while let nextResponder = responder?.next {
      responder = nextResponder
      if let viewController = nextResponder as? UIViewController {
        return viewController
      }
    }
    return nil
  }
}

extension UITableViewCell {
  var tableView: UITableView? {
    return parentView(of: UITableView.self)
  }
}
