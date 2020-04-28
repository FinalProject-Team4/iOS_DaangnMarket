//
//  PopoverViewController.swift
//  DaangnMarket
//
//  Created by Demian on 2020/03/31.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
//protocol SelectedTownNameInNavibarDelegate: class {
//  func showSelectedTownName(_ isFirst: Bool)
//}

class PopoverViewController: UIViewController {
  // MARK: Property
  
//  weak var delegate: SelectedTownNameInNavibarDelegate?
  
  private let manager = AuthorizationManager.shared
  
  // MARK: Views
  
  lazy var firstMyTownBtn = PopoverFirstTownButton().then {
    $0.addTarget(self, action: #selector(didTapTownButton), for: .touchUpInside)
  }
  lazy var secondMyTownBtn = PopoverSecondTownButton().then {
    $0.addTarget(self, action: #selector(didTapTownButton), for: .touchUpInside)
  }
  var myTownSettingBtn = PopoverTownSettingButton().then {
    $0.addTarget(self, action: #selector(didTapTownSettingButton), for: .touchUpInside)
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    getTownsName()
    setupSelectedState()
    setupConstraint()
//    print(MyTownSetting.shared.towns.count)
//    print(MyTownSetting.shared.towns["second"])
//    didTapButtonForHomeFeed(UIButton())
//    changeSelectTownBtnFont(MyTownSetting.shared.isFirstTown)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    self.preferredContentSize = CGSize(
//      width: Int(UIScreen.main.bounds.width * 0.7),
//      height: 50 * (MyTownSetting.shared.towns.count + 1)
//    )
  }
  
  // MARK: Initialize
  
  private func setupConstraint() {
//    if MyTownSetting.shared.towns.count == 1 {
//      [myTownSettingBtn, firstMyTownBtn].forEach { self.view.addSubview($0) }
//      firstMyTownBtn.snp.makeConstraints {
//        $0.top.equalToSuperview().offset(13)
//        $0.width.equalToSuperview()
//        $0.height.equalTo(50)
//      }
//      myTownSettingBtn.snp.makeConstraints {
//        $0.top.equalTo(firstMyTownBtn.snp.bottom)
//        $0.leading.trailing.equalTo(firstMyTownBtn)
//        $0.height.equalTo(50)
//        $0.bottom.equalToSuperview()
//      }
//    } else if MyTownSetting.shared.towns.count == 2 {
//      [myTownSettingBtn, secondMyTownBtn, firstMyTownBtn].forEach { self.view.addSubview($0) }
//      firstMyTownBtn.snp.makeConstraints {
//        $0.top.equalToSuperview().offset(13)
//        $0.width.equalToSuperview()
//        $0.height.equalTo(50)
//      }
//      secondMyTownBtn.snp.makeConstraints {
//        $0.top.equalTo(firstMyTownBtn.snp.bottom)
//        $0.leading.trailing.equalTo(firstMyTownBtn)
//        $0.height.equalTo(50)
//      }
//      myTownSettingBtn.snp.makeConstraints {
//        $0.top.equalTo(firstMyTownBtn.snp.bottom).offset(50)
//        $0.leading.trailing.equalTo(firstMyTownBtn)
//        $0.height.equalTo(50)
//        $0.bottom.equalToSuperview()
//      }
//    }
    
    let guide = self.view.safeAreaLayoutGuide
    var viewCount = 1
    var temp: UIView?
    
    if self.manager.firstTown != nil {
      temp = self.firstMyTownBtn
      viewCount += 1
      self.firstMyTownBtn
        .then { self.view.addSubview($0) }
        .snp.makeConstraints {
          $0.top.leading.trailing.equalTo(guide)
//          $0.top.equalToSuperview().offset(13)
//          $0.width.equalToSuperview()
          $0.height.equalTo(50)
        }
    }
    
    if self.manager.secondTown != nil {
      temp = self.secondMyTownBtn
      viewCount += 1
      self.secondMyTownBtn
        .then { self.view.addSubview($0) }
        .snp.makeConstraints {
          $0.top.equalTo(firstMyTownBtn.snp.bottom)
          $0.leading.trailing.equalTo(firstMyTownBtn)
          $0.height.equalTo(50)
        }
    }
    
    self.myTownSettingBtn
      .then { self.view.addSubview($0) }
      .snp.makeConstraints {
        if let temp = temp {
          $0.top.equalTo(temp.snp.bottom)
          $0.leading.trailing.equalTo(firstMyTownBtn)
        } else {
          $0.top.leading.trailing.equalTo(guide)
        }
        $0.height.equalTo(50)
        $0.bottom.equalTo(guide)
      }

    self.preferredContentSize = CGSize(
      width: Int(UIScreen.main.bounds.width * 0.7),
      height: 50 * viewCount
    )
  }
  
  // MARK: Method
  
  private func getTownsName() {
    if let firstTown = self.manager.firstTown {
      self.firstMyTownBtn.text = firstTown.locate.dong
    }
    
    if let secondTown = self.manager.secondTown {
      self.secondMyTownBtn.text = secondTown.locate.dong
    }
    
//    firstMyTownBtn.townLabel.text = MyTownSetting.shared.towns["first"]
//    secondMyTownBtn.townLabel.text = MyTownSetting.shared.towns["second"]
  }
  
  private func setupSelectedState() {
    if let isActivatedFirst = self.manager.firstTown?.activated {
      self.firstMyTownBtn.isSelected = isActivatedFirst
    }
    
    if let isActivatedSecond = self.manager.secondTown?.activated {
      self.secondMyTownBtn.isSelected = isActivatedSecond
    }
  }
  
//  private func changeSelectTownBtnFont(_ isSelect: Bool) {
//    switch isSelect {
//    case true:
//      secondMyTownBtn.townLabel.textColor = UIColor(named: ColorReference.noResultImage.rawValue)
//      secondMyTownBtn.townLabel.font = .systemFont(ofSize: 16, weight: .regular)
//      firstMyTownBtn.townLabel.textColor = .black
//      firstMyTownBtn.townLabel.font = .systemFont(ofSize: 16, weight: .bold)
//    case false:
//      firstMyTownBtn.townLabel.textColor = UIColor(named: ColorReference.noResultImage.rawValue)
//      firstMyTownBtn.townLabel.font = .systemFont(ofSize: 16, weight: .regular)
//      secondMyTownBtn.townLabel.textColor = .black
//      secondMyTownBtn.townLabel.font = .systemFont(ofSize: 16, weight: .bold)
//    }
//  }
  
  // MARK: Action
  
  var homeVC: UIViewController?
  
  @objc func didTapTownSettingButton(_ sender: UIButton) {
    self.homeVC = self.presentingViewController
    self.dismiss(animated: true) {
      guard let myTownVC = ViewControllerGenerator.shared.make(.townSetting) else { return }
      myTownVC.modalPresentationStyle = .fullScreen
      self.homeVC?.present(myTownVC, animated: true)
    }
  }
  
  @objc func didTapTownButton(_ sender: UIButton) {
    guard let firstTown = self.manager.firstTown, let secondTown = self.manager.secondTown else { return }
    
    firstMyTownBtn.isSelected = sender == firstMyTownBtn
    secondMyTownBtn.isSelected = sender == secondMyTownBtn
    self.manager.updateFirstTown(activated: firstMyTownBtn.isSelected)
    self.manager.updateSecondTown(activated: secondMyTownBtn.isSelected)
//    firstTown.activated = sender.isSelected
//    secondTown.activated = sender.isSelected
//    self.manager.firstTown = firstTown
//    self.manager.secondTown = secondTown
    
    let title = self.firstMyTownBtn.isSelected ? firstTown.locate.dong : secondTown.locate.dong
    let naviVC = (self.presentingViewController as? MainTabBarController)?
      .viewControllers?
      .first as? UINavigationController
    self.homeVC = naviVC?.topViewController
    (self.homeVC as? HomeFeedViewController)?
      .customNaviBar
      .selectedTownButton
      .setTitle(title, for: .normal)
    
    self.dismiss(animated: true) {
      (self.homeVC as? HomeFeedViewController)?.requestInitialPostList()
    }
//    switch sender {
//    case firstMyTownBtn:
////      MyTownSetting.shared.isFirstTown = true
////      MyTownSetting.shared.register(isFirstTown: true)
//
//    case secondMyTownBtn:
//      MyTownSetting.shared.register(isFirstTown: false)
////      MyTownSetting.shared.isFirstTown = false
//    default: break
//    }
//    changeSelectTownBtnFont(MyTownSetting.shared.isFirstTown)
//    self.delegate?.showSelectedTownName(MyTownSetting.shared.isFirstTown)
  }
}
