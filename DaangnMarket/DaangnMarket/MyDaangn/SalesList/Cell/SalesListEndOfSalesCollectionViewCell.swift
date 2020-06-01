//
//  SalesListEndOfSalesCollectionViewCell.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol SalesListEndOfSalesCVCDelegate: class {
  func endOfSalesOptionDelever(itemPostID: Int)
  func moveToPage(endOfSale: Post)
}

class SalesListEndOfSalesCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  
  weak var delegate: SalesListEndOfSalesCVCDelegate?
  var endOfSaleData: [Post] = []
  
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
    salesListTableView.register(SalesListEndOfSalesTableViewCell.self, forCellReuseIdentifier: SalesListEndOfSalesTableViewCell.identifier)
    salesListTableView.refreshControl = self.refreshControl
    refreshControl.addTarget(self, action: #selector(didPullrefreshControl(_:)), for: .valueChanged)
  }
  
  private func setupConstraints() {
    self.salesListTableView.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  func configure(endOfSale: [Post]) {
    self.endOfSaleData = endOfSale
    self.salesListTableView.reloadData()
  }
  @objc func didPullrefreshControl(_ sender: Any) {
    self.salesListTableView.reloadData()
     self.refreshControl.endRefreshing()
   }
}

// MARK: - UITableViewDataSource

extension SalesListEndOfSalesCollectionViewCell: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return endOfSaleData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SalesListEndOfSalesTableViewCell.identifier, for: indexPath) as? SalesListEndOfSalesTableViewCell else { return UITableViewCell() }
    cell.selectionStyle = .none
    cell.itemContentView.completedDeal(isCompleted: true)
    cell.configure(endOfSale: endOfSaleData[indexPath.row])
    cell.delegate = self
    return cell
  }
}

// MARK: - UITableViewDelegate

extension SalesListEndOfSalesCollectionViewCell: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.moveToPage(endOfSale: endOfSaleData[indexPath.row])
  }
}

// MARK: - SalesListEndOfSalesTVCDelegate

extension SalesListEndOfSalesCollectionViewCell: SalesListEndOfSalesTVCDelegate {
  func endOfSalesOption(postID: Int) {
    delegate?.endOfSalesOptionDelever(itemPostID: postID)
  }
}
