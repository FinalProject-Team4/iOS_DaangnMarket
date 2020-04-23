//
//  WriteKeywordViewController.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/02.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class WriteKeywordViewController: UIViewController {
  private let keyWordView = UIView().then {
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }
  
  private let noticeLabel = UILabel().then {
    $0.text = "게시글에 자주쓰는 문구를 선택해주세요."
    $0.textColor = .gray
  }
  
  private let noticeView = UIView().then {
    $0.backgroundColor = .lightGray
  }
  
  private lazy var keywordTableView = UITableView().then {
    $0.dataSource = self
    $0.register(KeywordTableViewCell.self, forCellReuseIdentifier: KeywordTableViewCell.cellID)
  }
  
  private let writeView = UIView().then {
    $0.backgroundColor = .blue
  }
  
  private let textViewPlaceHolder = UILabel().then {
    $0.text = "자주쓰는 문구를 입력하세요."
    $0.textColor = .lightGray
  }
  
  private lazy var writeTextView = UITextView().then {
    $0.delegate = self
  }
  
  private let addButton = UIButton().then {
    $0.setTitle("추가", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 13)
    $0.backgroundColor = .black
    $0.layer.cornerRadius = 4
  }
  
  // 사용자가 등록한 문구 받아오는 곳
  private var registerKeywordArr: [String] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    view.addSubview(keyWordView)
    
    keyWordView.addSubview(noticeView)
    noticeView.addSubview(noticeLabel)
    
    keyWordView.addSubview(keywordTableView)
    
    keyWordView.addSubview(writeView)
    writeView.addSubview(writeTextView)
    writeView.addSubview(addButton)
  }
  
  private func setupConstraints() {
    keyWordView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalToSuperview().offset(-16)
      $0.height.equalToSuperview().multipliedBy(0.4)
      $0.width.equalTo(keyWordView.snp.height)
    }
    
    noticeView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(keywordTableView.snp.top)
    }
    
    noticeLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-16)
    }
    
    keywordTableView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }
    
    writeView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(keywordTableView.snp.bottom)
      $0.height.equalTo(noticeView)
    }
    
    writeTextView.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-16)
      $0.trailing.equalTo(addButton.snp.leading).offset(-24)
    }
    
    addButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8)
      $0.trailing.equalToSuperview().offset(-8)
      $0.width.equalToSuperview().multipliedBy(0.16)
    }
  }
}

extension WriteKeywordViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    registerKeywordArr.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: KeywordTableViewCell.cellID, for: indexPath)
    return cell
  }
}

extension WriteKeywordViewController: UITextViewDelegate {
}
