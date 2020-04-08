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
  let service = ServiceManager.shared
  var localData = [Results]() {
    didSet {
      self.tableView.reloadData()
    }
  }
  var testData = [Int]() // 숫자배열; 서버데이터 없어서 임시로 만든 배열
  var userUpdateTimes = [DateComponents]()
  var goodsLimits = 15
  var page: Int = 1 // -> page 1; 서버호출, 그외; 임시

  private lazy var customNaviBar = UIView().then {
    $0.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 98)
    $0.backgroundColor = .white
    $0.layer.borderColor = UIColor.lightGray.cgColor
    $0.layer.borderWidth = 0.3
  }
  private let leftBarItemButton = UIButton().then {
    $0.setTitle("나의동네", for: .normal)
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    setupUI()
    makeCustomNavigation()
    saveOutputDate(page)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if AuthorizationManager.shared.userInfo == nil {
      doFirstViewAlert()
    }
  }
  
  private func doFirstViewAlert() {
    let firstVC = FirstAlertViewController()
    firstVC.modalPresentationStyle = .overFullScreen
    present(firstVC, animated: false)
  }
  
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
    var idx = 0
    while idx < goodsLimits {
      testData.append(idx)
      idx += 1
    }
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = UIColor(named: "symbolColor")
    refreshControl.addTarget(self, action: #selector(updateGoods), for: .valueChanged)
    tableView.refreshControl = refreshControl
  }
  
  @objc func updateGoods() {
    saveOutputDate(page)
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
  
  private func saveOutputDate(_ page: Any) {
    let parameters: Parameters = ["page": self.page]
    service.requestUser(parameters) { [weak self] result in
      switch result {
      case .success(let data):
        self!.localData = data.results
        self!.calculateDifferentTime()
      case .failure(let error):
        print(error.localizedDescription)
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        self!.tableView.refreshControl?.endRefreshing()
      }
    }
  }
  
  private func calculateDifferentTime() {
    let currentTime = Date()
    for idx in 0..<localData.count {
      let tempTime = localData[idx].updated.replacingOccurrences(of: "T", with: " ").components(separatedBy: ".")[0]
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      let updatedTime: Date = dateFormatter.date(from: tempTime) ?? currentTime
      let calculrate = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
      guard let compareTime = calculrate?.components([.day, .hour, .minute, .second], from: updatedTime, to: currentTime, options: [])
      else { fatalError("castin error") }
      userUpdateTimes.append(compareTime)
    }
  }

  @objc private func didTapButtonsInNaviBar(_ sender: UIView) {
    switch sender {
    case leftBarItemButton:
      let parameters: [String: Any] = [
        "target": self,
        "sender": sender
      ]
      guard let popover = ViewControllerGenerator.shared.make(.popover, parameters: parameters) else { return }
      present(popover, animated: true)
    case rightBarItemMagnifyingglass:
      print("검색하기")
    case rightBarItemSlider:
      print("카테고리선택")
    case rightBarItemBell:
      print("알림")
    default:
      break
    }
  }
  
  private func checkGoodsImage(_ cell: HomeFeedTableViewCell, _ indexPath: IndexPath) {
    //    goodsImage.kf.setImage(with: URL(string: "http://13.125.217.34/media/images/fabinho2.jpg")) -> 참고용
    let imageURL = localData[indexPath.row].postImageSet
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

extension HomeFeedViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let sectionView = UIView().then {
      $0.backgroundColor = .clear
      $0.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 10)
    }
    return sectionView
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if page == 1 {
      return  localData.count
    } else {
      return testData.count // 서버 호출 안될 시 확인용
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsCell", for: indexPath) as? HomeFeedTableViewCell else { fatalError("faile type casting") }
    cell.goodsName.text = localData[indexPath.row].title
    cell.sellerLoctionAndTime.text = removeNotNeededTimeUnit(localData[indexPath.row].address, userUpdateTimes[indexPath.row])
    checkGoodsImage(cell, indexPath)
//    var cell = tableView.dequeueReusableCell(withIdentifier: "GoodsCell")!
//    if cell == nil {
//      cell = UITableViewCell(style: .default, reuseIdentifier: "GoodsCell")
//    }
//    cell.textLabel?.text = "Row \(indexPath.row)"
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    print("testData.count:", testData.count)
    print("indexPath.row:", indexPath.row)
    if indexPath.row == testData.count - 19 {
      var idx = testData.count
      goodsLimits = idx + 10
      while idx < goodsLimits {
        testData.append(idx)
        idx += 1
      }
      self.perform(#selector(loadTable), with: nil, afterDelay: 1.0)
    }
  }
  
  @objc private func loadTable() {
    self.tableView.reloadData()
  }
}

extension HomeFeedViewController: UITableViewDelegate {
}

extension HomeFeedViewController: UIPopoverPresentationControllerDelegate {
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
}



//let popoverVC = PopoverViewController()
//popoverVC.preferredContentSize = CGSize(width: 300, height: 150)
//popoverVC.modalPresentationStyle = .popover
//guard let presentationController = popoverVC.popoverPresentationController else { return }
//presentationController.delegate = self
//presentationController.sourceRect = sender.bounds
//presentationController.sourceView = sender
//presentationController.permittedArrowDirections = .up
//present(popoverVC, animated: true)
