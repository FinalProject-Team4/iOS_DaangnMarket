//
//  Identifiable.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/25.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol Identifiable {
  static var identifier: String { get }
}

extension Identifiable {
  static var identifier: String { return String(describing: self) }
}

extension UITableViewCell: Identifiable { }
extension UITableViewHeaderFooterView: Identifiable { }
extension UICollectionReusableView: Identifiable { }
