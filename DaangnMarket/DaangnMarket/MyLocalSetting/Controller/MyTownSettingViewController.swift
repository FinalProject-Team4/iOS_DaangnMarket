//
//  MyTownSettingViewController.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/03.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class MyTownSettingViewController: UIViewController {
  // MARK: Views
  
  var townSelectView = TownSelectView().then {
    $0.backgroundColor = .white
  }
  lazy var townAroundView = MyTownAroundView().then {
    $0.backgroundColor = .white
  }
  var naviTitle = UILabel().then {
    $0.text = "내 동네 설정하기"
    $0.font = .systemFont(ofSize: 17, weight: .light)
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    townSelectView.delegate = self
    setupConstraint()
    setupNaviBar()
    postNotification()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    postNotification()
  }
  
  // MARK: Initialize
  
  private func setupNaviBar() {
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationItem.titleView = naviTitle
    self.navigationItem.leftBarButtonItem = .init(image: UIImage(systemName: "multiply"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(didTapLeftBarButton))
  }
  private func setupConstraint() {
    [townSelectView, townAroundView].forEach { self.view.addSubview($0) }
    townSelectView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(160)
    }
    townAroundView.snp.makeConstraints {
      $0.top.equalTo(townSelectView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  // MARK: Method
  
  private func postNotification() {
    if let firstTown = AuthorizationManager.shared.selectedTown {
      MyTownSetting.shared.firstSelectTown = firstTown.dong
      NotificationCenter.default.post(name: NSNotification.Name("FirstSelectTownCountView"),
                                      object: nil)
    }
    if let secondTown = AuthorizationManager.shared.anotherTown {
      MyTownSetting.shared.secondSelectTown = secondTown.dong
      NotificationCenter.default.post(name: NSNotification.Name("anotherTownSecondTownBtn"),
                                      object: nil)
      NotificationCenter.default.post(name: NSNotification.Name("hidePlusTownSelectView"),
                                      object: nil)
      NotificationCenter.default.post(name: NSNotification.Name("SecondSelectTownCountView"),
                                      object: nil)
    }
  }
  
  // MARK: Action
  
  @objc private func didTapLeftBarButton() {
    dismiss(animated: true)
  } 
}

// MARK: SecondTownSelectButton Delegate
extension MyTownSettingViewController: SecondTownButtonDelegate {
  func secondTownSelectBtn(_ secondButton: UIButton) {
    let findTownVC = FindMyTownViewController()
    self.navigationController?.pushViewController(findTownVC, animated: true)
  }
}
