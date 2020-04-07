//
//  InitialStartViewController.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class InitialStartViewController: UIViewController {
  // MARK: Views
  
  private lazy var initialView = InitialStartView().then {
    $0.addTarget(self, action: #selector(didTapStartButton(_:)))
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.initialView.animate()
  }
  
  // MARK: Initialize
  
  private func setupUI() {
    self.view.backgroundColor = .systemBackground
    self.navigationController?.navigationBar.isHidden = true
    self.tabBarController?.tabBar.isHidden = true
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    self.initialView
      .then { self.view.addSubview($0) }
      .snp
      .makeConstraints {
        $0.center.equalTo(self.view)
        $0.width.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
  // MARK: Actions
  
  @objc private func didTapStartButton(_ sender: UIButton) {
    self.navigationController?.pushViewController(FindMyTownViewController(), animated: true)
  }
}
