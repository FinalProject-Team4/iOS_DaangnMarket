//
//  SearchPersonView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/20.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class SearchPersonView: UIView {
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
  
  // MARK: Views
  private let mainView = SearchMainView(type: .person)
  private let failView = SearchFailView(town: "성수동", type: .person)
  
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
    [mainView, failView].forEach { self.addSubview($0) }
  }
  
  private func setupConstraints() {
    [mainView, failView].forEach { views in
      views.snp.makeConstraints {
        $0.edges.size.equalToSuperview()
      }
    }
  }
  
  // MARK: Methods
  private func standBySearch() {
    mainView.isHidden = false
    failView.isHidden = true
  }
  private func searching() {
    mainView.isHidden = true
    failView.isHidden = true
  }
  private func searchSuccess() {
    mainView.isHidden = true
    failView.isHidden = false
  }
  private func searchFail() {
    mainView.isHidden = true
    failView.isHidden = false
  }
}
