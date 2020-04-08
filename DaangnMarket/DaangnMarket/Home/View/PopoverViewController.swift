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
  lazy var secondLocation = UIButton().then {
    $0.setTitle("나의동네 선택", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16)
    $0.frame = CGRect(x: 0, y: 0, width: 264, height: 50)
    $0.restorationIdentifier = "myTownSelectButton"
    $0.addTarget(self, action: #selector(viewChange(_:)), for: .touchUpInside)
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
      $0.top.equalToSuperview().offset(25)
      $0.leading.equalToSuperview().offset(25)
    }
    self.view.addSubview(secondLocation)
    secondLocation.snp.makeConstraints {
      $0.top.equalTo(firstLocation.snp.bottom)
      $0.leading.equalTo(firstLocation.snp.leading)
    }
  }
  
  @objc func viewChange(_ sender: UIButton) {
    guard let myTownVC = ViewControllerGenerator.shared.make(.townSetting) else { return }
    myTownVC.modalPresentationStyle = .fullScreen
    self.present(myTownVC, animated: true)
//    self.presentingViewController?.dismiss(animated: true)
//    self.navigationController?.pushViewController(myLoclVC, animated: true)
  }
}


