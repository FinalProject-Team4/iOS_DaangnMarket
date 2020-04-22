//
//  SalesListViewController.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class SalesListViewController: UIViewController {
  
  // MARK: Property
  
  var tabMenuView = TabMenuView(menuTitles: ["판매중", "거래완료", "숨김"])
  
  // MARK: Views
  
  private let flowLayout = UICollectionViewFlowLayout().then {
    $0.scrollDirection = .horizontal
  }
  private lazy var salesListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
    $0.backgroundColor = .white
    $0.showsHorizontalScrollIndicator = false
    $0.isPagingEnabled = true
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.shadowImage = .none
  }
  
  // MARK: Initialize
  
  init(salesListData: [Post]) {
    super.init(nibName: nil, bundle: nil)
    SalesListData.shared.hiddenData = []
    SalesListData.shared.onSaleData = []
    SalesListData.shared.endOfSaleData = []
    for idx in 0..<salesListData.count {
      if salesListData[idx].state == "done" {
        SalesListData.shared.endOfSaleData.append(salesListData[idx])
      } else {
        SalesListData.shared.onSaleData.append(salesListData[idx])
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    view.backgroundColor = .white
    tabMenuView.delegate = self
    setupNavigationBar()
    setupCollectionView()
    setupConstraints()
  }
  
  private func setupNavigationBar() {
    title = "판매내역"
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    navigationController?.navigationBar.backgroundColor = .white
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  private func setupCollectionView() {
    salesListCollectionView.delegate = self
    salesListCollectionView.dataSource = self
    salesListCollectionView.register(SalesListOnSaleCollectionViewCell.self, forCellWithReuseIdentifier: SalesListOnSaleCollectionViewCell.identifier)
    salesListCollectionView.register(SalesListEndOfSalesCollectionViewCell.self, forCellWithReuseIdentifier: SalesListEndOfSalesCollectionViewCell.identifier)
    salesListCollectionView.register(SalesListHiddenCollectionViewCell.self, forCellWithReuseIdentifier: SalesListHiddenCollectionViewCell.identifier)
    salesListCollectionView.register(SalesListEmptyCollectionViewCell.self, forCellWithReuseIdentifier: SalesListEmptyCollectionViewCell.identifier)
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
    self.salesListCollectionView.then { view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(tabMenuView.snp.bottom)
        $0.leading.trailing.bottom.equalTo(guide)
    }
  }
}
// MARK: - UICollectionViewDataSource

extension SalesListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.item {
    case 0:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SalesListOnSaleCollectionViewCell.identifier, for: indexPath) as? SalesListOnSaleCollectionViewCell else { return UICollectionViewCell() }
      cell.delegate = self
      cell.configure(onSale: SalesListData.shared.onSaleData)
      //cell.configure(self)
      return cell
    case 1:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SalesListEndOfSalesCollectionViewCell.identifier, for: indexPath) as? SalesListEndOfSalesCollectionViewCell else { return UICollectionViewCell() }
      cell.configure(endOfSale: SalesListData.shared.endOfSaleData)
      cell.delegate = self
      return cell
      
    case 2:
      if !SalesListData.shared.hiddenData.isEmpty {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SalesListHiddenCollectionViewCell.identifier, for: indexPath) as? SalesListHiddenCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(hidden: SalesListData.shared.hiddenData)
        cell.delegate = self
        return cell
      } else {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SalesListEmptyCollectionViewCell.identifier, for: indexPath) as? SalesListEmptyCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(message: "숨기기한 게시글이 없습니당.")
        return cell
      }
      
    default:
      return UICollectionViewCell()
    }
  }
}
// MARK: - UICollectionViewDelegateFlowLayout

extension SalesListViewController: UICollectionViewDelegateFlowLayout {
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

extension SalesListViewController: TabMenuViewDelegate {
  func tabBarMenu(scrollTo index: Int) {
    let indexPath = IndexPath(row: index, section: 0)
    self.salesListCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
}

// MARK: - SalesListOnSaleCVCDelegate

extension SalesListViewController: SalesListOnSaleCVCDelegate {
  func moveToEndOfSalePage() {
    navigationController?.pushViewController(EndOfSaleViewController(), animated: true)
  }
  
  func moveToPage(onSale: Post) {
    guard let productPostVC = ViewControllerGenerator.shared.make(.productPost, parameters: ["postData": onSale]) else { return }
    navigationController?.pushViewController(productPostVC, animated: true)
  }
  
  func onSaleOptionDelever() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let edit = UIAlertAction(title: "수정", style: .default) { _ in
      print("수정")
    }
    let pullUp = UIAlertAction(title: "끌어 올리기", style: .default) { _ in
      print("끌어 올리기")
    }
    let hide = UIAlertAction(title: "숨기기", style: .default) { _ in
      print("숨기기")
    }
    let delete = UIAlertAction(title: "게시물 삭제", style: .destructive) { _ in
      print("게시물 삭제")
    }
    let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
      print("취소")
    }
    [edit, pullUp, hide, delete, cancel].forEach {
      alert.addAction($0)
    }
    self.present(alert, animated: true)
  }
}
// MARK: - SalesListEndOfSalesCVCDelegate

extension SalesListViewController: SalesListEndOfSalesCVCDelegate {
  func endOfSalesOptionDelever() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let changeState = UIAlertAction(title: "판매중으로 변경", style: .default) { _ in
      print("판매중으로 변경")
    }
    let hide = UIAlertAction(title: "숨기기", style: .default) { _ in
      print("숨기기")
    }
    let delete = UIAlertAction(title: "게시물 삭제", style: .destructive) { _ in
      print("게시물 삭제")
    }
    let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
      print("취소")
    }
    [changeState, hide, delete, cancel].forEach {
      alert.addAction($0)
    }
    self.present(alert, animated: true)
  }
  
  func moveToPage(endOfSale: Post) {
    guard let productPostVC = ViewControllerGenerator.shared.make(.productPost, parameters: ["postData": endOfSale]) else { return }
    navigationController?.pushViewController(productPostVC, animated: true)
  }
}

// MARK: - SalesListHiddenCVCDelegate
extension SalesListViewController: SalesListHiddenCVCDelegate {
  func hiddenOptionDeliver() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let edit = UIAlertAction(title: "수정", style: .default) { _ in
      print("수정")
    }
    let delete = UIAlertAction(title: "게시물 삭제", style: .destructive) { _ in
      print("게시물 삭제")
    }
    let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
      print("취소")
    }
    [edit, delete, cancel].forEach {
      alert.addAction($0)
    }
    self.present(alert, animated: true)
  }
  
  func moveToPage(hidden: Post) {
    guard let productPostVC = ViewControllerGenerator.shared.make(.productPost, parameters: ["postData": hidden]) else { return }
    navigationController?.pushViewController(productPostVC, animated: true)
  }
}

