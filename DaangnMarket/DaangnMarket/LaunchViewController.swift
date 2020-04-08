//
//  LaunchViewController.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/08.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
  // MARK: Views
  
  private let logo = UIImageView(named: ImageReference.daangnLogo.rawValue).then {
    $0.contentMode = .scaleAspectFit
  }
  private let activityIndicator = UIActivityIndicatorView().then {
    $0.color = UIColor(named: ColorReference.daangnMain.rawValue)
    $0.hidesWhenStopped = true
    $0.isHidden = true
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if let selectedTown = AuthorizationManager.shared.selectedTown {
      self.activityIndicator.startAnimating()
      API.default.request(.distance(dongId: selectedTown.id)) { (result) in
        switch result {
        case .success(let towns):
          self.activityIndicator.stopAnimating()
          ViewControllerGenerator.shared.make(.default)?.do {
            AuthorizationManager.shared.aroundTown = towns
            UIApplication.shared.switchRootViewController($0)
          }
        case .failure(let error):
          fatalError(error.localizedDescription)
        }
      }
    } else {
      ViewControllerGenerator.shared.make(.initialStart)?.do {
        UIApplication.shared.switchRootViewController($0)
      }
    }
  }
  
  // MARK: Initialize
  
  private func setupUI() {
    self.setupAttributes()
    self.setupConstraints()
  }
  
  private func setupAttributes() {
    self.view.backgroundColor = .systemBackground
  }
  
  private func setupConstraints() {
    self.logo
      .then { self.view.addSubview($0) }
      .snp.makeConstraints {
        $0.center.equalToSuperview()
        $0.size.equalTo(88)
    }
    
    self.activityIndicator
      .then { self.view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self.logo.snp.bottom).offset(16)
        $0.centerX.equalToSuperview()
    }
  }
  
  // MARK: Methods
  
  
}
