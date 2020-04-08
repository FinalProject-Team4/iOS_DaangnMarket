//
//  NSMutableAttributedString+Extension.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/31.
//  Copyright © 2020 Jisng. All rights reserved.
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
      NSAttributedString.Key.foregroundColor: textColor ?? .black,
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
  
  func underlineBold(_ text: String, fontSize: CGFloat) -> NSMutableAttributedString {
    let attrs: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
      NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)
    ]
    self.append(NSMutableAttributedString(string: text, attributes: attrs))
    return self
  }
}
