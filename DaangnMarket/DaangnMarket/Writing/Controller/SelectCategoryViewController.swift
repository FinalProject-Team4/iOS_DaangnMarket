//
//  SelectCategoryViewController.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/03/27.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

// MARK: - Class Level
class SelectCategoryViewController: UIViewController {
  static let cellID = "SelectCategoryCell"
  
  // MARK: Views
  
  private lazy var categoryTableView = UITableView().then {
    $0.dataSource = self
    $0.delegate = self
    $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    $0.tableFooterView = UIView()
    $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  // MARK: Properties
  
  private var currentCategory: String?
  
  private let categoryArr = DGCategory.allCases.map { $0.korean }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: Initialize
  
  init(category: String) {
    super.init(nibName: nil, bundle: nil)
    currentCategory = category.contains("카테고리 선택") ? nil : category
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupNavigation()
    setupAttributes()
    setupConstraints()
  }
  
  private func setupNavigation() {
    self.title = "카테고리 선택"
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationController?.navigationBar.topItem?.title = ""
    self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.left")
    self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
  }
  
  private func setupAttributes() {
    view.backgroundColor = .white
    view.addSubview(categoryTableView)
  }
  
  private func setupConstraints() {
    categoryTableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

// MARK: - Extension Level
extension SelectCategoryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryArr.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    if categoryArr[indexPath.row] == currentCategory {
      cell.textLabel?.textColor = .orange
      cell.tintColor = .orange
      cell.accessoryView = UIImageView(image: UIImage(systemName: "checkmark"))
        .then { $0.frame = CGRect(x: 0, y: 0, width: 12, height: 12) }
    }
    cell.textLabel?.text = categoryArr[indexPath.row]
    return cell
  }
}

extension SelectCategoryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectCategory = categoryArr[indexPath.row]
    let writeVC = navigationController?.viewControllers.first! as? WriteUsedViewController
    writeVC?.currentCategory = selectCategory
    self.navigationController?.popViewController(animated: true)
  }
}
