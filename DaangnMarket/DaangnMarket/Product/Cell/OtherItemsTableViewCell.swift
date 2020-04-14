//
//  OtherItemsTableViewCell.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/03.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol OtherItemsTableViewCellDelegate: class {
  func moveToPage()
}

class OtherItemsTableViewCell: UITableViewCell {
  static let identifier = "OtherItemsTableCell"
  weak var delegate: OtherItemsTableViewCellDelegate?
  
  // MARK: Views
  
  private let sellerNameLabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.boldSystemFont(ofSize: 15)
  }
  private let topLineView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  private let flowLayout = UICollectionViewFlowLayout()
  private lazy var collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewWidth), collectionViewLayout: flowLayout)
  
  // MARK: Properties
  
  var otherItems: [[String]] = []
  private let viewWidth = UIScreen.main.bounds.width
  private let spacing: CGFloat = 16
  
  // MARK: Initialize
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(items: [[String]], sellerName: String) {
    self.otherItems = items
    sellerNameLabel.text = "\(sellerName)님의 판매 상품"
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    setupCollectionView()
  }
  
  private func setupFlowLayout() {
//    let cellSize: CGFloat = (viewWidth - (spacing * 3)) / 2
//    flowLayout.itemSize = CGSize(width: cellSize, height: cellSize)
//    flowLayout.minimumLineSpacing = spacing
//    flowLayout.minimumInteritemSpacing = spacing
//    flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  private func setupCollectionView() {
    setupFlowLayout()
    collectionView.backgroundColor = .white
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(OtherItemsCollectionViewCell.self, forCellWithReuseIdentifier: OtherItemsCollectionViewCell.identifier)
  }
  
  private func setupConstraints() {
    self.sellerNameLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.equalTo(self).offset(spacing)
    }
    self.collectionView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(sellerNameLabel.snp.bottom).offset(spacing)
        $0.leading.trailing.equalTo(self).inset(spacing)
        $0.bottom.equalTo(self)
    }
    self.topLineView.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.height.equalTo(0.3)
        $0.width.equalTo(self).offset(-spacing * 2)
        $0.centerX.equalTo(self)
        $0.top.equalTo(self)
    }
  }
}
// MARK: - UICollectionViewDataSource

extension OtherItemsTableViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return otherItems.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OtherItemsCollectionViewCell.identifier, for: indexPath) as? OtherItemsCollectionViewCell else { return UICollectionViewCell() }
    let item = otherItems[indexPath.row]
    cell.configure(image: UIImage(named: item[0]), title: item[1], price: item[2])
    return cell
  }
}
// MARK: - UICollectionViewDelegateFlowLayout

extension OtherItemsTableViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellSize: CGFloat = (viewWidth - (spacing * 3)) / 2
    return CGSize(width: cellSize, height: cellSize)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return spacing
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return spacing
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.moveToPage()
  }
}
