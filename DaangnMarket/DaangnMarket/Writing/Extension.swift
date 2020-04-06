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
      border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
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
      if let vc = nextResponder as? UIViewController {
        return vc
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
