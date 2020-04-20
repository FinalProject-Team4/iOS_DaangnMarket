//
//  SearchViewController.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import Alamofire

// MARK: - Class Level
class SearchViewController: UIViewController {
  let dummyData = ["아이스크림", "바둑돌", "송아지", "모니터"]
  var dummyList: [String] = [] {
    didSet {
      searchListTableView.reloadData()
    }
  }
  
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchBar.becomeFirstResponder()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: .HistoryNotification, object: nil)
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
    self.tabBarController?.tabBar.isHidden = true
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
      .addObserver(self, selector: #selector(changeHistoryNewItem), name: .HistoryNotification, object: nil)
  }
  
  private func searchForData(searchText: String) {
    dummyList = dummyData.filter { $0 == searchText }
    if dummyList.isEmpty {
      contentScrollView.updateFailKeyword(searchText)
      contentScrollView.searchStatus(.fail)
      searchListTableView.isHidden = true
    } else {
      contentScrollView.searchStatus(.success)
      contentScrollView.updateFailKeyword(searchText)
      contentScrollView.updateKeywordNotiCell(searchText)
      searchListTableView.isHidden = true
    }
    searchBar.resignFirstResponder()
    if !searchText.isEmpty { SearchHistory.shared.history.append(searchBar.text!) }
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
    self.view.layoutIfNeeded()
  }
  
  @objc private func didTapLeftButton() {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func changeHistoryNewItem() {
    if SearchHistory.shared.history.isEmpty {
      //      self.searchMainView.removeAllHistoryItems()
    } else {
      let newItemIdx = SearchHistory.shared.history.count - 1
      contentScrollView.addHistoryNewItem(SearchHistory.shared.history[newItemIdx])
    }
  }
}

// MARK: - Extension
extension SearchViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      contentScrollView.searchStatus(.standBy)
      searchListTableView.isHidden = true
    } else {
      dummyList = dummyData.filter { $0.contains(searchText) }
      contentScrollView.searchStatus(.searching)
      searchListTableView.isHidden = false
    }
  }
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchText = searchBar.text else { return }
    searchForData(searchText: searchText)
  }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    contentScrollView.searchStatus(.standBy)
    searchListTableView.isHidden = true
  }
}

extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if dummyList.isEmpty {
      return 0
    } else if dummyList.count <= 15 {
      return dummyList.count
    } else {
      return 15
    }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = dummyList[indexPath.row]
    cell.imageView?.image = UIImage(systemName: "magnifyingglass")
    cell.imageView?.tintColor = .gray
    return cell
  }
}

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    contentScrollView.searchStatus(.searching)
    searchListTableView.isHidden = false
    let cell = tableView.cellForRow(at: indexPath)
    guard let cellText = cell?.textLabel?.text else { return }
    searchBar.text = cellText
    if let searchText = searchBar.text { searchForData(searchText: searchText) }
    searchBar.resignFirstResponder()
  }
}

extension SearchViewController: HistoryKeywordsViewDelegate {
  func deleteAllHistory() {
    SearchHistory.shared.history.removeAll()
    print(SearchHistory.shared.history.count)
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
