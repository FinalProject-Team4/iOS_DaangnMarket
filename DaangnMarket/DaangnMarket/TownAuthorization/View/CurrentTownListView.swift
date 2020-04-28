//
//  CurrentTownListView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol CurrentTownListViewDelegate: class {
  func selectedTown(_ town: String)
}

class CurrentTownListView: UIView {
  // MARK: Views
  //  private var stackView = UIStackView().then {
  //    $0.axis = .vertical
  //    $0.alignment = .leading
  //    $0.distribution = .equalSpacing
  //    $0.spacing = 16
  //  }
  //  private var itemViewList: [UIControl] = []
  
  private lazy var tableView = UITableView().then {
    $0.dataSource = self
    $0.delegate = self
    $0.separatorStyle = .none
    $0.showsVerticalScrollIndicator = false
    $0.rowHeight = 36
    $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  // MARK: Properties
  weak var viewDelegate: CurrentTownListViewDelegate?
  private var townList: [String] {
    didSet {
      tableView.reloadData()
    }
  }
  
  // MARK: Initialize
  init(list: [String]) {
    townList = list
    super.init(frame: .zero)
    setupTableView()
    //    setupUI()
    //    setupListView(list)
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupTableView() {
    self.addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
        .inset(UIEdgeInsets(top: 0, left: -10, bottom: 8, right: -10))
    }
  }
  
  //  private func setupUI() {
  //    self.addSubview(stackView)
  //    self.showsVerticalScrollIndicator = false
  //    stackView.snp.makeConstraints {
  //      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
  //    }
  //  }
  
  //  private func setupListView(_ list: [String]) {
  //    for item in list {
  //      let itemView = CurrentTownListItemView(item)
  //      itemView.backgroundColor = .yellow
  //      itemView.tag = list.firstIndex(of: item)!
  //      itemView.addTarget(self, action: #selector(didTapItemView(_:)), for: .touchDown)
  //      stackView.addArrangedSubview(itemView)
  //      itemView.snp.makeConstraints {
  //        $0.width.equalTo(UIScreen.main.bounds.width * 0.7)
  //        $0.height.equalTo(24)
  //      }
  //    }
  //  }
  
  // MARK: Actions
  //  @objc private func didTapItemView(_ sender: CurrentTownListItemView) {
  //    for item in stackView.subviews {
  //      guard let item = item as? CurrentTownListItemView else { return }
  //      sender == item ? item.didSelectItem() : item.didDeSelectItem()
  //    }
  //    self.viewDelegate?.selectedTag(sender.tag)
  //  }
}

extension CurrentTownListView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    townList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.selectionStyle = .none
    cell.textLabel?.text = townList[indexPath.row]
    cell.imageView?.image = UIImage(systemName: "checkmark.circle")
    cell.imageView?.tintColor = .lightGray
    return cell
  }
}

extension CurrentTownListView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    cell.imageView?.image = UIImage(systemName: "checkmark.circle.fill")
    cell.imageView?.tintColor = UIColor(named: ColorReference.daangnMain.rawValue)
    guard let text = cell.textLabel?.text else { return }
    self.viewDelegate?.selectedTown(text)
  }
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    cell.imageView?.image = UIImage(systemName: "checkmark.circle")
    cell.imageView?.tintColor = .lightGray
  }
}
