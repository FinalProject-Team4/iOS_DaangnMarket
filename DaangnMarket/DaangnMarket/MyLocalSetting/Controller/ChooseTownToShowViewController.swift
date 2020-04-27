//
//  ChooseTownToShowViewController.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/07.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ChooseTownToShowViewController: UIViewController {
  // MARK: Propoerty
  let noti = NotificationCenter.default
  
  // MARK: Views
  
  lazy var townAroundView = MyTownAroundView().then {
    $0.backgroundColor = .white
  }
  var naviTitle = UILabel().then {
    $0.text = "게시글 보여줄 동네 고르기"
    $0.font = .systemFont(ofSize: 17, weight: .semibold)
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
//    MyTownSetting.shared.towns["first"] = AuthorizationManager.shared.selectedTown?.dong ?? "unknown"
    setupConstraint()
    setupNaviBar()
    saveTownsInfo(MyTownSetting.shared.isFirstTown)
  }
  
  // MARK: Initialize
  
  private func setupNaviBar() {
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationItem.titleView = naviTitle
    self.navigationItem.leftBarButtonItem = .init(image: UIImage(systemName: "arrow.left"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(didTapLeftBarButton))
  }
  private func setupConstraint() {
    self.view.addSubview(townAroundView)
    townAroundView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  // MARK: Method
  private func saveTownsInfo(_ isFirstTowns: Bool) {
    if let firstTown = AuthorizationManager.shared.selectedTown {
      MyTownSetting.shared.firstSelectTown = firstTown.dong
    }
    if let secondTown = AuthorizationManager.shared.anotherTown {
      MyTownSetting.shared.secondSelectTown = secondTown.dong
      noti.post(name: NSNotification.Name("anotherTownSecondTownBtn"), object: nil)
    }
    postNotificationForDefineMyTown(isFirstTowns)
  }
  
  private func postNotificationForDefineMyTown(_ isFirstTown: Bool) {
    print("first town", MyTownSetting.shared.firstSelectTown)
    switch isFirstTown {
    case true:
      noti.post(name: NSNotification.Name("FirstSelectTownCountView"), object: nil)
    case false:
      noti.post(name: NSNotification.Name("SecondSelectTownCountView"), object: nil)
    }
  }
  
  // MARK: Action
  
  @objc private func didTapLeftBarButton() {
    self.navigationController?.popViewController(animated: true)
  }
}

