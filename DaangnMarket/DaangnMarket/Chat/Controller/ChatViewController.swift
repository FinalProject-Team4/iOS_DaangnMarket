//
//  ChatViewController.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
  // MARK: Views
  
  private lazy var chatTableView = UITableView().then {
    $0.tableFooterView = UIView()
    $0.register(ChattingCell.self, forCellReuseIdentifier: ChattingCell.identifier)
    $0.dataSource = self
    $0.separatorInset = .zero
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
  }
  
  // MARK: Initialize
  
  private func setupUI() {
    self.setupAttributes()
    self.setupConstraints()
  }
  
  private func setupAttributes() {
    self.view.backgroundColor = .systemBackground
    self.navigationItem.title = "채팅"
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
  }
  
  private func setupConstraints() {
    self.chatTableView
      .then { self.view.addSubview($0) }
      .snp.makeConstraints { $0.edges.equalTo(self.view.safeAreaLayoutGuide) }
  }
}

// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ChattingCell.identifier, for: indexPath)
    return cell
  }
}
