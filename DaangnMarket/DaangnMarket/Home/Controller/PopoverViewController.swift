//
//  PopoverViewController.swift
//  DaangnMarket
//
//  Created by Demian on 2020/03/31.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
protocol SelectedTownNameInNavibarDelegate: class {
  func showSelectedTownName(_ isFirst: Bool)
}

class PopoverViewController: UIViewController {
  // MARK: Property
  
  weak var delegate: SelectedTownNameInNavibarDelegate?
  
  // MARK: Views
  
  lazy var firstMyTownBtn = PopoverFirstTownButton().then {
    $0.addTarget(self, action: #selector(didTapButtonForHomeFeed(_:)), for: .touchUpInside)
  }
  lazy var secondMyTownBtn = PopoverSecondTownButton().then {
    $0.addTarget(self, action: #selector(didTapButtonForHomeFeed(_:)), for: .touchUpInside)
  }
  var myTownSettingBtn = PopoverTownSettingButton().then {
    $0.addTarget(self, action: #selector(didTapPresentBtn), for: .touchUpInside)
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    setTownName()
    setupConstraint()
    didTapButtonForHomeFeed(UIButton())
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
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
  
  private func changeSelectTownBtnFont(_ isSelect: Bool) {
    switch isSelect {
    case true:
      secondMyTownBtn.townLabel.textColor = UIColor(named: ColorReference.noResultImage.rawValue)
      secondMyTownBtn.townLabel.font = .systemFont(ofSize: 16, weight: .regular)
      firstMyTownBtn.townLabel.textColor = .black
      firstMyTownBtn.townLabel.font = .systemFont(ofSize: 16, weight: .bold)
    case false:
      firstMyTownBtn.townLabel.textColor = UIColor(named: ColorReference.noResultImage.rawValue)
      firstMyTownBtn.townLabel.font = .systemFont(ofSize: 16, weight: .regular)
      secondMyTownBtn.townLabel.textColor = .black
      secondMyTownBtn.townLabel.font = .systemFont(ofSize: 16, weight: .bold)
    }
  }
  
  // MARK: Action
  
  @objc func didTapPresentBtn(_ sender: UIButton) {
    guard let myTownVC = ViewControllerGenerator.shared.make(.townSetting) else { return }
    myTownVC.modalPresentationStyle = .fullScreen
    self.present(myTownVC, animated: true)
  }
  @objc func didTapButtonForHomeFeed(_ sender: UIButton) {
    switch sender {
    case firstMyTownBtn:
      MyTownSetting.shared.isFirstTown = true
    case secondMyTownBtn:
      MyTownSetting.shared.isFirstTown = false
    default: break
    }
    changeSelectTownBtnFont(MyTownSetting.shared.isFirstTown)
    self.delegate?.showSelectedTownName(MyTownSetting.shared.isFirstTown)
  }
}
