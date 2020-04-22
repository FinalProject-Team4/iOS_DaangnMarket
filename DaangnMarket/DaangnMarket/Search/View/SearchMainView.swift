//
//  SearchMainView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class SearchMainView: UIView {
  // MARK: Views
  private let scrollView = UIScrollView()
  private let historyKeywordsView = HistoryKeywordsView()
  private let bestKeywordsView = BestKeywordsView(type: .townInfo)
  
  // MARK: Properties
  weak var delegate: HistoryKeywordsViewDelegate? {
    willSet {
      historyKeywordsView.delegate = newValue
    }
  }
  
  // MARK: Initialize
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    self.backgroundColor = UIColor(named: ColorReference.lightBackground.rawValue)
    self.addSubview(scrollView)
    scrollView.snp.makeConstraints {
      $0.edges.size.equalToSuperview()
    }
    SearchHistory.shared.history.isEmpty ? setupBestViewOnly() : setupHistoryViewAndBestView()
  }
  
  private func setupBestViewOnly() {
    scrollView.addSubview(bestKeywordsView)
    bestKeywordsView.snp.makeConstraints {
      $0.edges.width.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.2)
    }
  }
  
  private func setupHistoryViewAndBestView() {
    scrollView.addSubview(historyKeywordsView)
    historyKeywordsView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.width.equalToSuperview()
    }
    scrollView.addSubview(bestKeywordsView)
    bestKeywordsView.snp.makeConstraints {
      $0.top.equalTo(historyKeywordsView.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.2)
      $0.bottom.equalToSuperview()
    }
  }
  
  // MARK: Interface
  func addHistoryNewItem(_ item: String) {
    self.historyKeywordsView.makeNewHistoryItem(item)
    bestKeywordsView.snp.removeConstraints()
    historyKeywordsView.snp.removeConstraints()
    SearchHistory.shared.history.isEmpty ? setupBestViewOnly() : setupHistoryViewAndBestView()
  }
  func removeAllHistoryItems() {
    bestKeywordsView.snp.removeConstraints()
    historyKeywordsView.snp.removeConstraints()
    historyKeywordsView.removeFromSuperview()
    historyKeywordsView.removeAllItemsInStackView()
    setupBestViewOnly()
  }
}
