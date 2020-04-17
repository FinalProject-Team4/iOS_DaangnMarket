//
//  HistoryKeywordsView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol HistoryKeywordsViewDelegate: class {
  func deleteAllHistory()
}

class HistoryKeywordsView: UIView {
  // MARK: Views
  private let titleLabel = UILabel().then {
    $0.text = "최근 검색"
    $0.font = .systemFont(ofSize: 14, weight: .bold)
  }
  private let listStackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .fillEqually
    $0.alignment = .center
  }
  private lazy var deleteAllButton = UIButton().then {
    $0.setTitle("전체 삭제", for: .normal)
    $0.setTitleColor(.gray, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 14)
    $0.addTarget(self, action: #selector(didTapAllDeleteButton), for: .touchUpInside)
  }
  
  // MARK: Properties
  weak var delegate: HistoryKeywordsViewDelegate?
  
  // MARK: Initialize
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
    makeHistoryListItem()
  }
  
  private func setupAttributes() {
    self.backgroundColor = .white
    [titleLabel, listStackView, deleteAllButton].forEach {
      self.addSubview($0)
    }
  }
  
  private func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(16)
    }
    listStackView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.bottom.equalTo(deleteAllButton.snp.top).offset(-8)
      $0.leading.trailing.equalToSuperview()
    }
    deleteAllButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-24)
      $0.trailing.equalToSuperview().offset(-16)
    }
  }
  
  // MARK: Actions
  @objc private func didTapXButton(_ sender: UIButton) {
    print(sender)
  }
  
  @objc private func didTapAllDeleteButton() {
    delegate?.deleteAllHistory()
  }
  
  // MARK: Methods
  private func makeHistoryListItem() {
    if SearchHistory.shared.history.count == 1 {
      print("self.addSubview(listStackView)")
      self.addSubview(listStackView)
    }
    for txt in SearchHistory.shared.history.sorted() {
      addListStackView(text: txt)
    }
  }
  
  func addListStackView(text: String) {
    let itemView = UIView().then {
      $0.backgroundColor = .white
    }
    let tagImageView = UIImageView().then {
      let tagImage = UIImage(named: "tag")
      tagImage?.withAlignmentRectInsets(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
//      $0.image = UIImage(systemName: "tag")
      $0.image = tagImage
//        UIImage(named: "tag")
      $0.contentMode = .scaleAspectFit
      $0.tintColor = .black
//      $0.transform = CGAffineTransform(scaleX: -1, y: 1)
      $0.clipsToBounds = true
      $0.layer.cornerRadius = 16
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    let titleLabel = UILabel().then { label in
      label.font = .systemFont(ofSize: 13, weight: .bold)
      label.text = text
    }
    let deleteButton = UIButton().then {
      $0.setImage(UIImage(systemName: "xmark"), for: .normal)
      $0.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
      $0.tintColor = .black
      $0.addTarget(self, action: #selector(didTapXButton), for: .touchUpInside)
    }
    let bottomLine = UIView().then {
      $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
    }
    [tagImageView, titleLabel, deleteButton, bottomLine].forEach { itemView.addSubview($0) }
    tagImageView.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-16)
      $0.width.equalTo(tagImageView.snp.height)
    }
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(tagImageView.snp.trailing).offset(16)
      $0.centerY.equalToSuperview()
    }
    deleteButton.snp.makeConstraints {
      $0.width.equalTo(deleteButton.snp.height)
      $0.top.equalToSuperview().offset(24)
      $0.bottom.equalToSuperview().offset(-24)
      $0.trailing.equalToSuperview().offset(-16)
    }
    bottomLine.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.leading.equalTo(tagImageView)
      $0.trailing.equalTo(deleteButton)
      $0.bottom.equalToSuperview()
    }
    listStackView.insertArrangedSubview(itemView, at: 0)
    itemView.layer.addBorder(edge: .bottom, color: UIColor(named: ColorReference.borderLine.rawValue)!, thickness: 10)
    itemView.snp.makeConstraints {
      $0.height.equalTo(64)
      $0.leading.trailing.width.equalToSuperview()
    }
  }
  
  // MARK: Interface
  func makeNewHistoryItem(_ item: String) {
    addListStackView(text: item)
  }
  func removeAllItemsInStackView() {
    listStackView.removeFromSuperview()
  }
}
