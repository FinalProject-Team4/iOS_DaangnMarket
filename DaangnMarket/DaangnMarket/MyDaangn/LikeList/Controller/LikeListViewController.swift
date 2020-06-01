//
//  LikeListViewController.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import Alamofire

class LikeListViewController: UIViewController {
  // MARK: Views
  
  private let subTitleLabel = UILabel().then {
    $0.font = UIFont.boldSystemFont(ofSize: 14)
    $0.text = "중고거래"
    $0.textColor = .black
    $0.textAlignment = .center
  }
  private let separteLine = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  private var likeListTableView = UITableView().then {
    $0.backgroundColor = .white
  }
  private var refreshControl = UIRefreshControl().then {
    $0.tintColor = UIColor(named: ColorReference.daangnMain.rawValue)
  }
  
  // MARK: Properties
  
  let service = MyDaangnServiceManager.shared
  let headers: HTTPHeaders
  var likeParameters: Parameters = [String: Any]()
  private var likeData: [Post] = []
  
  // MARK: LifeCycle
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.shadowImage = .none
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.requestLikeList(headers)
    setupUI()
  }
  
  // MARK: Initialize
  init() {
    let tokenID = AuthorizationManager.shared.userInfo?.authorization ?? ""
    self.headers = ["Authorization": "\(tokenID)"]
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    view.backgroundColor = .white
    self.likeListTableView.backgroundColor = UIColor(named: ColorReference.backGray.rawValue)
    setupNavigationBar()
    setupTableView()
  }
  
  private func setupNavigationBar() {
    title = "관심목록"
    navigationController?.navigationBar.backgroundColor = .white
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  private func setupTableView() {
    self.likeListTableView.delegate = self
    self.likeListTableView.dataSource = self
    self.likeListTableView.register(LikeListTableViewCell.self, forCellReuseIdentifier: LikeListTableViewCell.identifier)
    self.likeListTableView.register(LikeListEmptyTableViewCell.self, forCellReuseIdentifier: LikeListEmptyTableViewCell.identifier)
    self.likeListTableView.refreshControl = self.refreshControl
    self.refreshControl.addTarget(self, action: #selector(didPullrefreshControl(_:)), for: .valueChanged)
  }
  
  private func setupConstraints() {
    let guide = view.safeAreaLayoutGuide
    
    self.subTitleLabel.then { view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(guide).offset(10)
        $0.leading.trailing.equalTo(guide)
    }
    self.separteLine.then { view.addSubview($0) }
      .snp.makeConstraints {
        $0.width.equalTo(view.frame.width)
        $0.height.equalTo(1)
        $0.leading.equalTo(subTitleLabel)
        $0.top.equalTo(subTitleLabel.snp.bottom).offset(10)
    }
    self.likeListTableView.then { view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(separteLine.snp.bottom)
        $0.leading.trailing.bottom.equalTo(guide)
    }
  }
  
  // MARK: Action
  
  @objc func didPullrefreshControl(_ sender: Any) {
    self.requestLikeList(headers)
    self.refreshControl.endRefreshing()
  }
  
  func requestLikeList(_ headers: HTTPHeaders) {
    self.likeData = []
    service.requestLikeList(headers) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let likeListData):
        let temp: [LikeList] = likeListData.results
        for idx in 0..<temp.count {
          self.likeData.append(temp[idx].post)
        }
        self.likeListTableView.reloadData()
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  func requestLikeButton(_ parameters: Parameters, _ headers: HTTPHeaders) {
    AF.request(
      "http://13.125.217.34/post/like/",
      method: .post,
      parameters: parameters,
      headers: headers
    )
      .validate()
      .responseJSON { response in
        switch response.response?.statusCode {
        case 200:
          print("좋아요 해지")
        case 201:
          print("좋아요 추가")
        default:
          print("실패")
          
          self.likeListTableView.reloadData()
        }
    }
  }
}

// MARK: - UITableViewDataSource

extension LikeListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.likeData.isEmpty {
      return 1
    } else {
      return self.likeData.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch self.likeData.count {
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LikeListEmptyTableViewCell.identifier, for: indexPath) as? LikeListEmptyTableViewCell else { return UITableViewCell() }
      cell.separatorInset = UIEdgeInsets.zero
      return cell
    default:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: LikeListTableViewCell.identifier, for: indexPath) as? LikeListTableViewCell else { return UITableViewCell() }
      cell.separatorInset = UIEdgeInsets.zero
      cell.configure(likeData: self.likeData[indexPath.row])
      cell.delegate = self
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let clearView = UIView()
    clearView.backgroundColor = .clear
    clearView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 10)
    return clearView
  }
}

// MARK: - UITableViewDelegate
extension LikeListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let productPostVC = ViewControllerGenerator.shared.make(.productPost, parameters: ["postID": likeData[indexPath.row].postId, "postPhotos": likeData[indexPath.row].photos]) else { return }
    navigationController?.pushViewController(productPostVC, animated: true)
  }
}

extension LikeListViewController: LikeListTVCDelegate {
  func likeButton(postId: Int) {
    self.likeParameters = ["post_id": "\(postId)"]
    self.requestLikeButton(likeParameters, headers)
  }
}
