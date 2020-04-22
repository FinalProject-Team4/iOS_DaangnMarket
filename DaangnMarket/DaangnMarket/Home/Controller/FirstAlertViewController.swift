//
//  FirstAlertViewController.swift
//  DaangnMarket
//
//  Created by Demian on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class FirstAlertViewController: UIViewController {
  private var homeVC: UIViewController?
  
  // MARK: Views
  
  private lazy var welcomeView = WelcomeView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 10
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    welcomeView.delegate = self
    setupUI()
    setupConstrains()
  }
  
  // MARK: Initialize
  
  private func setupUI() {
    self.view.addSubview(welcomeView)
  }
  
  private func setupConstrains() {
    welcomeView.snp.makeConstraints {
      $0.center.equalTo(self.view)
      $0.width.equalTo(self.view.safeAreaLayoutGuide.snp.width).multipliedBy(0.8)
      $0.height.equalTo(self.view.safeAreaLayoutGuide.snp.height).multipliedBy(0.6)
    }
  }
}

// MARK: Delegate Button Action

extension FirstAlertViewController: WelcomeViewInButtonsDelegate {
  func welcomeViewInButton(_ button: UIButton) {
    if button == welcomeView.lookAroundButton {
      dismiss(animated: false)
    } else {
      self.homeVC = self.presentingViewController
      self.dismiss(animated: true) {
        guard let phoneAuthVC = ViewControllerGenerator.shared.make(.phoneAuth) else { return }
        phoneAuthVC.modalPresentationStyle = .fullScreen
        self.homeVC?.present(phoneAuthVC, animated: true)
      }
    }
  }
}
