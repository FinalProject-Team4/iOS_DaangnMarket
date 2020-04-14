//
//  PopoverViewController.swift
//  DaangnMarket
//
//  Created by Demian on 2020/03/31.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
  // MARK: Views
  
  lazy var firstMyTown = UIButton().then {
    $0.setTitle("나의동네 선택", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16)
    $0.frame = CGRect(x: 0, y: 0, width: 264, height: 50)
    $0.restorationIdentifier = "myTownSelectButton"
    $0.addTarget(self, action: #selector(didTapViewChange), for: .touchUpInside)
  }
  lazy var secondMyTown = UIButton().then {
    $0.setTitle("나의동네 선택", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16)
    $0.frame = CGRect(x: 0, y: 0, width: 264, height: 50)
    $0.restorationIdentifier = "myTownSelectButton"
    $0.addTarget(self, action: #selector(didTapViewChange), for: .touchUpInside)
  }
  lazy var thirdMyTown = UIButton().then {
    $0.setTitle("나의동네 선택", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16)
    $0.frame = CGRect(x: 0, y: 0, width: 264, height: 50)
    $0.restorationIdentifier = "myTownSelectButton"
    $0.addTarget(self, action: #selector(didTapViewChange), for: .touchUpInside)
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .gray
    constraint()
  }
  
  // MARK: Initialize
  
  func constraint() {
    self.view.addSubview(firstMyTown)
    firstMyTown.snp.makeConstraints {
      $0.top.equalToSuperview().offset(25)
      $0.leading.equalToSuperview().offset(25)
    }
    self.view.addSubview(secondMyTown)
    secondMyTown.snp.makeConstraints {
      $0.top.equalTo(firstMyTown.snp.bottom)
      $0.leading.equalTo(firstMyTown.snp.leading)
    }
  }
  
  // MARK: Action
  
  @objc func didTapViewChange(_ sender: UIButton) {
//    print(#function, "Sender : ", sender)
    if let selectedTown = AuthorizationManager.shared.selectedTown {
      MyTownSetting.shared.towns["first"] = selectedTown.dong
    }
    if let anotherTown = AuthorizationManager.shared.anotherTown {
      MyTownSetting.shared.towns["second"] = anotherTown.dong
    }
    
    guard let myTownVC = ViewControllerGenerator.shared.make(.townSetting) else { return }
    myTownVC.modalPresentationStyle = .fullScreen
    self.present(myTownVC, animated: true)
  }
}


