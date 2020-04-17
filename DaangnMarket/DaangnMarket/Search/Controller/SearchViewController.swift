//
//  SearchViewController.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

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
  
  private let searchMainView = SearchMainView()
  
  private lazy var searchListTableView = UITableView().then {
    $0.isHidden = true
    $0.dataSource = self
    $0.delegate = self
    $0.separatorStyle = .none
    $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  private let searchResultsView = SearchResultsView().then {
    $0.isHidden = true
  }
  
  private var searchNoResultView: NoResultView?
  
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
    NotificationCenter.default.removeObserver(self, name: .HistoryNotification, object: nil)
  }
  
  // MARK: Initialize
  private func setupUI() {
    setupNavigation()
    setupAttributes()
    setupConstraints()
    setupNotification()
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
    searchMainView.delegate = self
    self.tabBarController?.tabBar.isHidden = true
    view.backgroundColor = UIColor(named: ColorReference.lightBackground.rawValue)
    view.addSubview(searchMainView)
    view.addSubview(searchListTableView)
    view.addSubview(searchResultsView)
  }
  
  private func setupConstraints() {
    searchMainView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
    searchListTableView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.size.equalToSuperview()
    }
    searchResultsView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8)
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
  
  // MARK: Actions
  @objc private func keyboardWillShow(_ notification: Notification) {
    //    guard let userInfo = notification.userInfo,
    //      let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
    //
    //    let height = self.view.frame.maxY
    //    let keyboard = frame.minY
    //    let safeLayout = view.safeAreaInsets.bottom
    //    let diff = height - keyboard - safeLayout
    //
    //        searchMainView.snp.updateConstraints {
    //          $0.bottom.equalToSuperview().offset(-diff)
    //        }
    //
    //        searchListTableView.snp.updateConstraints {
    //          $0.bottom.equalToSuperview().offset(-diff)
    //        }
    //    self.view.layoutIfNeeded()
  }
  
  @objc private func changeHistoryNewItem() {
    if SearchHistory.shared.history.isEmpty {
      self.searchMainView.removeAllHistoryItems()
    } else {
      let newItemIdx = SearchHistory.shared.history.count - 1
      self.searchMainView.addHistoryNewItem(SearchHistory.shared.history[newItemIdx])
    }
  }
  
  @objc private func didTapLeftButton() {
    self.navigationController?.popViewController(animated: true)
  }
  
  private func setupNoResultView(town: String, searchText: String, type: SearchType) {
    if searchNoResultView != nil {
      searchNoResultView?.isHidden = false
    } else {
      searchNoResultView = NoResultView(town: town, keyword: searchText, type: type)
      searchNoResultView?.isHidden = false
      guard let noResultView = searchNoResultView else { return }
      self.view.addSubview(noResultView)
      noResultView.snp.makeConstraints {
        $0.top.equalToSuperview().offset(8)
        $0.leading.trailing.bottom.equalToSuperview()
      }
    }
  }
}

// MARK: - Extension
extension SearchViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      searchMainView.isHidden = false
      searchListTableView.isHidden = true
      searchResultsView.isHidden = true
      searchNoResultView?.isHidden = true
    } else {
      dummyList = dummyData.filter { $0.contains(searchText) }
      searchListTableView.isHidden = false
      searchMainView.isHidden = false
      searchResultsView.isHidden = true
      searchNoResultView?.isHidden = true
    }
  }
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchText = searchBar.text else { return }
    dummyList = dummyData.filter { $0.contains(searchText) }
    searchMainView.isHidden = true
    searchListTableView.isHidden = true
    if dummyList.isEmpty {
      setupNoResultView(town: "성수동", searchText: searchText, type: .usedDeal)
    } else {
      searchResultsView.isHidden = false
      searchNoResultView?.isHidden = true
    }
    searchBar.resignFirstResponder()
    
    if !searchText.isEmpty { SearchHistory.shared.history.append(searchBar.text!) }
  }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchListTableView.isHidden = true
    searchResultsView.isHidden = true
    searchMainView.isHidden = false
    searchNoResultView?.isHidden = true
  }
}

extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if dummyList.isEmpty {
      return 0
    } else if dummyList.count > 15 {
      return 15
    } else {
      return dummyList.count
    }
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.imageView?.image = UIImage(systemName: "magnifyingglass")
    cell.imageView?.tintColor = .gray
    cell.textLabel?.text = dummyList[indexPath.row]
    return cell
  }
}

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    searchListTableView.isHidden = true
    searchResultsView.isHidden = false
    searchResultsView.makeProductList(keyWord: searchBar.searchTextField.text ?? "")
    searchBar.resignFirstResponder()
  }
}

extension SearchViewController: HistoryKeywordsViewDelegate {
  func deleteAllHistory() {
    SearchHistory.shared.history.removeAll()
    print(SearchHistory.shared.history.count)
  }
}
