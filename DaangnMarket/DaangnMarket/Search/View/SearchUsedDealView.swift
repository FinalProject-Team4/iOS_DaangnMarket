//
//  UsedDealSearchView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/19.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class SearchUsedDealView: UIView {
  // MARK: Interface
  func changeStatus(_ status: SearchStatus) {
    switch status {
    case .standBy:
      standBySearch()
    case .searching:
      searching()
    case .success:
      searchSuccess()
    case .fail:
      searchFail()
    }
  }
  func addHistoryNewItem(_ text: String) {
    mainView.addHistoryNewItem(text)
  }
//  func reloadHistoryItem(_ history: [String]) {
//    mainView.reloadHistoryItem(history)
//  }
  func updateKeywordNotiCell(_ text: String) {
    successView.searchKeyword = text
  }
  func updateFailKeyword(_ text: String) {
    failView.updateFailKeyword(text)
  }
  func searchResultPost(_ post: [Post]) {
    successView.searchResultPost = post
  }
  
  // MARK: Views
  private let mainView = SearchMainView(type: .usedDeal)
  private let successView = SearchSuccessView()
  private let failView = SearchFailView(town: "성수동", type: .usedDeal)
  
  // MARK: Properties
  weak var delegate: HistoryKeywordsViewDelegate? {
    willSet {
      mainView.delegate = newValue
    }
  }
  
  // MARK: Initialize
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    self.backgroundColor = UIColor(named: ColorReference.lightBackground.rawValue )
    [mainView, successView, failView].forEach { self.addSubview($0) }
  }
  
  private func setupConstraints() {
    [mainView, successView, failView].forEach { views in
      views.snp.makeConstraints {
//        $0.edges.size.equalToSuperview()
        $0.edges.equalToSuperview()
      }
    }
  }
  
  // MARK: Methods
  private func standBySearch() {
    mainView.isHidden = false
    successView.isHidden = true
    failView.isHidden = true
  }
  private func searching() {
    mainView.isHidden = true
    successView.isHidden = true
    failView.isHidden = true
  }
  private func searchSuccess() {
    mainView.isHidden = true
    successView.isHidden = false
    failView.isHidden = true
  }
  private func searchFail() {
    mainView.isHidden = true
    successView.isHidden = true
    failView.isHidden = false
  }
}
