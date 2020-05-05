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
  
  var itemsData: [Post]
  var onSaleData: [Post] = []
  var completedData: [Post] = []
  var tabMenuView = TabMenuView(menuTitles: ["전체", "거래중", "거래완료"])
  
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
  
  init(sellingData: [Post]) {
    self.itemsData = sellingData
    super.init(nibName: nil, bundle: nil)
    // 여기서 거래중과 거래완료 데이터 구분해주기!!!!
    for idx in sellingData {
      if idx.state == "sales" {
        onSaleData.append(idx)
      } else {
        completedData.append(idx)
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.hidesBottomBarWhenPushed = false

    tabBarController?.tabBar.isHidden = false
    self.navigationController?.setNavigationBarHidden(false, animated: true)
    self.navigationController?.navigationBar.barStyle = .default
    self.navigationController?.navigationBar.isTranslucent = false
    //self.navigationController?.automaticallyAdjustsScrollViewInsets = false
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
    view.backgroundColor = .white
    setupNavigationBar()
    setupCollectionView()
    setupConstraints()
  }
  
  private func setupNavigationBar() {
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    UITabBar.appearance().backgroundColor = .white
    navigationController?.navigationBar.shadowImage = UIImage()
    title = "판매 상품 보기"
  }
  
  private func setupCollectionView() {
    itemsCollectionView.contentInsetAdjustmentBehavior = .never
    itemsCollectionView.delegate = self
    itemsCollectionView.dataSource = self
    itemsCollectionView.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: PageCollectionViewCell.identifier)
    itemsCollectionView.register(SalesListEmptyCollectionViewCell.self, forCellWithReuseIdentifier: SalesListEmptyCollectionViewCell.identifier)
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
    switch indexPath.item {
    case 0:
      if !self.itemsData.isEmpty {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCollectionViewCell.identifier, for: indexPath) as? PageCollectionViewCell else { return UICollectionViewCell() }
      cell.configure(pageData: itemsData)
      cell.delegate = self
      return cell
      } else {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SalesListEmptyCollectionViewCell.identifier, for: indexPath) as? SalesListEmptyCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(message: "판매중인 게시글이 없습니당.")
        return cell
      }
    case 1:
      if !self.onSaleData.isEmpty {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCollectionViewCell.identifier, for: indexPath) as? PageCollectionViewCell else { return UICollectionViewCell() }
      cell.configure(pageData: onSaleData)
      cell.delegate = self
      return cell
      } else {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SalesListEmptyCollectionViewCell.identifier, for: indexPath) as? SalesListEmptyCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(message: "거래중인 게시글이 없습니당.")
        return cell
      }
    case 2:
      if !self.completedData.isEmpty {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCollectionViewCell.identifier, for: indexPath) as? PageCollectionViewCell else { return UICollectionViewCell() }
      cell.configure(pageData: completedData)
      cell.delegate = self
      return cell
      } else {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SalesListEmptyCollectionViewCell.identifier, for: indexPath) as? SalesListEmptyCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(message: "거래완료된 게시글이 없습니당.")
        return cell
      }
    default:
      return UICollectionViewCell()
    }
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
    return collectionView.frame.size
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

extension SellingItemsViewController: PageCollectionVCDelegate {
  func moveToPage(itemData: Post) {
    guard let productPostVC = ViewControllerGenerator.shared.make(.productPost, parameters: ["postID": itemData.postId, "postPhotos": itemData.photos]) else { return }
    navigationController?.pushViewController(productPostVC, animated: true)
  }
}
