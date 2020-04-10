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
  
  //  private lazy var layout = UICollectionViewFlowLayout().then {
  //    $0.scrollDirection = .vertical
  //    $0.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
  //    $0.minimumInteritemSpacing = 16
  //    $0.minimumLineSpacing = 20
  //    let itemWidth: CGFloat =
  //      (view.frame.width - CGFloat(view.safeAreaInsets.left + view.safeAreaInsets.right) - (16 * 3)) / 2
  //    let itemHeight: CGFloat =
  //      (view.frame.height - CGFloat(view.safeAreaInsets.top + view.safeAreaInsets.bottom)) * 0.4
  //    $0.itemSize = CGSize(width: itemWidth, height: itemHeight)
  //  }
  //
  //  private lazy var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout).then {
  //    $0.dataSource = self
  //    $0.delegate = self
  //    $0.register(
  //      SelectedCategoryFeedCollectionCell.self, forCellWithReuseIdentifier: SelectedCategoryFeedCollectionCell.cellID
  //    )
  //    $0.backgroundColor = .white
  //    view.addSubview($0)
  //    $0.snp.makeConstraints { contraints in
  //      contraints.edges.equalTo(view.safeAreaLayoutGuide)
  //    }
  //  }
  
  private lazy var tableView = UITableView().then {
    $0.dataSource = self
    $0.delegate = self
    $0.register(HomeFeedTableViewCell.self, forCellReuseIdentifier: "GoodsCell")
    $0.rowHeight = 136
    view.addSubview($0)
  }
  
  // MARK: Properties
  
  //  private var postData: [ResultsByPostByCategory]?
  private var postData: [ResultsByPostByCategory] = []
  
  var cellHeightDictionary: NSMutableDictionary = [:]
  
  //  {
  //    didSet {
  //      print(self.postData.count)
  //    }
  //  }
  //
  private var nextURL: URL?
  //  {
  //    willSet {
  //      print(self.nextURL)
  //    }
  //  }
  
  // MARK: Initialieze
  init(category: String) {
    super.init(nibName: nil, bundle: nil)
    self.title = category
    makeURL(category: category)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupNavigation()
    setupContraints()
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
  
  private func setupContraints() {
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
    request(url: url)
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
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ) {
      self.tableView.reloadData()
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
//extension SelectedCategoryFeedViewController: UICollectionViewDataSource {
//  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    print(postData.count)
//    return postData.count
//    //    guard let count = postData?.count else { return 0 }
//    //    return count
//  }
//
//  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    guard let item = collectionView.dequeueReusableCell(
//      withReuseIdentifier: SelectedCategoryFeedCollectionCell.cellID, for: indexPath
//      ) as? SelectedCategoryFeedCollectionCell else { return UICollectionViewCell() }
//    let post = postData[indexPath.row]
//    //    let post = postData![indexPath.row]
//    item.inputData(image: nil, title: post.title, town: post.address, price: post.price)
//    return item
//  }
//}
//
//extension SelectedCategoryFeedViewController: UICollectionViewDelegate {
//  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//    if indexPath.row == postData.count - 1 {
//      //      print("뭐라도 좀,..")
//      request(url: nextURL)
//      self.perform(#selector(reload), with: nil, afterDelay: 0.3)
//    }
//  }
//
//  @objc func reload() {
//    self.collectionView.reloadData()
//  }
//}

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
      request(url: nextURL)
    } else {
      return
    }
    cellHeightDictionary.setObject(cell.frame.size.height, forKey: indexPath as NSCopying)
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}
