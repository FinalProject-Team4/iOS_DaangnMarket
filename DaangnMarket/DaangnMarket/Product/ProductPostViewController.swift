//
//  ProductPostViewController.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ProductPostViewController: UIViewController {
  // MARK: Views
  
  lazy var bottomButtons = BottomButtonsView(price: self.dummy.price, nego: dummy.isNegociable)
  lazy var navigationBar = CustomNavigationBarView()
  private let tableView = UITableView().then {
    $0.backgroundColor = .white
    $0.contentInsetAdjustmentBehavior = .never
  }
  lazy var hScrollView = ImagesScrollView(items: dummy.images)
  let pageControl = UIPageControl().then {
    $0.pageIndicatorTintColor = UIColor(named: ColorReference.noResultImage.rawValue)
    $0.currentPageIndicatorTintColor = .white
  }
  let spinner = UIActivityIndicatorView().then {
    $0.color = .white
    $0.style = .large
    $0.hidesWhenStopped = true
  }
  
  // MARK: Model
  
  var dummy = dummyData1
  // dummyData1 : 가격제안불가, 다른 판매상품 4개, dummyData2 : 가격제안 가능, 다른 판매상품 2개, dummyData3: 다른 판매상품 없는 경우, dummyData4 : 상품이미지 없는 경우
  
  // MARK: Properties
  
  let headerWidth = UIScreen.main.bounds.width
  let navigationHeight: CGFloat = 90
  
  // MARK: Initialize
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    UIApplication.shared.statusBarStyle = .lightContent
    navigationController?.isNavigationBarHidden = true
    view.backgroundColor = .white
    pageControl.numberOfPages = dummy.images.count
    hScrollView.delegate = self
    setupTableView()
    if dummy.isImage {
      setupScrollView()
    }
  }
  
  private func setupConstraints() {
    let guide = view.safeAreaLayoutGuide
    
    self.bottomButtons.then { view.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.bottom.trailing.equalTo(guide)
    }
    self.tableView
      .then { view.addSubview($0) }
      .snp.makeConstraints {
        if dummy.isImage {
          $0.top.equalTo(view)
        } else {
          $0.top.equalTo(view).offset(91)
        }
        $0.leading.trailing.equalTo(guide)
        $0.bottom.equalTo(bottomButtons.snp.top)
    }
    if dummy.isImage {
      self.pageControl.then { tableView.addSubview($0) }
        .snp.makeConstraints {
          $0.centerX.equalTo(tableView)
          $0.bottom.equalTo(hScrollView)
      }
      self.spinner.then { tableView.addSubview($0) }
        .snp.makeConstraints {
          $0.centerX.equalTo(view)
          $0.centerY.equalTo(hScrollView)
      }
    }
    view.addSubview(navigationBar)
  }
  
  private func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorStyle = .none
    tableView.register(SellerInformationTableViewCell.self, forCellReuseIdentifier: SellerInformationTableViewCell.identifier)
    tableView.register(ContentsTableViewCell.self, forCellReuseIdentifier: ContentsTableViewCell.identifier)
    tableView.register(OtherItemsTableViewCell.self, forCellReuseIdentifier: OtherItemsTableViewCell.identifier)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  private func setupScrollView() {
    tableView.contentInset = .init(top: headerWidth, left: 0, bottom: 0, right: 0)
    tableView.contentOffset = CGPoint(x: 0, y: -headerWidth)
    self.tableView.addSubview(hScrollView)
    hScrollView.frame = CGRect(x: 0, y: -headerWidth, width: headerWidth, height: headerWidth)
    hScrollView.contentSize = CGSize(width: headerWidth * CGFloat(dummy.images.count), height: headerWidth)
  }
  
  // MARK: Actions
  
  private func whiteBackNavigationBar() {
    navigationBar.gradientLayer.backgroundColor = UIColor.white.cgColor
    navigationBar.gradientLayer.colors = [UIColor.white.cgColor]
    [navigationBar.backButton, navigationBar.sendOptionButton, navigationBar.otherOptionButton].forEach {
      $0.tintColor = .black
    }
    navigationBar.lineView.isHidden = false
    UIApplication.shared.setStatusBarStyle(.darkContent, animated: true)
  }
  
  private func blackBackNavigationBar() {
    if dummy.isImage {
      navigationBar.gradientLayer.backgroundColor = UIColor.clear.cgColor
      navigationBar.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.clear.cgColor]
      [navigationBar.backButton, navigationBar.sendOptionButton, navigationBar.otherOptionButton].forEach {
        $0.tintColor = .white
      }
      navigationBar.lineView.isHidden = true
      UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
    }
  }
}
// MARK: - UITableViewDataSouce

extension ProductPostViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: SellerInformationTableViewCell.identifier, for: indexPath) as? SellerInformationTableViewCell else { return UITableViewCell() }
      let seller = dummy.seller
      cell.configure(image: UIImage(named: seller[0]), sellerId: seller[1], addr: seller[2])
      cell.selectionStyle = .none
      return cell
    case 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentsTableViewCell.identifier, for: indexPath) as? ContentsTableViewCell else { return UITableViewCell() }
      let item = dummy.contents
      cell.selectionStyle = .none
      cell.configure(contents: item)
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      cell.selectionStyle = .none
      cell.textLabel?.text = "이 게시글 신고하기"
      cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
      return cell
    case 3:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherItemsTableViewCell.identifier, for: indexPath) as? OtherItemsTableViewCell else { return UITableViewCell() }
      let others = dummy.otherItems
      let name = dummy.seller[1]
      cell.configure(items: others, sellerName: name)
      cell.selectionStyle = .none
      return cell
    default :
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      cell.textLabel?.text = "\(indexPath.section)"
      return cell
    }
  }
}
// MARK: - UITableViewDelegate

extension ProductPostViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 3 {
      if dummy.otherItems.isEmpty {
        return 0
      } else if dummy.otherItems.count > 2 {
        return headerWidth + (CGFloat(16) * 3)
      } else {
        return ( headerWidth + (CGFloat(16) * 3)) / 1.8
      }
    } else {
      return UITableView.automaticDimension
    }
  }
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 400
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = scrollView.contentOffset
    if offset.y < -headerWidth {
      spinner.startAnimating()
      hScrollView.frame = CGRect(x: 0, y: offset.y, width: headerWidth, height: -offset.y)
      let index = Int(hScrollView.contentOffset.x / headerWidth)
      self.hScrollView.imageViews[index].frame = CGRect(x: headerWidth * CGFloat(index), y: 0, width: headerWidth, height: -offset.y)
    }
    if tableView.contentOffset.y > -headerWidth / 2.5 {
      whiteBackNavigationBar()
    } else {
      blackBackNavigationBar()
    }
  }
}
// MARK: - UIScrollViewDelegate

extension ProductPostViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    spinner.stopAnimating()
    if scrollView == hScrollView {
      let offset = scrollView.contentOffset.x
      let pageNumber = Int(floor((offset - headerWidth / 2) / headerWidth) + 1)
      pageControl.currentPage = pageNumber
    }
  }
}


