//
//  ChooseTownToShowViewController.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/07.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ChooseTownToShowViewController: UIViewController {
  // MARK: Views
  
  lazy var townAroundView = MyTownAroundView().then {
    $0.backgroundColor = .white
  }
  var naviTitle = UILabel().then {
    $0.text = "게시글 보여줄 동네 고르기"
    $0.font = .systemFont(ofSize: 17, weight: .light)
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    MyTownSetting.shared.towns["first"] = AuthorizationManager.shared.selectedTown?.dong ?? "unknown"
    setupConstraint()
    setupNaviBar()
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
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  // MARK: Action
  
  @objc private func didTapLeftBarButton() {
    self.navigationController?.popViewController(animated: true)
  }
}

