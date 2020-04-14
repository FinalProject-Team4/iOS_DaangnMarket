//
//  PageCollectionViewCell.swift
//  DaangnMarket
//
//  Created by Mac mini on 2020/04/11.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell { 
  // MARK: Property
  
  static let identifier = "pageCollectionCell"
  var dummyData = dummyItemsData
  private var refreshControl = UIRefreshControl().then {
    $0.tintColor = UIColor(named: ColorReference.daangnMain.rawValue)
  }
  
  // MARK: View
  
  private var pageTableView = UITableView()
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super .init(frame: frame)
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
    pageTableView.backgroundColor = UIColor(named: ColorReference.backGray.rawValue)
    pageTableView.delegate = self
    pageTableView.dataSource = self
    pageTableView.separatorStyle = .none
    pageTableView.register(PageTableViewCell.self, forCellReuseIdentifier: PageTableViewCell.identifier)
    pageTableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(didPullrefreshControl(_:)), for: .valueChanged)
  }
  
  private func setupConstraints() {
    self.pageTableView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.trailing.bottom.equalTo(self)
    }
  }
  
  // MARK: Action
  
  @objc func didPullrefreshControl(_ sender: Any) {
    self.refreshControl.endRefreshing()
  }
}
// MARK: - UITableViewDataSource

extension PageCollectionViewCell: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dummyData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PageTableViewCell.identifier, for: indexPath) as? PageTableViewCell else { return UITableViewCell() }
    cell.selectionStyle = .none
    cell.configure(itemsData: dummyData[indexPath.row])
    return cell
  }
}

// MARK: - UITableViewDelegate

extension PageCollectionViewCell: UITableViewDelegate {  
}
