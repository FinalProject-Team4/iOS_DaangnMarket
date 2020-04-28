//
//  SalesListOnSaleCollectionViewCell.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol SalesListOnSaleCVCDelegate: class {
  func onSaleOptionDelever()
  func moveToPage(onSale: Post)
  func changeStateButton(itemPostID: Int, salesState: String)
  func changeToEndOfSalesButton(itemPostID: Int, postTitle: String)
}

class SalesListOnSaleCollectionViewCell: UICollectionViewCell {
  // MARK: Properties
  
  weak var delegate: SalesListOnSaleCVCDelegate?
  var onSaleData: [Post] = []
  
  // MARK: Views
  
  var salesListTableView = UITableView()
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
    salesListTableView.refreshControl = self.refreshControl
    refreshControl.addTarget(self, action: #selector(didPullrefreshControl(_:)), for: .valueChanged)
    salesListTableView.register(SalesListOnSaleTableViewCell.self, forCellReuseIdentifier: SalesListOnSaleTableViewCell.identifier)
  }
  
  private func setupConstraints() {
    self.salesListTableView.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  // MARK: Interface
  
  func configure(onSale: [Post]) {
    self.onSaleData = onSale
    self.salesListTableView.reloadData()
  }
  
  // MARK: Action
  
  @objc func didPullrefreshControl(_ sender: Any) {
    self.salesListTableView.reloadData()
    self.refreshControl.endRefreshing()
  }
}
// MARK: - UITableViewDataSource

extension SalesListOnSaleCollectionViewCell: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return onSaleData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SalesListOnSaleTableViewCell.identifier, for: indexPath) as? SalesListOnSaleTableViewCell else { return UITableViewCell() }
    cell.delegate = self
    cell.selectionStyle = .none
    cell.configure(onSale: onSaleData[indexPath.row])
    return cell
  }
}
// MARK: - UITableViewDelegate

extension SalesListOnSaleCollectionViewCell: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.moveToPage(onSale: onSaleData[indexPath.row])
  }
}
// MARK: - SalesListOnSaleTVCDelegate

extension SalesListOnSaleCollectionViewCell: SalesListOnSaleTVCDelegate {
  func onSaleOption() {
    delegate?.onSaleOptionDelever()
  }
  
  func stateChange(postID: Int, state: String) {
    //여기서 받은 postID를 다시 ViewController로 넘겨주기!!!!
    delegate?.changeStateButton(itemPostID: postID, salesState: state)
  }
  
  func changeToEndOfSales(postID: Int, title: String) {
    delegate?.changeToEndOfSalesButton(itemPostID: postID, postTitle: title)
  }
}
