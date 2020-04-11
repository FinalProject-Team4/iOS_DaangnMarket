//
//  SelectedCategoryFeedViewController.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/09.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import Alamofire

struct PostByCategory: Decodable {
  let next: URL
  let results: [ResultsByPostByCategory]
}
struct ResultsByPostByCategory: Decodable {
  //  let image
  let title: String
  let address: String
  let price: Int
}

// MARK: - Class Level
class SelectedCategoryFeedViewController: UIViewController {
  // MARK: Views
  private lazy var tableView = UITableView().then {
    $0.dataSource = self
    $0.delegate = self
    $0.register(HomeFeedTableViewCell.self, forCellReuseIdentifier: "GoodsCell")
    $0.rowHeight = 136
  }
  
  private lazy var indicator = UIActivityIndicatorView().then {
    $0.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    $0.center = self.view.center
    $0.color = UIColor(named: ColorReference.daangnMain.rawValue)
    view.addSubview($0)
  }
  
  // MARK: Properties
  private var postData: [ResultsByPostByCategory] = []
  
  var cellHeightDictionary: NSMutableDictionary = [:]
 
  private var nextURL: URL?
  
  // MARK: Initialieze
  init(category: String) {
    super.init(nibName: nil, bundle: nil)
    self.title = category
    setupUI(category: category)
    indicator.startAnimating()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  private func setupUI(category: String) {
    view.backgroundColor = .white
    setupNavigation()
    category == "인기매물" ? setupEmptyView() : makeURL(category: category)
  }
  
  private func setupNavigation() {
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didTapNaviBackButton)
    )
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTabNaviSearchButton)
    )
  }
  
  private func setupEmptyView() {
    let label = UILabel().then {
      $0.text = "인기글이 없습니당."
      $0.textColor = .gray
      view.addSubview($0)
    }
    label.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    indicator.stopAnimating()
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
    let url = URL(string: "http://13.125.217.34/post/list/category/?category=\(category)&page=1&locate=8725")
    firstRequest(url: url)
  }
  
  private func firstRequest(url: URL?) {
    request(url: url)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ) {
      self.indicator.stopAnimating()
      self.setupTableView()
      self.tableView.reloadData()
    }
  }
  
  private func nextRequest(url: URL?) {
    request(url: url)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ) {
      self.tableView.reloadData()
    }
  }
  
  private func request(url: URL?) {
    guard let url = url else { return }
    AF.request(url, method: .get)
      .validate()
      .responseJSON { response in
        switch response.result {
        case .success:
          guard let responseData = response.data else { return }
          guard let decodeResult = try? JSONDecoder().decode(PostByCategory.self, from: responseData) else { return }
          self.postData += decodeResult.results
          //          decodeResult.results.forEach { self.postData.append($0) }
          self.nextURL = decodeResult.next
        case .failure(let err):
          print(err.localizedDescription)
        }
    }
  }
  
  // MARK: Actions
  
  @objc private func didTapNaviBackButton() {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func didTabNaviSearchButton() {
    print("검색 뷰컨트롤러 슝~")
  }
}

// MARK: - Extension Level
extension SelectedCategoryFeedViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    postData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsCell", for: indexPath) as? HomeFeedTableViewCell else { return UITableViewCell() }
    let post = postData[indexPath.row]
    cell.goodsName.text = post.title
    cell.goodsPrice.text = "\(post.price)"
    cell.goodsImageView.image = UIImage(systemName: "person")
    return cell
  }
}

extension SelectedCategoryFeedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == postData.count - 3 {
      nextRequest(url: nextURL)
    } else {
      return
    }
    cellHeightDictionary.setObject(cell.frame.size.height, forKey: indexPath as NSCopying)
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}
