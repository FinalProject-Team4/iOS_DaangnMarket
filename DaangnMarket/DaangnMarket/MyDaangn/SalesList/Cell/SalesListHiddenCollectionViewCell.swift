//
//  SalesListHiddenCollectionViewCell.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol SalesListHiddenCVCDelegate: class {
  func hiddenOptionDeliver()
  func moveToPage(hidden: Post)
}

class SalesListHiddenCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  
  weak var delegate: SalesListHiddenCVCDelegate?
  private var completed: [Bool] = []
  private var hiddenData: [Post] = []
  
  // MARK: Views
  
  private var salesListTableView = UITableView()
  private var refreshControl = UIRefreshControl().then {
    $0.tintColor = UIColor(named: ColorReference.daangnMain.rawValue)
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupTableView()
    setupConstraints()
  }
  private func setupTableView() {
    salesListTableView.backgroundColor = UIColor(named: ColorReference.backGray.rawValue)
    salesListTableView.dataSource = self
    salesListTableView.delegate = self
    salesListTableView.separatorStyle = .none
    salesListTableView.register(SalesListHiddenTableViewCell.self, forCellReuseIdentifier: SalesListHiddenTableViewCell.identifier)
    salesListTableView.refreshControl = self.refreshControl
    refreshControl.addTarget(self, action: #selector(didPullrefreshControl(_:)), for: .valueChanged)
  }
  
  private func setupConstraints() {
    self.salesListTableView.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  // MARK: Interface
  
  func configure(hidden: [Post]) {
    self.hiddenData = hidden
  }
  
  // MARK: Action
  
  @objc func didPullrefreshControl(_ sender: Any) {
    self.refreshControl.endRefreshing()
  }
}

// MARK: - UITableViewDataSource

extension SalesListHiddenCollectionViewCell: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hiddenData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SalesListHiddenTableViewCell.identifier, for: indexPath) as? SalesListHiddenTableViewCell else { return UITableViewCell() }
//    cell.itemContentView.completedDeal(isCompleted: completed[indexPath.row])
    cell.selectionStyle = .none
    cell.delegate = self
    cell.configure(hiddenData: hiddenData[indexPath.row])
    return cell
  }
}

// MARK: - UITableViewDelegate

extension SalesListHiddenCollectionViewCell: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.moveToPage(hidden: hiddenData[indexPath.row])
  }
}

// MARK: - SalesListHiddenTVCDelegate

extension SalesListHiddenCollectionViewCell: SalesListHiddenTVCDelegate {
  func hiddenSalesOption() {
    delegate?.hiddenOptionDeliver()
  }
}
