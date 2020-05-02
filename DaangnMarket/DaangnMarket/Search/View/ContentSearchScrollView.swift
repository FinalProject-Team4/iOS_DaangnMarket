//
//  ContentSearchScrollView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/19.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ContentSearchScrollView: UIScrollView {
  // MARK: Interface
  func searchStatus(_ status: SearchStatus) {
    if status == .searching {
      self.isHidden = true
    } else {
      self.isHidden = false
      usedDealView.changeStatus(status)
      townInfoView.changeStatus(status)
      personView.changeStatus(status)
    }
  }
  func addHistoryNewItem(_ text: String) {
    usedDealView.addHistoryNewItem(text)
    townInfoView.addHistoryNewItem(text)
    personView.addHistoryNewItem(text)
  }
//  func reloadHistoryItem(_ history: [String]) {
//    usedDealView.reloadHistoryItem(history)
//    townInfoView.reloadHistoryItem(history)
//    personView.reloadHistoryItem(history)
//  }
  func updateKeywordNotiCell(_ text: String) {
    usedDealView.updateKeywordNotiCell(text)
  }
  func updateFailKeyword(_ text: String) {
    usedDealView.updateFailKeyword(text)
    townInfoView.updateFailKeyword(text)
  }
  func searchResultPost(_ post: [Post]) {
    usedDealView.searchResultPost(post)
  }
  
  // MARK: Views
  private let usedDealView = SearchUsedDealView()
  private let townInfoView = SearchTownInfoView()
  private let personView = SearchPersonView()
  
  // MARK: Properties
  weak var historyDelegate: HistoryKeywordsViewDelegate? {
    willSet {
      usedDealView.delegate = newValue
      townInfoView.delegate = newValue
      personView.delegate = newValue
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
    [usedDealView, townInfoView, personView].forEach { self.addSubview($0) }
  }
  
  private func setupConstraints() {
    usedDealView.snp.makeConstraints {
//      $0.leading.top.bottom.height.equalToSuperview()
      $0.leading.top.bottom.equalToSuperview()
      $0.width.equalTo(UIScreen.main.bounds.width)
    }
    townInfoView.snp.makeConstraints {
      $0.leading.equalTo(usedDealView.snp.trailing)
      $0.top.bottom.height.equalToSuperview()
      $0.width.equalTo(UIScreen.main.bounds.width)
    }
    personView.snp.makeConstraints {
      $0.leading.equalTo(townInfoView.snp.trailing)
      $0.trailing.top.bottom.height.equalToSuperview()
      $0.width.equalTo(UIScreen.main.bounds.width)
    }
  }
}
