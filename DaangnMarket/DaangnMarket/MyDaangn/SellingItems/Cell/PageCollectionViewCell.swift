//
//  PageCollectionViewCell.swift
//  DaangnMarket
//
//  Created by Mac mini on 2020/04/11.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol PageCollectionVCDelegate: class {
  func moveToPage(itemData: Post)
}

class PageCollectionViewCell: UICollectionViewCell {
  // MARK: Property
  
  weak var delegate: PageCollectionVCDelegate?
  
  static let identifier = "pageCollectionCell"
  var sellingItemsData: [Post] = []
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
  
  func configure(pageData: [Post]) {
    self.sellingItemsData = pageData
  }
  
  private func setupUI() {
    pageTableView.backgroundColor = UIColor(named: ColorReference.backGray.rawValue)
    self.insetsLayoutMarginsFromSafeArea = false
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
    self.pageTableView.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.trailing.bottom.equalToSuperview()
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
    return sellingItemsData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PageTableViewCell.identifier, for: indexPath) as? PageTableViewCell else { return UITableViewCell() }
    cell.selectionStyle = .none
    cell.configure(itemsData: sellingItemsData[indexPath.row])
    return cell
  }
}

// MARK: - UITableViewDelegate

extension PageCollectionViewCell: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.moveToPage(itemData: sellingItemsData[indexPath.row])
  }
}
