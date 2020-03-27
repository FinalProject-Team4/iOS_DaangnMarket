//
//  ViewController.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/03/20.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class HomeFeedViewController: UIViewController {
  let service = ServiceManager.shared
  var localData = [PostsInfo]()
  var userUpdateTimes = [DateComponents]()
  
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
    $0.frame.size = CGSize(width: 10, height: 10)
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
//    tabBarController?.tabBar.backgroundImage = UIImage()
    setupUI()
    makeCustomNavigation()
    saveOutputDate()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    doFirstViewAlert()
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
  
  private func saveOutputDate() {
    service.requestUser { [weak self] result in
      switch result {
      case .success(let data):
        self!.localData = data
        self!.calculateDifferentTime()
        self!.tableView.reloadData()
      case .failure(let error):
        print(error.localizedDescription)
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
      guard let compareTime = calculrate?.components([.day, .hour, .minute], from: updatedTime, to: currentTime, options: []) else { fatalError("castin error") }
      userUpdateTimes.append(compareTime)
    }
  }

  @objc private func didTapButtonsInNaviBar(_ sender: UIButton) {
    switch sender {
    case leftBarItemButton:
      print("동네선택")
    case rightBarItemMagnifyingglass:
//      navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
      print("검색하기")
    case rightBarItemSlider:
//      navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
      print("카테고리선택")
    case rightBarItemBell:
//      navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
      print("알림")
    default:
      break
    }
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
    return localData.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsCell", for: indexPath) as? HomeFeedTableViewCell else { fatalError("faile type casting") }
    cell.goodsName.text = localData[indexPath.row].title
    cell.sellerLoctionAndTime.text = removeNotNeededTimeUnit(userUpdateTimes[indexPath.row])
//    print("\(indexPath.row):", checkGoodsImage(indexPath))
//    cell.goodsImage.kf.setImage(with: URL(string: checkGoodsImage(indexPath)))
    return cell
  }

  func checkGoodsImage(_ indexPath: IndexPath) -> String {
//    goodsImage.kf.setImage(with: URL(string: "http://13.125.217.34/media/images/fabinho2.jpg"))
    var URL = String()
    let imageURL = localData[indexPath.row].postImageSet
    if !imageURL.isEmpty {
      URL = imageURL[0].photo
      return URL
    } else {
      URL = String()
    }
    return URL
  }
  
  func removeNotNeededTimeUnit(_ userUpdateTimes: DateComponents) -> String {
    var updateTime = String()
    let defaultText = "화양동 • "
    if userUpdateTimes.day != 0 {
      if userUpdateTimes.day == 1 {
        updateTime += defaultText + "어제"
      } else {
        updateTime += defaultText + "\(userUpdateTimes.day!)일 전"
      }
    } else if userUpdateTimes.hour != 0 {
      updateTime += defaultText + "\(userUpdateTimes.hour!)시간 전"
    } else if userUpdateTimes.minute != 0 {
      updateTime += defaultText + "\(userUpdateTimes.minute!)분 전"
    }
    return updateTime
  }
}

extension HomeFeedViewController: UITableViewDelegate {
}
