//
//  CategoryViewController.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
  // MARK: Views
  private let scrollView = UIScrollView()
  private let categoryStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution =
      .fillEqually
  }
  private let headerView = CategoryItemView(headerText: "우리동네 중고거래")
  
  // MARK: Properties
  private lazy var itemViews = [CategoryItemView]()
  
  
  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: Initialize
  private func setupUI() {
    setNavigation()
    setupAttributes()
    setupConstraints()
  }
  
  private func setNavigation() {
    self.title = "카테고리"
    self.navigationController?.navigationBar.barTintColor = .white
    let searchBtn = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapNaviItem(_:)))
      .then {
        $0.imageInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        $0.tag = 0
    }
    let notiBtn = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(didTapNaviItem(_:)))
      .then {
        $0.imageInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        $0.tag = 1
    }
    self.navigationItem.rightBarButtonItems = [notiBtn, searchBtn]
    self.navigationItem.rightBarButtonItems?.forEach { $0.tintColor = .black }
  }
  
  private func setupAttributes() {
    view.backgroundColor = .white
    view.addSubview(scrollView)
    scrollView.addSubview(headerView)
    scrollView.addSubview(categoryStackView)
    categoryStackView.addArrangedSubview(headerView)
    makeCategoryItems().forEach { categoryStackView.addArrangedSubview($0) }
  }
  
  private func setupConstraints() {
    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.size.equalToSuperview()
    }
    categoryStackView.snp.makeConstraints {
      $0.width.equalTo(UIScreen.main.bounds.width)
      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
    }
  }
  
  private func makeCategoryItems() -> [CategoryItemView] {
    let hotDealView = CategoryItemView(image: UIImage(named: "hotDeal")!, text: "인기매물")
    itemViews.append(hotDealView)
    
    let imageNames: [String]  = DGCategory.allCases.map { $0.rawValue }
    let titleNames: [String] = DGCategory.allCases.map { $0.korean }
    for idx in 0..<imageNames.count {
      let itemView = CategoryItemView(image: UIImage(named: imageNames[idx]) ?? UIImage(named: "hotDeal")!, text: titleNames[idx])
      itemViews.append(itemView)
    }
    
    itemViews.forEach { itemViews.append($0) }
    return itemViews
  }
  
  // MARK: Actions
  @objc private func didTapNaviItem(_ sender: UIBarButtonItem) {
    switch sender.tag {
    case 0:
      print("SearchViewController")
    default:
      print("NotiViewController")
    }
  }
  
  @objc func didTapItem(_ sender: CategoryItemView) {
    // pushViewController -> FeedVC(category: String)
  }
}
