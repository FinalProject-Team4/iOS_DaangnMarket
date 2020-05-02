//
//  TabMenuView.swift
//  DaangnMarket
//
//  Created by Mac mini on 2020/04/11.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

// MARK: Protocol
protocol TabMenuViewDelegate: class {
  func tabBarMenu(scrollTo index: Int)
}

class TabMenuView: UIView {
  // MARK: Properties
  
  weak var delegate: TabMenuViewDelegate?
  private let viewWidth = UIScreen.main.bounds.width
  //private var tabMenuTitles = ["전체", "거래중", "거래완료"]
  private var tabMenuTitles: [String] = []
  var indicatorViewLeadingConstraint: NSLayoutConstraint?
  var indicatorViewWidthConstraint: NSLayoutConstraint?
  
  // MARK: Views
  
  private let flowLayout = UICollectionViewFlowLayout().then {
    $0.scrollDirection = .horizontal
  }
  lazy var tabMenuCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
    $0.showsHorizontalScrollIndicator = false
    $0.backgroundColor = .white
    $0.isScrollEnabled = false
  }
  private var indicatorView = UIView().then {
    $0.backgroundColor = .black
  }
  private let bottomLine = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  
  // MARK: Initialize
  
 override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init(menuTitles: [String]) {
    self.init()
    self.backgroundColor = .white
    tabMenuTitles = menuTitles
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupUI() {
    setupCollectionView()
    setupConstraints()
  }
  
  private func setupCollectionView() {
    tabMenuCollectionView.delegate = self
    tabMenuCollectionView.dataSource = self
    tabMenuCollectionView.register(TabMenuCollectionViewCell.self, forCellWithReuseIdentifier: TabMenuCollectionViewCell.identifier)
    let indexPath = IndexPath(item: 0, section: 0)
    tabMenuCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
  }
  
  private func setupConstraints() {
    //let tabMenuHeight: CGFloat = 55
    let indicatorHeight: CGFloat = 3
    
    self.tabMenuCollectionView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.trailing.equalTo(self)
        //$0.height.equalTo(tabMenuHeight)
    }
    self.indicatorView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.height.equalTo(indicatorHeight)
        $0.top.equalTo(tabMenuCollectionView.snp.bottom)
    }
    self.bottomLine.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.width.leading.bottom.equalToSuperview()
        //$0.width.equalTo(viewWidth)
        $0.height.equalTo(0.5)
        $0.top.equalTo(indicatorView.snp.bottom)
        //$0.leading.bottom.equalToSuperview()
    }
    indicatorView.translatesAutoresizingMaskIntoConstraints = false
    self.indicatorViewLeadingConstraint = self.indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
    self.indicatorViewLeadingConstraint?.isActive = true
    self.indicatorViewWidthConstraint = self.indicatorView.widthAnchor.constraint(equalToConstant: self.frame.width / 3)
    self.indicatorViewWidthConstraint?.isActive = true
  }
}

// MARK: - UICollectionViewDataSource

extension TabMenuView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabMenuCollectionViewCell.identifier, for: indexPath) as? TabMenuCollectionViewCell else { return UICollectionViewCell() }
    cell.tabMenuLabel.text = tabMenuTitles[indexPath.item]
    if indexPath.item == 0 {
      cell.tabMenuLabel.textColor = .black
      collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TabMenuView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //return CGSize(width: viewWidth / 3, height: 55)
    return CGSize(width: collectionView.frame.size.width / 3, height: collectionView.frame.size.height)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.tabBarMenu(scrollTo: indexPath.item)
    guard let cell = collectionView.cellForItem(at: indexPath) as? TabMenuCollectionViewCell else { return }
    cell.tabMenuLabel.textColor = .black
  }
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? TabMenuCollectionViewCell else { return }
    cell.tabMenuLabel.textColor = UIColor(named: ColorReference.subText.rawValue)
  }
}
