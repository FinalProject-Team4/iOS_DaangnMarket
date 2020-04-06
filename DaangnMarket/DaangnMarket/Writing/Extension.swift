//
// NSMutableAttributedString+Extension.swift
// DaangnMarket
//
// Created by cskim on 2020/03/31.
// Copyright © 2020 Jisng. All rights reserved.
//
import UIKit
extension NSMutableAttributedString {
  func bold(_ text: String, fontSize: CGFloat) -> NSMutableAttributedString {
    let attrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)]
    self.append(NSMutableAttributedString(string: text, attributes: attrs))
    return self
  }
  
  func normal(_ text: String, textColor: UIColor? = .black, fontSize: CGFloat) -> NSMutableAttributedString {
    let attrs: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
      NSAttributedString.Key.foregroundColor: textColor,
    ]
    self.append(NSMutableAttributedString(string: text, attributes: attrs))
    return self
  }
  
  func underline(_ text: String, fontSize: CGFloat) -> NSMutableAttributedString {
    let attrs: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)
    ]
    self.append(NSMutableAttributedString(string: text, attributes: attrs))
    return self
  }
}

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
