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
    
    var postData1: Post
    let viewWidth = UIScreen.main.bounds.width
    
    // MARK: Views
    
    lazy var bottomButtons = BottomButtonsView(price: postData1.price, nego: false)
    lazy var navigationBar = CustomNavigationBarView()
    private let tableView = UITableView().then {
      $0.backgroundColor = .white
      $0.contentInsetAdjustmentBehavior = .never
    }
    private var imageSet: [String] = []
    lazy var hScrollView = ImagesScrollView(items: imageSet)
    let pageControl = UIPageControl().then {
      $0.pageIndicatorTintColor = UIColor(named: ColorReference.noResultImage.rawValue)
      $0.currentPageIndicatorTintColor = .white
    }
    let spinner = UIActivityIndicatorView().then {
      $0.color = .white
      $0.style = .large
      $0.hidesWhenStopped = true
    }
    
 // MARK: Life Cycle
    
    override func viewDidLoad() {
      super.viewDidLoad()
      setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      navigationController?.navigationBar.isHidden = true
      if tableView.contentOffset.y < -viewWidth / 2.5 {
        navigationController?.navigationBar.barStyle = .black
      }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      navigationController?.navigationBar.shadowImage = UIImage()
      navigationController?.navigationBar.barStyle = .default
      navigationController?.navigationBar.isHidden = false
      self.hidesBottomBarWhenPushed = false
    }
  
  // MARK: Initialize
    
    init(postData: Post) {
      self.postData1 = postData
      super.init(nibName: nil, bundle: nil)
//      let temp = postData1.postImageSet
//      for idx in 0..<temp.count {
//        imageSet.append(temp[idx].photo)
//      }
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
      setupNavigationBar()
      setupAttributes()
      setupConstraints()
      self.setNeedsStatusBarAppearanceUpdate()
    }
    private func setupNavigationBar() {
      navigationBar.delegate = self
      self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
      let size: CGFloat = 4
      let backImage = UIImage(systemName: "arrow.left")!.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: size, right: 0))
      navigationController?.navigationBar.backIndicatorImage = backImage
      navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
    }
    
    private func setupAttributes() {
      view.backgroundColor = .white
      pageControl.numberOfPages = imageSet.count
      hScrollView.delegate = self
      setupTableView()
      if !imageSet.isEmpty {
        setupScrollView()
        navigationController?.navigationBar.barStyle = .black
      } else {
        navigationController?.navigationBar.barStyle = .default
      }
    }
    
    private func setupConstraints() {
      let guide = view.safeAreaLayoutGuide
      
      self.bottomButtons.then { view.addSubview($0) }
        .snp.makeConstraints {
          $0.leading.bottom.trailing.equalTo(guide)
          //$0.bottom.equalTo(view)
      }
      self.tableView
        .then { view.addSubview($0) }
        .snp.makeConstraints {
          if !imageSet.isEmpty {
            $0.top.equalTo(view)
          } else {
            $0.top.equalTo(view).offset(91)
          }
          $0.leading.trailing.equalTo(guide)
          $0.bottom.equalTo(bottomButtons.snp.top)
      }
      if !imageSet.isEmpty {
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
      hScrollView.contentSize = CGSize(width: viewWidth * CGFloat(imageSet.count), height: viewWidth)
    }
    
    // MARK: Actions
    
    private func whiteBackNavigationBar() {
      navigationBar.gradientLayer.backgroundColor = UIColor.white.cgColor
      navigationBar.gradientLayer.colors = [UIColor.white.cgColor]
      [navigationBar.backButton, navigationBar.sendOptionButton, navigationBar.otherOptionButton].forEach {
        $0.tintColor = .black
      }
      navigationBar.lineView.isHidden = false
      navigationController?.navigationBar.barStyle = .default
    }
    
    private func blackBackNavigationBar() {
      if !imageSet.isEmpty {
        navigationBar.gradientLayer.backgroundColor = UIColor.clear.cgColor
        navigationBar.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.clear.cgColor]
        [navigationBar.backButton, navigationBar.sendOptionButton, navigationBar.otherOptionButton].forEach {
          $0.tintColor = .white
        }
        navigationBar.lineView.isHidden = true
        navigationController?.navigationBar.barStyle = .black
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
        cell.configure(image: UIImage(named: "sellerImage1"), sellerId: postData1.username, addr: postData1.address)
        cell.selectionStyle = .none
        return cell
      case 1:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentsTableViewCell.identifier, for: indexPath) as? ContentsTableViewCell else { return UITableViewCell() }
        var item: [String] = []
        item.append(postData1.title)
        //item.append(postData1.updated)
        item.append(PostData.shared.calculateDifferentTime(updated: postData1.updated))
        item.append(postData1.category)
        item.append(postData1.content)
        cell.selectionStyle = .none
        cell.configure(contents: item)
        return cell
      case 2:
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = "이 게시글 신고하기"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
      case 3:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherItemsTableViewCell.identifier, for: indexPath) as? OtherItemsTableViewCell else { return UITableViewCell() }
        let others = [["others1", "미니 스트랩백", "20,000원"], ["others2", "수박 에어팟케이스", "5,000원"], ["others3", "벙거지모자", "10,000원"], ["others4", "데님 원피스", "20,000원"]]
        let name = postData1.username
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
      
      switch indexPath.section {
      case 2:
        return 50
      case 3:
        if tempOtherItems.isEmpty {
          return 0
        } else if tempOtherItems.count > 2 {
          return viewWidth + (CGFloat(16) * 3)
        } else {
          return ( viewWidth + (CGFloat(16) * 3)) / 1.8
        }
      default:
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if indexPath.section == 0 {
//        guard let profilePageVC = ViewControllerGenerator.shared.make(.profilePage, parameters: ["ownSelf": false, "name": postData1.username, "profileData": sellerItemsData]) else { return }
//        navigationController?.pushViewController(profilePageVC, animated: true)
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

// MARK: - OtherItemsTableViewCellDelegate

  extension ProductPostViewController: OtherItemsTableViewCellDelegate {
    func moveToPage() {
      guard let productPostVC = ViewControllerGenerator.shared.make(.productPost, parameters: ["postData": postData1]) else { return }
      navigationController?.pushViewController(productPostVC, animated: true)
    }
  }
