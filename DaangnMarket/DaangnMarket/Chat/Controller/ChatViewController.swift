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
    $0.delegate = self
    $0.separatorInset = .zero
  }
  
  // MARK: Model
  
  private let model = ChatModel()
  
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
    return self.model.chatList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingCell.identifier, for: indexPath) as? ChattingCell else { return UITableViewCell() }
    cell.configure(chatInfo: self.model.chatList[indexPath.row])
    return cell
  }
}

// MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let bookmarkTitle = self.model.chatList[indexPath.row].isBookmarked ? "즐겨찾기\n해제" : "즐겨찾기"
    let bookmarkAction = UIContextualAction(style: .normal, title: bookmarkTitle) { (_, _, actionPerformed) in
      self.model.chatList[indexPath.row].isBookmarked.toggle()
      tableView.reloadRows(at: [indexPath], with: .automatic)
      actionPerformed(true)
    }
    
    let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (_, _, actionPerformed) in
      self.model.chatList.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      actionPerformed(true)
    }
    
    let configuration = UISwipeActionsConfiguration(actions: [deleteAction, bookmarkAction])
    configuration.performsFirstActionWithFullSwipe = true
    return configuration
  }
}
