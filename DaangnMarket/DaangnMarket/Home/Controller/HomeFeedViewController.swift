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
  private let url = "http://13.125.217.34/post/list"
  var parameters: Parameters = [String: Any]()
  var nextPageURL: String?
  var posts = [Post]() {
    didSet {
      self.homeTableView.reloadData()
    }
  }
  var userUpdateTimes = [DateComponents]()
  var isFirstAlert = true
  
  // MARK: Views
  
  lazy var customNaviBar = CutomNavigationBar().then {
    $0.backgroundColor = .white
//    $0.layer.borderColor = UIColor.lightGray.cgColor
//    $0.layer.borderWidth = 0.3
  }
  
  private lazy var homeTableView = UITableView().then {
    $0.sectionHeaderHeight = 4
    $0.separatorStyle = .none
    $0.rowHeight = 136
    $0.register(HomeFeedTableViewCell.self, forCellReuseIdentifier: "GoodsCell")
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    callDelegates()
    setupUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    initTownName()
    navigationController?.navigationBar.isHidden = true
    
    self.requestInitialPostList()
    let manager = AuthorizationManager.shared
    if manager.userInfo == nil, isFirstAlert {
      doFirstViewPresent()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    NotificationTrigger.default.trigger()
  }
  
  func requestInitialPostList() {
    self.posts.removeAll()
    let manager = AuthorizationManager.shared
    if let firstTown = manager.firstTown, firstTown.activated {
      print("Request First")
      self.parameters = ["locate": firstTown.locate.id]
    } else if let secondTown = manager.secondTown {
      print("Request Second")
      self.parameters = ["locate": secondTown.locate.id]
    }
    
    requestPostData(url, self.parameters)
  }
  
  // MARK: Initialize
  
  private func setupUI() {
    self.navigationController?.navigationBar.isHidden = true
    self.view.addSubview(customNaviBar)
    self.view.addSubview(homeTableView)
    setupConstraints()
  }
  
  private func setupConstraints() {
    customNaviBar.snp.makeConstraints {
      $0.top.equalToSuperview().offset(UINavigationBar.statusBarSize.height)
      $0.size.equalTo(UINavigationBar.navigationBarSize)
      $0.centerX.equalToSuperview()
    }
    homeTableView.snp.makeConstraints {
      $0.top.equalTo(customNaviBar.snp.bottom)
      $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
  // 좌상단 선택된 동네 이름 설정하기
  private func initTownName() {
    var selected = ""
    let manager = AuthorizationManager.shared
    if let firstTown = manager.firstTown, firstTown.activated {
      selected = firstTown.locate.dong
    } else if let secondTown = manager.secondTown, secondTown.activated {
      selected = secondTown.locate.dong
    }
    customNaviBar.selectedTownButton.setTitle(selected, for: .normal)
  }
  
  // MARK: Request PostData
  
  func requestPostData(_ url: String, _ parameters: Parameters) {
      service.requestPostData(URL(string: url)!, parameters) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let postInfoData):
        self.posts += postInfoData.results
        self.nextPageURL = postInfoData.next
//        self.calculateDifferentTime()
      case .failure(let error):
        print(error.localizedDescription)
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        self.homeTableView.refreshControl?.endRefreshing()
      }
    }
  }
  
  // MARK: Method
  
  private func callDelegates() {
     homeTableView.dataSource = self
     homeTableView.delegate = self
     self.customNaviBar.delegate = self
   }

  
  // MARK: Present
  
  private func doFirstViewPresent() {
    isFirstAlert = false
    let firstVC = FirstAlertViewController()
    firstVC.modalPresentationStyle = .overFullScreen
    present(firstVC, animated: false)
  }
}

// MARK: - TableView DataSource

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

    cell.setupHomeFeedCell(posts: posts, indexPath: indexPath)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == (posts.count - 2) {
      guard let pageURL = nextPageURL else { return }
      requestPostData(pageURL, self.parameters)
      self.perform(#selector(loadTable), with: nil, afterDelay: 1.0)
    }
  }
  
  @objc private func loadTable() {
    self.homeTableView.reloadData()
  }
}

// MARK: - TableView Delegate

extension HomeFeedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    tabBarController?.tabBar.isHidden = true
    navigationController?.navigationBar.shadowImage = .none
    let post = posts[indexPath.row]
    guard let productPostVC = ViewControllerGenerator.shared.make(.productPost, parameters: ["postID": post.postId, "postPhotos": post.photos]) else { return }
    
    navigationController?.pushViewController(productPostVC, animated: true)
  }
}

// MARK: - PopoverPresent Delegate

extension HomeFeedViewController: UIPopoverPresentationControllerDelegate {
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
}

// MARK: - NavigationBarButton Delegate

extension HomeFeedViewController: NavigationBarButtonDelegate {
  func navigationBarButton(_ naviBarButton: UIButton) {
    switch naviBarButton {
    case customNaviBar.selectedTownButton:
      guard let popoverVC = ViewControllerGenerator.shared.make(.popover, parameters: ["target": self, "sender": naviBarButton]) as? PopoverViewController else { print("return"); return }
      popoverVC.modalPresentationStyle = .popover
      present(popoverVC, animated: true)
    case customNaviBar.searchButton:
      guard let searchVC = ViewControllerGenerator.shared.make(.search) else { return }
      self.navigationController?.pushViewController(searchVC, animated: true)
    case customNaviBar.categoryFilterButton:
      print("카테고리선택")
      let testVC = TownAuthorizationViewController(AuthorizationManager.shared.activatedTown!.locate.dong)
      testVC.modalPresentationStyle = .overFullScreen
      present(testVC, animated: true)
    case customNaviBar.notificationButton:
      guard
        let userInfo = AuthorizationManager.shared.userInfo,
        let notiVC = ViewControllerGenerator.shared.make(.notification, parameters: ["userInfo": userInfo])
        else {
          let alert = DGAlertController(title: "회원가입 또는 로그인후 이용할 수 있습니다.")
          let login = DGAlertAction(title: "로그인/가입", style: .orange) {
            guard let loginVC = ViewControllerGenerator.shared.make(.phoneAuth) else { return }
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true)
          }
          let cancel = DGAlertAction(title: "취소", style: .cancel)
          [login, cancel].forEach { alert.addAction($0) }
          self.present(alert, animated: false)
          return
      }
      self.navigationController?.pushViewController(notiVC, animated: true)
    default: break
    }
  }
}
