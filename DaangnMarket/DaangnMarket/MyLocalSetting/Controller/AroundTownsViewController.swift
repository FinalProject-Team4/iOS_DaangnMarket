//
//  AroundTownViewController.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/13.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class AroundTownsViewController: UIViewController {
  // MARK: Views
  
  lazy var aroundTownListTableView = UITableView().then {
    $0.separatorStyle = .none
    $0.allowsSelection = false
    $0.frame = self.view.frame
    $0.dataSource = self
    $0.register(UITableViewCell.self, forCellReuseIdentifier: "TownCell")
  }
  
  // MARK: Life Cycle
  
  private var towns = [Town]()
  
  init(towns: [Town]) {
    super.init(nibName: nil, bundle: nil)
    self.towns = towns
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(aroundTownListTableView)
    setupNaviBar()
  }
  
  private func setupUI() {
    aroundTownListTableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  // MARK: Method
  
  private func setupNaviBar() {
//    defineNavigationTitle()
    self.navigationItem.leftBarButtonItem = .init(image: UIImage(systemName: "arrow.left"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(didTapLeftBarButton))
    self.navigationItem.title = "근처 동네 \(towns.count)개"
  }
//  private func defineNavigationTitle() {
//    switch MyTownSetting.shared.isFirstTown {
//    case true:
//      self.navigationItem.title = "근처 동네 \(MyTownSetting.shared.numberOfAroundTownByFirst.0)개"
//    case false:
//      self.navigationItem.title = "근처 동네 \(MyTownSetting.shared.numberOfAroundTownBySecond.0)개"
//    }
//  }

// MARK: Action
 
 @objc private func didTapLeftBarButton() {
  self.navigationController?.popViewController(animated: true)
 }
}
// MARK: - TableView DataSource

extension AroundTownsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.towns.count
//    switch MyTownSetting.shared.isFirstTown {
//    case true:
//      return MyTownSetting.shared.firstAroundTownList.count
//    case false:
//      return MyTownSetting.shared.secondAroundTownList.count
//    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TownCell", for: indexPath)
    cell.textLabel?.text = self.towns[indexPath.row].dong
    return cell
//    switch MyTownSetting.shared.isFirstTown {
//    case true:
//      cell.textLabel?.text = MyTownSetting.shared.firstAroundTownList[indexPath.row].dong
//      return cell
//    case false:
//      cell.textLabel?.text = MyTownSetting.shared.secondAroundTownList[indexPath.row].dong
//      return cell
//    }
  }
}
