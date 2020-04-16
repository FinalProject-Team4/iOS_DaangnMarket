//
//  BestKeywordsView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class BestKeywordsView: UIView {
  
  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .bold)
    $0.textColor = .black
  }
  
  private lazy var layout = UICollectionViewFlowLayout().then {
    $0.minimumLineSpacing = 8
    $0.minimumLineSpacing = 8
    $0.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
  }
  
  private lazy var keywordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
    $0.backgroundColor = .white
    $0.isScrollEnabled = false
    $0.dataSource = self
    $0.register(KeywordCollectionViewCell.self, forCellWithReuseIdentifier: KeywordCollectionViewCell.cellID)
  }
  
  private let keywordData = ["마스크", "자전거", "의자", "노트북", "쇼파", "책상", "냉장고", "아이패드"]
  
  init(type: SearchType) {
    super.init(frame: .zero)
    setupUI()
    type == .townInfo ? (titleLabel.text = "인기 검색어") : (titleLabel.text = "추천 검색어")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    self.backgroundColor = .white
    self.addSubview(titleLabel)
    self.addSubview(keywordCollectionView)
  }
  
  private func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(16)
    }
    keywordCollectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(16)
      $0.height.equalToSuperview().multipliedBy(0.7)
    }
  }
}

extension BestKeywordsView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    keywordData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCollectionViewCell.cellID, for: indexPath) as? KeywordCollectionViewCell else { return UICollectionViewCell() }
    item.label.text = keywordData[indexPath.row]
    return item
  }
}
