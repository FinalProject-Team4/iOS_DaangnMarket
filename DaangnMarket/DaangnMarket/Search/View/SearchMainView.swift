//
//  SearchMainView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/19.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class SearchMainView: UIView {
  // MARK: Interface
  func addHistoryNewItem(_ item: String) {
    self.searchHistoyView.makeNewHistoryItem(item)
    keywordView.snp.removeConstraints()
    searchHistoyView.snp.removeConstraints()
    SearchHistory.shared.history.isEmpty ? setupBestViewOnly() : setupHistoryViewAndBestView()
  }
//  func reloadHistoryItem(_ history: [String]) {
//    self.searchHistoyView.removeItemInStackView(history)
//    keywordView.snp.removeConstraints()
//    searchHistoyView.snp.removeConstraints()
//    SearchHistory.shared.history.isEmpty ? setupBestViewOnly() : setupHistoryViewAndBestView()
//  }
  func removeAllHistoryItems() {
    keywordView.snp.removeConstraints()
    searchHistoyView.snp.removeConstraints()
    searchHistoyView.removeFromSuperview()
    searchHistoyView.removeAllItemsInStackView()
    setupBestViewOnly()
  }
  
  // MARK: Views
  private let scrollView = UIScrollView()
  private let searchHistoyView = HistoryKeywordsView()
  private var keywordView: SearchKeywordsView
  
  // MARK: Properties
  weak var delegate: HistoryKeywordsViewDelegate? {
    willSet {
      searchHistoyView.delegate = newValue
    }
  }
  
  // MARK: Interface
  init(type: SearchType) {
    keywordView = SearchKeywordsView(type: type)
    super.init(frame: .zero)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    self.backgroundColor = UIColor(named: ColorReference.lightBackground.rawValue)
    self.addSubview(scrollView)
    scrollView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    SearchHistory.shared.history.isEmpty ? setupBestViewOnly() : setupHistoryViewAndBestView()
  }
  
  private func setupBestViewOnly() {
    scrollView.addSubview(keywordView)
    keywordView.snp.makeConstraints {
      $0.edges.width.equalToSuperview()
      $0.height.equalTo(152)
    }
  }
  
  private func setupHistoryViewAndBestView() {
    scrollView.addSubview(searchHistoyView)
    searchHistoyView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.width.equalToSuperview()
    }
    scrollView.addSubview(keywordView)
    keywordView.snp.makeConstraints {
      $0.top.equalTo(searchHistoyView.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(152)
      $0.bottom.equalToSuperview()
    }
  }
}
