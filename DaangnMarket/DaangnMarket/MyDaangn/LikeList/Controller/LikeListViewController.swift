//
//  LikeListViewController.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class LikeListViewController: UIViewController {
  // MARK: Views
  
  private let subTitleLabel = UILabel().then {
    $0.font = UIFont.boldSystemFont(ofSize: 14)
    $0.text = "중고거래"
    $0.textColor = .black
    $0.textAlignment = .center
  }
  private let separteLine = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  private var likeListTableView = UITableView().then {
    $0.backgroundColor = .white
  }
  private var refreshControl = UIRefreshControl().then {
    $0.tintColor = UIColor(named: ColorReference.daangnMain.rawValue)
  }
  
  // MARK: Model
  private var likeData: [Post]
  
  // MARK: LifeCycle
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.shadowImage = .none
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: Initialize
  
  init(likeListData: [Post]) {
    self.likeData = likeListData
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    view.backgroundColor = .white
    setupNavigationBar()
    setupTableView()
  }
  
  private func setupNavigationBar() {
    title = "관심목록"
    navigationController?.navigationBar.backgroundColor = .white
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  private func setupTableView() {
    self.likeListTableView.delegate = self
    self.likeListTableView.dataSource = self
    self.likeListTableView.register(LikeListTableViewCell.self, forCellReuseIdentifier: LikeListTableViewCell.identifier)
    self.likeListTableView.refreshControl = self.refreshControl
    self.refreshControl.addTarget(self, action: #selector(didPullrefreshControl(_:)), for: .valueChanged)
  }
  
  private func setupConstraints() {
    let guide = view.safeAreaLayoutGuide
    
    self.subTitleLabel.then { view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(guide).offset(10)
        $0.leading.trailing.equalTo(guide)
    }
    self.separteLine.then { view.addSubview($0) }
      .snp.makeConstraints {
        $0.width.equalTo(view.frame.width)
        $0.height.equalTo(1)
        $0.leading.equalTo(subTitleLabel)
        $0.top.equalTo(subTitleLabel.snp.bottom).offset(10)
    }
    self.likeListTableView.then { view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(separteLine.snp.bottom)
        $0.leading.trailing.bottom.equalTo(guide)
    }
  }
  
  // MARK: Action
  
  @objc func didPullrefreshControl(_ sender: Any) {
    self.likeListTableView.reloadData()
    self.refreshControl.endRefreshing()
  }
}

// MARK: - UITableViewDataSource
extension LikeListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.likeData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: LikeListTableViewCell.identifier, for: indexPath) as? LikeListTableViewCell else { return UITableViewCell() }
    cell.separatorInset = UIEdgeInsets.zero
    cell.configure(likeData: self.likeData[indexPath.row])
    return cell
  }
}

// MARK: - UITableViewDelegate
extension LikeListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let productPostVC = ViewControllerGenerator.shared.make(.productPost, parameters: ["postData": likeData[indexPath.row]]) else { return }
    navigationController?.pushViewController(productPostVC, animated: true)
  }
}

