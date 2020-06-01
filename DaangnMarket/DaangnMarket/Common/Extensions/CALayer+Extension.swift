//
//  CALayer+Extension.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/24.
//  Copyright © 2020 Jisng. All rights reserved.
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
