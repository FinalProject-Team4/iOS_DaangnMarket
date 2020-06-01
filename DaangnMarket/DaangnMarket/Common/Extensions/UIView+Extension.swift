
//
//  UIView+Extension.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

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
