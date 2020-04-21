//
//  PopoverViewController.swift
//  DaangnMarket
//
//  Created by Demian on 2020/03/31.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
  
  // MARK: Views
  let popoverTableView = UITableView().then {
    $0.rowHeight = 50
    $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    popoverTableView.dataSource = self
    popoverTableView.frame = self.view.frame
    setupUI()
  }
  
  private func setupUI() {
    self.view.frame = CGRect(x: 0, y: 0, width: 264, height: popoverTableView.frame.height)
  }
}

// MARK: - TableView DataSource
extension PopoverViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = "\(indexPath.row)"
    
    return cell
  }
}

//// MARK: - TableView Delegate
//extension PopoverViewController: UITableViewDelegate {
//
//}

//  // MARK: Views
//
//  var firstMyTownBtn = PopoverFirstTownButton().then {
////    $0.frame = CGRect(x: 0, y: 0, width: 264, height: 50)
//    $0.restorationIdentifier = "popoverFirstTownBtn"
//  }
//  var secondMyTownBtn = PopoverSecondTownButton().then {
////    $0.frame = CGRect(x: 0, y: 0, width: 264, height: 50)
//    $0.restorationIdentifier = "popoverSecondTownBtn"
////    $0.addTarget(self, action: #selector(didTapViewChange), for: .touchUpInside)
//  }
//  var myTownSettingBtn = PopoverTownSettingButton().then {
////    $0.frame = CGRect(x: 0, y: 0, width: 264, height: 50)
//    $0.restorationIdentifier = "popoverTownSettingBtn"
//    $0.addTarget(self, action: #selector(didTapViewChange), for: .touchUpInside)
//  }
//
//  // MARK: Life Cycle
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    self.view.backgroundColor = .white
//    constraint()
//    setTownName()
//  }
//
//  // MARK: Initialize
//
//  private func constraint() {
//    self.view.addSubview(firstMyTownBtn)
//    firstMyTownBtn.snp.makeConstraints {
//      $0.top.leading.trailing.equalToSuperview()
//      $0.width.equalTo(264)
//      $0.bottom.equalTo(50)
//    }
//    self.view.addSubview(secondMyTownBtn)
//    secondMyTownBtn.snp.makeConstraints {
//      $0.top.leading.trailing.equalTo(firstMyTownBtn)
//      $0.width.equalTo(264)
//      $0.bottom.equalTo(50)
//    }
//    self.view.addSubview(myTownSettingBtn)
//    secondMyTownBtn.snp.makeConstraints {
//      $0.top.equalTo(firstMyTownBtn.snp.bottom)
//      $0.leading.equalTo(firstMyTownBtn.snp.leading)
//    }
//  }
//
//  // MARK: Method
//
//  private func setTownName() {
//    if let selectedTown = AuthorizationManager.shared.selectedTown {
//      MyTownSetting.shared.towns["first"] = selectedTown.dong
//      firstMyTownBtn.setTitle(MyTownSetting.shared.towns["first"], for: .normal)
//    }
//    if let anotherTown = AuthorizationManager.shared.anotherTown {
//      MyTownSetting.shared.towns["second"] = anotherTown.dong
//    }
//  }
//
//  // MARK: Action
//
//  @objc func didTapViewChange(_ sender: UIButton) {
//    guard let myTownVC = ViewControllerGenerator.shared.make(.townSetting) else { return }
//    myTownVC.modalPresentationStyle = .fullScreen
//    self.present(myTownVC, animated: true)
//  }
