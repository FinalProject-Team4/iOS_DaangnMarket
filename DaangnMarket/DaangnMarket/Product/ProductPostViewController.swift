//
//  ProductPostViewController.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ProductPostViewController: UIViewController {
  // MARK: Properties
  
  let postData = PostData.shared
  let viewWidth = UIScreen.main.bounds.width
  let navigationHeight: CGFloat = 90
  
  // MARK: Views
  
  lazy var bottomButtons = BottomButtonsView(price: self.postData.price, nego: false)
  lazy var navigationBar = CustomNavigationBarView()
  private let tableView = UITableView().then {
    $0.backgroundColor = .white
    $0.contentInsetAdjustmentBehavior = .never
  }
  lazy var hScrollView = ImagesScrollView(items: postData.postImageSet)
  let pageControl = UIPageControl().then {
    $0.pageIndicatorTintColor = UIColor(named: ColorReference.noResultImage.rawValue)
    $0.currentPageIndicatorTintColor = .white
  }
  let spinner = UIActivityIndicatorView().then {
    $0.color = .white
    $0.style = .large
    $0.hidesWhenStopped = true
  }
  
  // MARK: Initialize
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(false)
    UIApplication.shared.statusBarStyle = .darkContent
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    navigationBar.delegate = self
    UIApplication.shared.statusBarStyle = .darkContent
    navigationController?.navigationBar.isHidden = true
    self.tabBarController?.tabBar.isHidden = true
    view.backgroundColor = .white
    //pageControl.numberOfPages = dummy.postImageSet.count
    pageControl.numberOfPages = postData.postImageSet.count
    hScrollView.delegate = self
    setupTableView()
    if !postData.postImageSet.isEmpty {
      setupScrollView()
      UIApplication.shared.statusBarStyle = .lightContent
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
        if !postData.postImageSet.isEmpty {
          $0.top.equalTo(view)
        } else {
          $0.top.equalTo(view).offset(91)
        }
        $0.leading.trailing.equalTo(guide)
        $0.bottom.equalTo(bottomButtons.snp.top)
    }
    if !postData.postImageSet.isEmpty {
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
    tableView.contentInset = .init(top: viewWidth, left: 0, bottom: 0, right: 0)
    tableView.contentOffset = CGPoint(x: 0, y: -viewWidth)
    self.tableView.addSubview(hScrollView)
    hScrollView.frame = CGRect(x: 0, y: -viewWidth, width: viewWidth, height: viewWidth)
    hScrollView.contentSize = CGSize(width: viewWidth * CGFloat(postData.postImageSet.count), height: viewWidth)
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
    if !postData.postImageSet.isEmpty {
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
      cell.configure(image: UIImage(named: "sellerImage1"), sellerId: postData.username, addr: postData.address)
      cell.selectionStyle = .none
      return cell
    case 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentsTableViewCell.identifier, for: indexPath) as? ContentsTableViewCell else { return UITableViewCell() }
      var item: [String] = []
      item.append(postData.title)
      item.append(postData.updated)
      item.append(postData.category)
      item.append(postData.content)
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
      let others = [["others1", "미니 스트랩백", "20,000원"], ["others2", "수박 에어팟케이스", "5,000원"], ["others3", "벙거지모자", "10,000원"], ["others4", "데님 원피스", "20,000원"]]
      let name = postData.username
      cell.delegate = self
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
    let tempOtherItems = ["0", "1", "2", "3"]
    if indexPath.section == 3 {
      if tempOtherItems.isEmpty {
        return 0
      } else if tempOtherItems.count > 2 {
        return viewWidth + (CGFloat(16) * 3)
      } else {
        return ( viewWidth + (CGFloat(16) * 3)) / 1.8
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
    if offset.y < -viewWidth {
      spinner.startAnimating()
      hScrollView.frame = CGRect(x: 0, y: offset.y, width: viewWidth, height: -offset.y)
      let index = Int(hScrollView.contentOffset.x / viewWidth)
      self.hScrollView.imageViews[index].frame = CGRect(x: viewWidth * CGFloat(index), y: 0, width: viewWidth, height: -offset.y)
    }
    if tableView.contentOffset.y > -viewWidth / 2.5 {
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
      let pageNumber = Int(floor((offset - viewWidth / 2) / viewWidth) + 1)
      pageControl.currentPage = pageNumber
    }
  }
}
// MARK: - CustomNavigationBarViewDelegate

extension ProductPostViewController: CustomNavigationBarViewDelegate {
  func goBackPage() {
    navigationController?.popViewController(animated: true)
  }
}

extension ProductPostViewController: OtherItemsTableViewCellDelegate {
  func moveToPage() {
    guard let productPostVC = ViewControllerGenerator.shared.make(.productPost) else { return }
    navigationController?.pushViewController(productPostVC, animated: true)
  }
}
