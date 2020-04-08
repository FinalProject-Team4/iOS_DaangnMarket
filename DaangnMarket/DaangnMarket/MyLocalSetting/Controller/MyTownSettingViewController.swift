//
//  MyTownSettingViewController.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/03.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class MyTownSettingViewController: UIViewController {
  lazy var townSelectView = TownSelectView().then {
    $0.backgroundColor = .white
  }
  lazy var townAroundView = MyTownAroundView().then {
    $0.backgroundColor = .white
  }
  var naviTitle = UILabel().then {
    $0.text = "내 동네 설정하기"
    $0.font = .systemFont(ofSize: 17, weight: .light)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    if let selectedTown = AuthorizationManager.shared.selectedAddress {
      MyTownSetting.shared.towns["first"] = selectedTown.dong
      MyTownSetting.shared.selectTownName = selectedTown.dong
    }
    setupConstraint()
    setupNaviBar()
  }
  
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
  
  @objc private func didTapLeftBarButton() {
    dismiss(animated: true)
  }
}
