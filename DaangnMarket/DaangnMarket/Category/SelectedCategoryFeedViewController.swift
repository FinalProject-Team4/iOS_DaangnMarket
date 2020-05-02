//
//  SelectedCategoryFeedViewController.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/09.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import Alamofire

// MARK: - Class Level
class SelectedCategoryFeedViewController: UIViewController {
  // MARK: Views
  private lazy var tableView = UITableView().then {
    $0.dataSource = self
    $0.delegate = self
    $0.register(HomeFeedTableViewCell.self, forCellReuseIdentifier: "GoodsCell")
    $0.rowHeight = 136
    $0.tableFooterView = UIView()
  }
  
  private lazy var indicator = UIActivityIndicatorView().then {
    $0.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    $0.center = self.view.center
    $0.color = UIColor(named: ColorReference.daangnMain.rawValue)
    view.addSubview($0)
  }
  
  private lazy var upperAlert = DGUpperAlert()
  
  // MARK: Properties
  private var postData: [Post] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  private var cellHeightDictionary: NSMutableDictionary = [:]
  private var nextURL: URL?
  private var selectedCategory: String?
  
  // MARK: Initialieze
  init(category: String) {
    super.init(nibName: nil, bundle: nil)
    self.title = category
    selectedCategory = category
    setupUI(category: category)
    indicator.startAnimating()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigation()
  }
  
  private func setupUI(category: String) {
    view.backgroundColor = .white
    category == "인기매물" ? setupEmptyView(category: category) : makeURL(category: category)
  }
  
  private func setupNavigation() {
    self.navigationController?.navigationBar.isHidden = false
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didTapNaviBackButton)
    )
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTabNaviSearchButton)
    )
  }
  
  private func setupEmptyView(category: String) {
    let label = UILabel().then {
      $0.text =
        category == "인기매물" ? "인기글이 없습니당." : "\(category) 매물이 없습니당."
      $0.textColor = .gray
      view.addSubview($0)
    }
    label.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
      self.indicator.stopAnimating()
    }
  }
  
  private func setupTableView() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { constraints in
      constraints.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  // MARK: Methods
  private func makeURL(category: String) {
    let category = DGCategory.allCases
      .filter { $0.korean == category }
      .map { $0.rawValue }
      .first ?? "other"
    let locate = AuthorizationManager.shared.activatedTown?.locate.id
    let distance = AuthorizationManager.shared.activatedTown?.distance
    let url = URL(string: "http://13.125.217.34/post/list?category=\(category)&locate=\(locate)&distance=\(distance)")
    firstRequest(url: url)
  }
  
  private func firstRequest(url: URL?) {
    request(url: url) {
      self.indicator.stopAnimating()
      self.setupTableView()
      self.tableView.reloadData()
    }
  }
  
  private func request(url: URL?, _ compeltion: @escaping () -> Void) {
    guard let url = url else { return }
    AF.request(url, method: .get)
      .validate()
      .responseJSON { response in
        switch response.result {
        case .success:
          guard let responseData = response.data else { return }
          guard let decodeResult = try? JSONDecoder().decode(PostInfo.self, from: responseData) else { return }
          self.postData += decodeResult.results
          if self.postData.isEmpty {
            self.setupEmptyView(category: self.selectedCategory!)
            self.tableView.isHidden = true
          }
          self.nextURL = URL(string: decodeResult.next ?? "")
          compeltion()
        case .failure(let err):
          print(err.localizedDescription)
          self.upperAlert.show(message: err.localizedDescription)
        }
    }
  }
  
  private func nextRequest(url: URL?) {
    guard let url = url else { return }
    AF.request(url, method: .get)
      .validate()
      .responseJSON { response in
        switch response.result {
        case .success:
          guard let responseData = response.data else { return }
          guard let decodeResult = try? JSONDecoder().decode(PostInfo.self, from: responseData) else { return }
          self.postData += decodeResult.results
          if self.postData.isEmpty {
            self.setupEmptyView(category: self.selectedCategory!)
            self.tableView.isHidden = true
          }
          self.nextURL = URL(string: decodeResult.next ?? "")
        case .failure(let err):
          print(err.localizedDescription)
        }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ) {
      self.tableView.reloadData()
    }
  }
  
  // MARK: Actions
  
  @objc private func didTapNaviBackButton() {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func didTabNaviSearchButton() {
    guard let searchVC = ViewControllerGenerator.shared.make(.search) else { return }
    self.navigationController?.pushViewController(searchVC, animated: true)
  }
}

// MARK: - Extension Level
extension SelectedCategoryFeedViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    postData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsCell", for: indexPath) as? HomeFeedTableViewCell else { return UITableViewCell() }
    cell.setupHomeFeedCell(posts: postData, indexPath: indexPath)
    return cell
  }
}

extension SelectedCategoryFeedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == postData.count - 3 {
      nextRequest(url: nextURL)
    }
    cellHeightDictionary.setObject(cell.frame.size.height, forKey: indexPath as NSCopying)
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    guard let productPVC = ViewControllerGenerator.shared.make(.productPost) else { return }
//    let addressTime = removeNotNeededTimeUnit(postData[indexPath.row].address, userUpdateTimes[indexPath.row])
//    PostData.shared.updated = addressTime.components(separatedBy: " • ")[1]
//    PostData.shared.saveData(postData[indexPath.row])
//    self.navigationController?.pushViewController(productPVC, animated: true)
  }
}
