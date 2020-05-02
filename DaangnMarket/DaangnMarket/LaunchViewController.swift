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
    
    var towns = [String: UserTown]()
    if let firstTown = AuthorizationManager.shared.firstTown {
      towns["first"] = firstTown
    }
    if let secondTown = AuthorizationManager.shared.secondTown {
      towns["second"] = secondTown
    }
    
    if towns.isEmpty {
      ViewControllerGenerator.shared.make(.initialStart)?.do {
        UIApplication.shared.switchRootViewController($0)
      }
    } else {
      let group = DispatchGroup()
      if let firstTown = towns["first"] {
        group.enter()
        API.default.request(.distance(dongId: firstTown.locate.id)) { result in
          switch result {
          case .success(let towns):
            AuthorizationManager.shared.firstAroundTown = towns
          case .failure(let error):
            fatalError(error.localizedDescription)
          }
          group.leave()
        }
      }
      
      if let secondTown = towns["second"] {
        group.enter()
        API.default.request(.distance(dongId: secondTown.locate.id)) { result in
          switch result {
          case .success(let towns):
            AuthorizationManager.shared.secondAroundTown = towns
          case .failure(let error):
            fatalError(error.localizedDescription)
          }
          group.leave()
        }
      }
      
      group.notify(queue: .main) {
        self.activityIndicator.stopAnimating()
        ViewControllerGenerator.shared.make(.default)?.do {
          UIApplication.shared.switchRootViewController($0)
        }
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
