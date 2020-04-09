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
  // MARK: Properties
  private var postData: PostByCategory?
  
  // MARK: Initialieze
  init(category: String) {
    super.init(nibName: nil, bundle: nil)
    self.title = category
    request(category: category)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupNavigation()
//    setupCollectionView()
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
  
  private func request(category: String) {
    let category = DGCategory.allCases
      .filter { $0.korean == category }
      .map { $0.rawValue }
      .first ?? "other"
    
    let url = URL(string: "http://13.125.217.34/post/list/category/")!
    let parameters: Parameters = [
      "category": category,
      "page": 1,
      "locate": 8_725
    ]
    AF.request(url, method: .get, parameters: parameters)
      .validate()
      .responseJSON { response in
        switch response.result {
        case .success:
          guard let responseData = response.data else { return }
          guard let decodeResult = try? JSONDecoder().decode(PostByCategory.self, from: responseData) else { return }
          self.postData = decodeResult
        case .failure(let err):
          print(err.localizedDescription)
        }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      self.setupCollectionView()
    }
  }
  
  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout().then {
      $0.scrollDirection = .vertical
      $0.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
      $0.minimumInteritemSpacing = 16
      $0.minimumLineSpacing = 20
      let itemWidth: CGFloat =
        (view.frame.width - CGFloat(view.safeAreaInsets.left + view.safeAreaInsets.right) - (16 * 3)) / 2
      let itemHeight: CGFloat =
        (view.frame.height - CGFloat(view.safeAreaInsets.top + view.safeAreaInsets.bottom)) * 0.4
      $0.itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout).then {
      $0.dataSource = self
      $0.register(
        SelectedCategoryFeedCollectionCell.self, forCellWithReuseIdentifier: SelectedCategoryFeedCollectionCell.cellID
      )
      $0.backgroundColor = .white
      view.addSubview($0)
    }
    
    collectionView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
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
extension SelectedCategoryFeedViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let postCount = postData?.results.count else { return 0 }
    return postCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let item = collectionView.dequeueReusableCell(
      withReuseIdentifier: SelectedCategoryFeedCollectionCell.cellID, for: indexPath
      ) as? SelectedCategoryFeedCollectionCell else { return UICollectionViewCell() }
    if let post = postData?.results[indexPath.row] {
      item.inputData(image: nil, title: post.title, town: post.address, price: post.price)
    }
    return item
  }
}
