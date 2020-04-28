//
//  SearchSuccessView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/20.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
//import Kingfisher

class SearchSuccessView: UIView {
  // MARK: Interface
  var searchKeyword = "" {
    didSet {
      tableView.reloadData()
    }
  }
  
  var searchResultPost: [Post] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  
  // MARK: Views
  private lazy var tableView = UITableView().then {
    $0.backgroundColor = UIColor(named: ColorReference.lightBackground.rawValue)
    $0.dataSource = self
    $0.delegate = self
    $0.register(KeywordNotiTableCell.self, forCellReuseIdentifier: KeywordNotiTableCell.identifier)
    $0.register(FilterTableViewCell.self, forCellReuseIdentifier: FilterTableViewCell.identifier)
    $0.register(HomeFeedTableViewCell.self, forCellReuseIdentifier: HomeFeedTableViewCell.identifier)
    $0.tableFooterView = UIView()
  }
  
  // MARK: Intialize
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    self.backgroundColor = UIColor(named: ColorReference.lightBackground.rawValue)
    self.addSubview(tableView)
  }
  
  private func setupConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.size.equalToSuperview()
    }
  }
  
  // MARK: Actions
  @objc private func didTapKeywordNoti() {
    //
  }
}

// MARK: - Extension
extension SearchSuccessView: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    3
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return 1
    case 2:
      return searchResultPost.count
    default:
      return 0
    }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: KeywordNotiTableCell.identifier, for: indexPath)
        as? KeywordNotiTableCell else { fallthrough }
      cell.setupKeywordView(text: searchKeyword)
      return cell
    case 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath)
        as? FilterTableViewCell else { fallthrough }
      return cell
    case 2:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeFeedTableViewCell.identifier, for: indexPath) as? HomeFeedTableViewCell else { fallthrough }
      cell.setupHomeFeedCell(posts: searchResultPost, indexPath: indexPath)
      return cell
    default:
      return UITableViewCell().then { $0.isHidden = true }
    }
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 2 {
      return 0
    } else {
      return 8
    }
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView()
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 2:
      return 134
    default:
      return UITableView.automaticDimension
    }
  }
}

extension SearchSuccessView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let productPostVC = ViewControllerGenerator.shared.make(.productPost, parameters: ["postData": searchResultPost[indexPath.row]]) else { return }
    self.parentViewController?.navigationController?.pushViewController(productPostVC, animated: true)
  }
}
