//
//  ViewController.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/03/20.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import Alamofire

class HomeFeedViewController: UIViewController {
  // MARK: Property
  
  let service = ServiceManager.shared
  private var url = "http://13.125.217.34/post/list/"
  var nextPageURL: String?
  var posts = [Post]() {
    didSet {
      self.tableView.reloadData()
    }
  }
  
  var testData = [Int]()
  var userUpdateTimes = [DateComponents]()
  var goodsLimits = 15
  
  // MARK: Views
  
  private lazy var customNaviBar = UIView().then {
    $0.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 98)
    $0.backgroundColor = .white
    $0.layer.borderColor = UIColor.lightGray.cgColor
    $0.layer.borderWidth = 0.3
  }
  let leftBarItemButton = UIButton().then {
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
    $0.addTarget(self, action: #selector(didTapButtonsInNaviBar(_:)), for: .touchUpInside)
  }
  private let leftBarItemArrow = UIImageView().then {
    $0.frame.size = CGSize(width: 5, height: 5)
    $0.image = UIImage(systemName: "chevron.down")
    $0.tintColor = .black
  }
  private let rightBarItemMagnifyingglass = UIButton(type: .system).then {
    $0.frame.size = CGSize(width: 32, height: 32)
    $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
    $0.tintColor = .black
    $0.restorationIdentifier = "magnifyingglass"
    $0.addTarget(self, action: #selector(didTapButtonsInNaviBar(_:)), for: .touchUpInside)
  }
  private let rightBarItemSlider = UIButton(type: .system).then {
    $0.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    $0.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
    $0.tintColor = .black
    $0.addTarget(self, action: #selector(didTapButtonsInNaviBar(_:)), for: .touchUpInside)
  }
  private let rightBarItemBell = UIButton(type: .system).then {
    $0.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    $0.setImage(UIImage(systemName: "bell"), for: .normal)
    $0.tintColor = .black
    $0.addTarget(self, action: #selector(didTapButtonsInNaviBar(_:)), for: .touchUpInside)
  }
  private let tableView = UITableView(frame: .zero, style: .grouped).then {
    $0.sectionHeaderHeight = 4
    $0.separatorStyle = .none
    $0.rowHeight = 136
    $0.register(HomeFeedTableViewCell.self, forCellReuseIdentifier: "GoodsCell")
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.tabBarController?.tabBar.isHidden = false
    leftBarItemButton.setTitle(AuthorizationManager.shared.selectedTown?.dong ?? "unknown", for: .normal)
    setupUI()
    makeCustomNavigation()
    requestPostData(url)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("AuthorizationManager.shared.userInfo", AuthorizationManager.shared.userInfo)
    if AuthorizationManager.shared.userInfo == nil {
      doFirstViewPresent()
    }
  }
  
  // MARK: Initialize
  
  private func makeCustomNavigation() {
    navigationController?.navigationBar.isHidden = true
    self.view.addSubview(customNaviBar)
  }
  
  private func setupUI() {
    setupTableView()
    setupConstraints()
  }
  
  private func setupTableView() {
    self.view.addSubview(tableView)
    tableView.frame = view.frame
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  private func setupConstraints() {
    let naviBarItems = [leftBarItemArrow, leftBarItemButton, rightBarItemBell, rightBarItemSlider, rightBarItemMagnifyingglass]
    naviBarItems.forEach { customNaviBar.addSubview($0) }
    leftBarItemButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(15)
      $0.bottom.equalToSuperview().offset(-15)
    }
    leftBarItemArrow.snp.makeConstraints {
      $0.centerY.equalTo(leftBarItemButton)
      $0.leading.equalTo(leftBarItemButton.snp.trailing).offset(7)
    }
    rightBarItemBell.snp.makeConstraints {
      $0.centerY.equalTo(leftBarItemButton)
      $0.trailing.equalToSuperview().offset(-15)
    }
    rightBarItemSlider.snp.makeConstraints {
      $0.centerY.equalTo(leftBarItemButton)
      $0.trailing.equalTo(rightBarItemBell.snp.leading).offset(-15)
    }
    rightBarItemMagnifyingglass.snp.makeConstraints {
      $0.centerY.equalTo(leftBarItemButton)
      $0.trailing.equalTo(rightBarItemSlider.snp.leading).offset(-15)
    }
    tableView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(98)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)//.offset(-80)
    }
  }
  
  // MARK: Request PostData
  
  private func requestPostData(_ url: String) {
    service.requestPostData(URL(string: url)!) { [weak self] result in
      switch result {
      case .success(let postInfoData):
        self!.posts += postInfoData.results
        self?.nextPageURL = postInfoData.next
        self!.calculateDifferentTime()
      case .failure(let error):
        print(error.localizedDescription)
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        self!.tableView.refreshControl?.endRefreshing()
      }
    }
  }
  
  // MARK: Time Calculate
  
  private func calculateDifferentTime() {
    let currentTime = Date()
    for idx in 0..<self.posts.count {
      let tempTime = self.posts[idx].updated.replacingOccurrences(of: "T", with: " ").components(separatedBy: ".")[0]
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      let updatedTime: Date = dateFormatter.date(from: tempTime) ?? currentTime
      let calculrate = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
      guard let compareTime = calculrate?.components([.day, .hour, .minute, .second], from: updatedTime, to: currentTime, options: [])
      else { fatalError("castin error") }
      userUpdateTimes.append(compareTime)
    }
  }
  
  // MARK: Action

  @objc private func didTapButtonsInNaviBar(_ sender: UIView) {
    let popoverVC = PopoverViewController()
    switch sender {
    case leftBarItemButton:
      let popPresent = HomeFeedViewController.popoverPresent(self, popoverVC, sender)
      present(popPresent, animated: true)
    case rightBarItemMagnifyingglass:
      print("검색하기")
    case rightBarItemSlider:
      print("카테고리선택")
    case rightBarItemBell:
      print("알림")
    default: break
    }
  }
  
  // MARK: Method
  
  private func doFirstViewPresent() {
    let firstVC = FirstAlertViewController()
    firstVC.modalPresentationStyle = .overFullScreen
    present(firstVC, animated: false)
  }
  
  static func popoverPresent(_ delegateVC: UIViewController, _ controller: UIViewController, _ sender: UIView) -> UIViewController {
    controller.preferredContentSize = CGSize(width: 300, height: 150)
    controller.modalPresentationStyle = .popover
    guard let presentationController = controller.popoverPresentationController else { fatalError("popOverPresent casting error") }
    presentationController.delegate = delegateVC as? UIPopoverPresentationControllerDelegate
    presentationController.sourceRect = sender.bounds
    presentationController.sourceView = sender
    presentationController.permittedArrowDirections = .up
    return controller
  }
  
  private func checkGoodsImage(_ cell: HomeFeedTableViewCell, _ indexPath: IndexPath) {
    let imageURL = posts[indexPath.row].postImageSet
    if !imageURL.isEmpty {
      cell.goodsImageView.kf.setImage(with: URL(string: imageURL[0].photo))
    } else {
      cell.goodsImageView.image = UIImage(named: "DaanggnMascot")
    }
  }
  
  private func removeNotNeededTimeUnit(_ address: String, _ userUpdateTimes: DateComponents) -> String {
    var updateTime = String()
    if userUpdateTimes.day != 0 {
      if userUpdateTimes.day == 1 {
        updateTime += "\(address) • 어제"
      } else {
        updateTime += "\(address) • \(userUpdateTimes.day!)일 전"
      }
    } else if userUpdateTimes.hour != 0 {
      updateTime += "\(address) • \(userUpdateTimes.hour!)시간 전"
    } else if userUpdateTimes.minute != 0 {
      updateTime += "\(address) • \(userUpdateTimes.minute!)분 전"
    } else if userUpdateTimes.second != 0 {
      updateTime += "\(address) • \(userUpdateTimes.second!)초 전"
    }
    return updateTime
  }
}

// MARK: TableView DataSource

extension HomeFeedViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let sectionView = UIView().then {
      $0.backgroundColor = .clear
      $0.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 10)
    }
    return sectionView
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return  posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsCell", for: indexPath) as? HomeFeedTableViewCell else { fatalError("faile type casting") }
//    cell.goodsName.text = posts[indexPath.row].title
    cellPostGoodsImage(cell, indexPath)
    cell.goodsName.text = "Post ID \(posts[indexPath.row].postId)"
    cell.goodsPrice.text = "\(posts[indexPath.row].price)"
    cell.sellerLoctionAndTime.text = removeNotNeededTimeUnit(posts[indexPath.row].address, userUpdateTimes[indexPath.row])
    checkGoodsImage(cell, indexPath)
    return cell
  }
  
  func cellPostGoodsImage(_ cell: HomeFeedTableViewCell, _ indexPath: IndexPath) {
    if posts[indexPath.row].postImageSet.isEmpty {
      cell.goodsImageView.image = UIImage(named: "DaanggnMascot")
    } else {
      cell.goodsImageView.kf.setImage(with: URL(string: posts[indexPath.row].postImageSet[0].photo))
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if posts.count == (indexPath.row + 2) {
      guard let pageURL = nextPageURL else { return }
      requestPostData(pageURL)
      self.perform(#selector(loadTable), with: nil, afterDelay: 1.0)
    }
  }
  
  @objc private func loadTable() {
    self.tableView.reloadData()
  }
}

// MARK: TableView Delegate

extension HomeFeedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    print("\(indexPath.row)번 셀 선택")
    print("\(posts[indexPath.row].postId)번 id")
  }
}

// MARK: PopoverPresent Delegate

extension HomeFeedViewController: UIPopoverPresentationControllerDelegate {
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
}
