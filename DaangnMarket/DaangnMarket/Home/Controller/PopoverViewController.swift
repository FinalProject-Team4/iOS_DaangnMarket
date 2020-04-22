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
  
  lazy var firstMyTownBtn = PopoverFirstTownButton().then {
    $0.restorationIdentifier = "popoverFirstTownBtn"
    $0.addTarget(self, action: #selector(didTapButtonForHomeFeed(_:)), for: .touchUpInside)
  }
  lazy var secondMyTownBtn = PopoverSecondTownButton().then {
    $0.restorationIdentifier = "popoverSecondTownBtn"
    $0.addTarget(self, action: #selector(didTapButtonForHomeFeed(_:)), for: .touchUpInside)
  }
  var myTownSettingBtn = PopoverTownSettingButton().then {
    $0.restorationIdentifier = "popoverTownSettingBtn"
    $0.addTarget(self, action: #selector(didTapViewChange), for: .touchUpInside)
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.preferredContentSize = CGSize(
      width: Int(UIScreen.main.bounds.width * 0.7),
      height: 50 * (MyTownSetting.shared.towns.count + 1)
    )
    setTownName()
    setupConstraint()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.preferredContentSize = CGSize(
      width: Int(UIScreen.main.bounds.width * 0.7),
      height: 50 * (MyTownSetting.shared.towns.count + 1)
    )
  }
  
  // MARK: Initialize
  
  private func setupConstraint() {
    if MyTownSetting.shared.towns.count == 1 {
      [myTownSettingBtn, firstMyTownBtn].forEach { self.view.addSubview($0) }
      firstMyTownBtn.snp.makeConstraints {
        $0.top.equalToSuperview().offset(13)
        $0.width.equalToSuperview()
        $0.height.equalTo(50)
      }
      myTownSettingBtn.snp.makeConstraints {
        $0.top.equalTo(firstMyTownBtn.snp.bottom)
        $0.leading.trailing.equalTo(firstMyTownBtn)
        $0.height.equalTo(50)
        $0.bottom.equalToSuperview()
      }
    } else if MyTownSetting.shared.towns.count == 2 {
      [myTownSettingBtn, secondMyTownBtn, firstMyTownBtn].forEach { self.view.addSubview($0) }
      firstMyTownBtn.snp.makeConstraints {
        $0.top.equalToSuperview().offset(13)
        $0.width.equalToSuperview()
        $0.height.equalTo(50)
      }
      secondMyTownBtn.snp.makeConstraints {
        $0.top.equalTo(firstMyTownBtn.snp.bottom)
        $0.leading.trailing.equalTo(firstMyTownBtn)
        $0.height.equalTo(50)
      }
      myTownSettingBtn.snp.makeConstraints {
        $0.top.equalTo(firstMyTownBtn.snp.bottom).offset(50)
        $0.leading.trailing.equalTo(firstMyTownBtn)
        $0.height.equalTo(50)
        $0.bottom.equalToSuperview()
      }
    }
  }
  
  // MARK: Method
  
  private func setTownName() {
    guard let selectedTown = AuthorizationManager.shared.selectedTown else { print("popover selectedTown"); return }
      MyTownSetting.shared.towns["first"] = selectedTown.dong
      firstMyTownBtn.townLabel.text = MyTownSetting.shared.towns["first"]
    guard let anotherTown = AuthorizationManager.shared.anotherTown else { print("popover anotherTown"); return }
      MyTownSetting.shared.towns["second"] = anotherTown.dong
      secondMyTownBtn.townLabel.text = MyTownSetting.shared.towns["second"]
  }
  
  // MARK: Action
  
  @objc func didTapViewChange(_ sender: UIButton) {
    guard let myTownVC = ViewControllerGenerator.shared.make(.townSetting) else { return }
    myTownVC.modalPresentationStyle = .fullScreen
    self.present(myTownVC, animated: true)
  }
  @objc func didTapButtonForHomeFeed(_ sender: UIButton) {
    switch sender {
    case firstMyTownBtn:
//      print("\(MyTownSetting.shared.firstAroundTownList[0].dong)")
      print("첫번째 설정 동네")
    case secondMyTownBtn:
//      print("\(MyTownSetting.shared.secondAroundTownList[0].dong)")
      print("두번째 설정 동네")
    default: break
    }
  }
}
