//
//  SellingItemsViewController.swift
//  DaangnMarket
//
//  Created by Mac mini on 2020/04/12.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class SellingItemsViewController: UIViewController {
  // MARK: Properties
  
  var itemsData = dummyItemsData
  var tabMenuView = TabMenuView()
  
  // MARK: Views
  
  private let flowLayout = UICollectionViewFlowLayout().then {
    $0.scrollDirection = .horizontal
  }
  private lazy var itemsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
    $0.backgroundColor = .white
    $0.showsHorizontalScrollIndicator = false
    $0.isPagingEnabled = true
  }
  
  // MARK: Initializes
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.hidesBottomBarWhenPushed = false
    self.navigationController?.setNavigationBarHidden(false, animated: true)
    self.navigationController?.navigationBar.barStyle = .default
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.hidesBottomBarWhenPushed = true
    tabBarController?.tabBar.isHidden = true
     navigationController?.navigationBar.shadowImage = .none
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func setupUI() {
    tabMenuView.delegate = self
    setupNavigationBar()
    setupCollectionView()
    setupConstraints()
  }
  
  private func setupNavigationBar() {
    UITabBar.appearance().backgroundColor = .white
    navigationController?.navigationBar.shadowImage = UIImage()
    title = "판매 상품 보기"
  }
  
  private func setupCollectionView() {
    itemsCollectionView.delegate = self
    itemsCollectionView.dataSource = self
    itemsCollectionView.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: PageCollectionViewCell.identifier)
  }
  
  private func setupConstraints() {
    let guide = view.safeAreaLayoutGuide
    let tabMenuHeight: CGFloat = 58
    
    tabMenuView.indicatorViewWidthConstraint?.constant = self.view.frame.width / 3
    self.tabMenuView.then { view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.trailing.equalTo(guide)
        $0.height.equalTo(tabMenuHeight)
    }
    self.itemsCollectionView.then { view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(tabMenuView.snp.bottom)
        $0.leading.trailing.bottom.equalTo(guide)
    }
  }
}
// MARK: - UICollectionViewDataSource

extension SellingItemsViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCollectionViewCell.identifier, for: indexPath) as? PageCollectionViewCell else { return UICollectionViewCell() }
    
    return cell
  }
}
// MARK: - UICollectionViewDelegateFlowLayout

extension SellingItemsViewController: UICollectionViewDelegateFlowLayout {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.tabMenuView.indicatorViewLeadingConstraint?.constant = scrollView.contentOffset.x / 3
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
    let indexPath = IndexPath(item: itemAt, section: 0)
    self.tabMenuView.tabMenuCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    collectionView.frame.size
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}
// MARK: - TabMenuViewDelegate

extension SellingItemsViewController: TabMenuViewDelegate {
  func tabBarMenu(scrollTo index: Int) {
    let indexPath = IndexPath(row: index, section: 0)
    self.itemsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
}
