//
//  PopoverViewController.swift
//  DaangnMarket
//
//  Created by Demian on 2020/03/31.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
  lazy var firstLocation = UILabel().then {
    $0.backgroundColor = .green
    $0.textAlignment = .left
    $0.font = .systemFont(ofSize: 16)
    $0.frame = CGRect(x: 0, y: 0, width: 264, height: 50)
    $0.text = "test"
  }
  lazy var secondLocation = UILabel().then {
    $0.textAlignment = .left
    $0.font = .systemFont(ofSize: 16)
    $0.frame = CGRect(x: 0, y: 0, width: 264, height: 50)
  }
  lazy var thirdLocation = UILabel().then {
    $0.textAlignment = .left
    $0.font = .systemFont(ofSize: 16)
    $0.frame = CGRect(x: 0, y: 0, width: 264, height: 50)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .gray
    
    constraint()
  }
  func constraint() {
    self.view.addSubview(firstLocation)
    firstLocation.snp.makeConstraints {
      $0.top.leading.equalToSuperview()
    }
  }
}


