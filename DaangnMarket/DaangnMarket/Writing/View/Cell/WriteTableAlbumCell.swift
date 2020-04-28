//
//  WriteTableAlbumCell.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/03/25.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

// MARK: - Class Level
class WriteTableAlbumCell: UITableViewCell {  
  static let cellID = "WriteTableAlbumCell"
  
  // MARK: Views
  
  lazy var addImageView = AddImageView(count: imageCount)
  
  private let albumScrollView = UIScrollView().then {
    $0.showsHorizontalScrollIndicator = false
  }
  
  private let selectedStackView = UIStackView().then {
    $0.alignment = .bottom
    $0.axis = .horizontal
    $0.distribution = .equalSpacing
    $0.spacing = 8
  }
  
  // MARK: Properties
  
  private var imageCount = 0 {
    didSet {
      addImageView.imageCount = self.imageCount
    }
  }
  
  // MARK: Initialize
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    contentView.addSubview(albumScrollView)
    albumScrollView.addSubview(selectedStackView)
    selectedStackView.addArrangedSubview(addImageView)
  }
  
  private func setupConstraints() {
    albumScrollView.snp.makeConstraints {
      $0.edges.equalTo(contentView)
      $0.size.equalTo(contentView)
    }
    
    selectedStackView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 8))
      $0.height.equalToSuperview().multipliedBy(0.8)
    }
    
    addImageView.snp.makeConstraints {
      $0.width.equalTo(addImageView.snp.height)
      $0.height.equalToSuperview()
    }
  }
}


// MARK: - Extension Level
extension WriteTableAlbumCell: WriteUsedViewControllerDelegate {
  func selectImage(image: UIImage) {
    let selectImageView = SelectedImageView(image: image, button: true)
    selectImageView.delegate = self
    selectedStackView.addArrangedSubview(selectImageView)
    imageCount += 1
    selectImageView.snp.makeConstraints {
      $0.size.equalTo(addImageView)
    }
    guard let parentVC = self.tableView?.parentViewController as? WriteUsedViewController else { return }
    parentVC.uploadImages.append(image)
  }
}

extension WriteTableAlbumCell: SelectedImageViewDelegate {
  func deleteImage(_ view: UIView) {
    if let idx = selectedStackView.arrangedSubviews.firstIndex(of: view) {
      guard let parentVC = self.tableView?.parentViewController as? WriteUsedViewController else { return }
      parentVC.uploadImages.remove(at: idx - 1)
    }
    UIView.animate(withDuration: 0.3) {
      self.imageCount -= 1
      self.selectedStackView.arrangedSubviews
        .filter { $0.isEqual(view) }
        .first?
        .do { $0.removeFromSuperview() }
      self.tableView?.superview?.layoutIfNeeded()
    }
  }
}
