//
//  SearchViewController.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import Alamofire

struct SearchResult: Decodable {
  let results: [Post]
}

struct SearchResultPost: Decodable {
  let userID: Int
  let username: String
  let title: String
  let content: String
  let adress: String
  let category: String
  let viewCount: Int
  let updated: String
  let price: Int
  let showedLocates: [Int]
  let photos: [String]
  
  enum CodingKeys: String, CodingKey {
    case username, title, content, adress, category, updated, price, photos
    case userID = "id"
    case viewCount = "view_count"
    case showedLocates = "showed_locates"
  }
}

// MARK: - Class Level
class SearchViewController: UIViewController {
  var searchResultsList: [String] = [] {
    didSet {
      searchListTableView.reloadData()
    }
  }
  var searchTask: DataRequest?
  var resultPost: [SearchResultPost] = []
  var userLocate = AuthorizationManager.shared.activatedTown?.locate.id
  
  // MARK: Views
  private lazy var searchBar = UISearchBar().then {
    $0.delegate = self
    $0.placeholder = "검색어를 입력하세요."
  }
  private lazy var segementView = DGSegmentedControl(items: ["중고거래", "동네정보", "사람"]).then {
    $0.backgroundColor = .white
    $0.delegate = self
  }
  private lazy var searchListTableView = UITableView().then {
    $0.isHidden = true
    $0.dataSource = self
    $0.delegate = self
    $0.separatorStyle = .none
    $0.rowHeight = 36
    $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  private lazy var contentScrollView = ContentSearchScrollView().then {
    $0.delegate = self
    $0.historyDelegate = self
    $0.isPagingEnabled = true
    $0.showsHorizontalScrollIndicator = false
  }
  
  // MARK: Properties
  //  private var seletedTown = AuthorizationManager.shared.selectedTown?.dong ?? "동네없음"
  
  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchBar.becomeFirstResponder()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: .addHistoryKeyword, object: nil)
    NotificationCenter.default.removeObserver(self, name: .removeHistoryKeyword, object: nil)
  }
  
  // MARK: Initialize
  private func setupUI() {
    setupNavigation()
    setupAttributes()
    setupConstraints()
    setupNotification()
    contentScrollView.searchStatus(.standBy)
  }
  
  private func setupNavigation() {
    self.navigationController?.navigationBar.isHidden = false
    navigationItem.titleView = searchBar
    
    navigationController?.navigationBar.tintColor = .black
    navigationController?.navigationBar.barTintColor = .white
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didTapLeftButton))
    
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = false
  }
  
  private func setupAttributes() {
//    self.tabBarController?.tabBar.isHidden = true
    view.backgroundColor = UIColor(named: ColorReference.lightBackground.rawValue)
    [segementView, searchListTableView, contentScrollView].forEach { view.addSubview($0) }
  }
  
  private func setupConstraints() {
    segementView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(40)
    }
    searchListTableView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
    contentScrollView.snp.makeConstraints {
      $0.top.equalTo(segementView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func setupNotification() {
    NotificationCenter
      .default
      .addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter
      .default
      .addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    NotificationCenter
      .default
      .addObserver(self, selector: #selector(addHistoryKeyword), name: .addHistoryKeyword, object: nil)
    NotificationCenter
      .default
      .addObserver(self, selector: #selector(removeHistoryKeyword), name: .removeHistoryKeyword, object: nil)
  }
  
  // MARK: Actions
  @objc private func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
      let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
    
    let height = self.view.frame.maxY
    let keyboard = frame.minY
    let safeLayout = view.safeAreaInsets.bottom
    let diff = height - keyboard - safeLayout
    
    searchListTableView.snp.updateConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-diff)
    }
    contentScrollView.snp.updateConstraints {
      $0.bottom.equalToSuperview()
        .offset(-diff)
    }
  }
  
  @objc private func keyboardWillHide(_ notification: Notification) {
    searchListTableView.snp.updateConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
    contentScrollView.snp.updateConstraints {
      $0.bottom.equalToSuperview()
    }
  }
  
  @objc private func didTapLeftButton() {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func addHistoryKeyword() {
    let newItemIdx = SearchHistory.shared.history.count - 1
    contentScrollView.addHistoryNewItem(SearchHistory.shared.history[newItemIdx])
  }
  
  @objc private func removeHistoryKeyword() {
    //    contentScrollView.reloadHistoryItem(SearchHistory.shared.history)
  }
  
  // MARK: Methods
  private func searchingForData(searchText: String) {
    var list: [String] = []
    let params: Parameters = ["word": searchText, "locate": userLocate!]
    guard let url = URL(string: "http://13.125.217.34/post/search/") else { return }
    searchTask =
      AF.request(url, method: .get, parameters: params)
        .validate()
        .responseJSON { response in
          switch response.result {
          case .success:
            guard let responseData = response.data else { return }
            guard let decodeResult = try? JSONDecoder().decode(SearchResult.self, from: responseData) else { return }
            decodeResult.results.forEach { list.append($0.title) }
            self.searchResultsList = Array(Set(list))
          case .failure(let err):
            print(err.localizedDescription)
          }
    }
  }
  
  private func showSearcResultsList(searchText: String) {
    if searchResultsList.isEmpty {
      contentScrollView.updateFailKeyword(searchText)
      contentScrollView.searchStatus(.fail)
      searchListTableView.isHidden = true
    } else {
      let params: Parameters = ["word": searchText, "locate": userLocate!]
      guard let url = URL(string: "http://13.125.217.34/post/search/") else { return }
      AF.request(url, method: .get, parameters: params)
        .validate()
        .responseJSON { response in
          switch response.result {
          case .success:
            guard let responseData = response.data else { return }
            guard let decodeResult = try? JSONDecoder().decode(SearchResult.self, from: responseData) else { return }
            self.contentScrollView.searchResultPost(decodeResult.results)
          case .failure(let err):
            print(err.localizedDescription)
          }
      }
      contentScrollView.searchStatus(.success)
      contentScrollView.updateFailKeyword(searchText)
      contentScrollView.updateKeywordNotiCell(searchText)
      searchListTableView.isHidden = true
    }
    self.searchBar.resignFirstResponder()
    if !searchText.isEmpty { SearchHistory.shared.history.append(self.searchBar.text!) }
  }
}

// MARK: - Extension
extension SearchViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      contentScrollView.searchStatus(.standBy)
      searchListTableView.isHidden = true
    } else {
      searchTask?.cancel()
      searchingForData(searchText: searchText)
      contentScrollView.searchStatus(.searching)
      searchListTableView.isHidden = false
    }
  }
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchText = searchBar.text else { return }
    showSearcResultsList(searchText: searchText)
  }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    contentScrollView.searchStatus(.standBy)
    searchListTableView.isHidden = true
  }
}

extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchResultsList.isEmpty {
      return 0
    } else if searchResultsList.count <= 15 {
      return searchResultsList.count
    } else {
      return 15
    }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = searchResultsList[indexPath.row]
    cell.imageView?.image = UIImage(systemName: "magnifyingglass")
    cell.imageView?.tintColor = .gray
    return cell
  }
}

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    contentScrollView.searchStatus(.success)
    searchListTableView.isHidden = true
    let cell = tableView.cellForRow(at: indexPath)
    guard let cellText = cell?.textLabel?.text else { return }
    searchBar.text = cellText
    if let searchText = searchBar.text { showSearcResultsList(searchText: searchText) }
    searchBar.resignFirstResponder()
  }
}

extension SearchViewController: HistoryKeywordsViewDelegate {
  func deleteSelectedItem(tag: Int) {
    SearchHistory.shared.history.remove(at: tag)
  }
  
  func deleteAllHistory() {
    SearchHistory.shared.history.removeAll()
  }
}

extension SearchViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    segementView.updateSelectedIndicator(offset: scrollView.contentOffset.x / 3, animated: true)
  }
}

extension SearchViewController: DGSegmentControlDelegate {
  func segmentControl(_ segmentControl: DGSegmentedControl, didSelectSegmeentAt index: Int) {
    let offSet = CGPoint(x: self.contentScrollView.frame.width * CGFloat(index), y: 0)
    self.contentScrollView.setContentOffset(offSet, animated: false)
  }
}
