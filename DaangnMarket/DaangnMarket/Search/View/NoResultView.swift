//
//  NoResultView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class NoResultView: UIView {
  func updateFailKeyword(_ text: String) {
    resultLabel.attributedText = NSMutableAttributedString()
    .normal("\(text)", textColor: UIColor(named: ColorReference.daangnMain.rawValue), fontSize: 16)
    .normal("의 검색결과가 없어요.", fontSize: 16)
  }
  
  private let daangImageView = UIImageView().then {
    $0.image = UIImage(named: "DanngnCry")
    $0.contentMode = .scaleToFill
  }
  
  private lazy var townLabel = UILabel().then {
    $0.text = "앗! \(selectedTown) 근처에는"
    $0.font = .systemFont(ofSize: 16)
    self.addSubview($0)
  }
  
  private lazy var resultLabel = UILabel().then {
    $0.textAlignment = .center
    $0.numberOfLines = 0
//    $0.attributedText = NSMutableAttributedString()
//      .normal("\(searchText)", textColor: UIColor(named: ColorReference.daangnMain.rawValue), fontSize: 16)
//      .normal("의 검색결과가 없어요.", fontSize: 16)
    self.addSubview($0)
  }
  
  private let selectedTown: String
  private var searchText: String

  init(town: String, keyword: String, type: SearchType) {
    selectedTown = town
    searchText = keyword
    super.init(frame: .zero)
    self.backgroundColor = .white
    setupImageView()
    setupResultLabel()
    makeSuggestionLabel(town: town, type: type)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupImageView() {
    self.addSubview(daangImageView)
    daangImageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.centerX.equalToSuperview()
      $0.size.equalTo(180)
    }
  }
  
  private func setupResultLabel() {
    townLabel.snp.makeConstraints {
      $0.top.equalTo(daangImageView.snp.bottom)
      $0.centerX.equalToSuperview()
    }
    resultLabel.snp.makeConstraints {
      $0.top.equalTo(townLabel.snp.bottom)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
    }
  }
  
  private func makeSuggestionLabel(town: String, type: SearchType) {
    let backgroundView = UIView().then {
      $0.backgroundColor = UIColor(named: ColorReference.lightBackground.rawValue)
      $0.layer.cornerRadius = 8
      self.addSubview($0)
    }
    backgroundView.snp.makeConstraints {
      $0.top.equalTo(daangImageView.snp.bottom).offset(70)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
    }
    let titleLabel = UILabel().then {
      $0.text = "이건 어때요?"
      $0.textColor = .black
      $0.font = .systemFont(ofSize: 14, weight: .bold)
      backgroundView.addSubview($0)
    }
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.leading.equalToSuperview().offset(16)
    }
    let detailLabel = UILabel().then {
      $0.numberOfLines = 0
      $0.font = .systemFont(ofSize: 14)
      $0.textColor = .black
      backgroundView.addSubview($0)
    }
    detailLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(12)
      $0.leading.equalTo(titleLabel)
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalToSuperview().offset(-12)
    }
    detailLabel.text = type == .usedDeal ? usedDealDetailText() : townInfoDetailText(town)
  }
  
  private func usedDealDetailText() -> String {
    return "• 키워드를 정확하게 입력하셨는지 확인해보세요."
      + "\n" + "• 일반적인 키워드로 검색해보세요. (예 : 빨간 가방 > 가방)"
      + "\n" + "• 키워드 알림을 등록해보세요. 새 글이 등록되면 알림을 받을 수 있어요."
  }
  private func townInfoDetailText(_ town: String) -> String {
    return "• 키워드를 정확하게 입력하셨는지 확인해보세요."
      + "\n" + "• 업종으로 검색해보세요. (예: 인테리어, 미용실 등)"
      + "\n" + "• 동네생활 탭에서 \(town) 근처 이웃들에게 직접 질문해보세요."
  }
}
