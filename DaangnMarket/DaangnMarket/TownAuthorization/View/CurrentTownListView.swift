//
//  CurrentTownListView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol CurrentTownListViewDelegate: class {
  func selectedTag(_ tag: Int)
}

class CurrentTownListView: UIScrollView {
  // MARK: Views
  private var stackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .leading
    $0.distribution = .equalSpacing
    $0.spacing = 16
  }
  private var itemViewList: [UIControl] = []
  
  // MARK: Properties
  weak var viewDelegate: CurrentTownListViewDelegate?
  
  // MARK: Initialize
  init(list: [String]) {
    super.init(frame: .zero)
    setupUI()
    setupListView(list)
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    self.addSubview(stackView)
    self.showsVerticalScrollIndicator = false
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
    }
  }
  
  private func setupListView(_ list: [String]) {
    for item in list {
      let itemView = CurrentTownListItemView(item)
      itemView.backgroundColor = .yellow
      itemView.tag = list.firstIndex(of: item)!
      itemView.addTarget(self, action: #selector(didTapItemView), for: .touchUpInside)
      stackView.addArrangedSubview(itemView)
      itemView.snp.makeConstraints {
        $0.width.equalTo(UIScreen.main.bounds.width * 0.7)
        $0.height.equalTo(24)
      }
    }
  }
  
  // MARK: Actions
  @objc private func didTapItemView() {
    print("---------------------------------------------------------")
//    for item in stackView.subviews {
//      guard let item = item as? CurrentTownListItemView else { return }
//      sender == item ? item.didSelectItem() : item.didDeSelectItem()
//    }
//    self.viewDelegate?.selectedTag(sender.tag)
  }
}
