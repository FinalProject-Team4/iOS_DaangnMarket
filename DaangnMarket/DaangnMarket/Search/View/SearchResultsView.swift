//
//  SearchResultsView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class SearchResultsView: UIView {
  private lazy var tableView = UITableView().then {
    $0.dataSource = self
    $0.delegate = self
    $0.register(HomeFeedTableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  private let headerView = UIView().then {
    $0.backgroundColor = .white
  }
  
  private let searchFilterButton = UIButton().then {
    $0.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
    $0.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
    $0.tintColor = .black
    $0.setTitle("  검색 필터", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 13)
  }
  
  private let soldoutFilterButton = UIButton().then {
    $0.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
    $0.tintColor = .gray
    $0.setTitle("  거래완료 안보기", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 13)
  }
  
  private var dummyData: [String] = []
  
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
    self.addSubview(tableView)
    headerView.addSubview(searchFilterButton)
    headerView.addSubview(soldoutFilterButton)
  }
  
  private func setupConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    searchFilterButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8)
      $0.bottom.equalToSuperview().offset(-8)
      //      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(14)
//      $0.width.equalToSuperview().multipliedBy(0.3)
    }
    soldoutFilterButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8)
      $0.bottom.equalToSuperview().offset(-8)
      $0.trailing.equalToSuperview().offset(-14)
    }
  }
  
  func makeProductList(keyWord: String) {
    // keyword 서버에 보내서, List 받아서, 다시 뿌리면 되겠지?
    tableView.reloadData()
  }
}

extension SearchResultsView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    headerView
  }
}

extension SearchResultsView: UITableViewDelegate {
//
}
