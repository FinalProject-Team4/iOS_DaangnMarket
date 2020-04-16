//
//  NoResultView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/16.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class NoResultView: UIView {
  
  private let daangImageView = UIImageView().then {
    $0.image = UIImage(systemName: "person")
    $0.contentMode = .scaleAspectFill
  }
  
  init(town: String, keyword: String, type: SearchType) {
    super.init(frame: .zero)
    makeImageView()
    makeResultLabel(town: town, keyword: keyword)
    makeSuggestionLabel(town: town, type: type)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func makeImageView() {
    self.addSubview(daangImageView)
    daangImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.centerX.equalToSuperview()
      $0.size.equalTo(140)
    }
  }
  
  private func makeResultLabel(town: String, keyword: String) {
    let townLabel = UILabel().then {
      $0.text = "앗! \(town) 근처에는"
      $0.font = .systemFont(ofSize: 16)
      self.addSubview($0)
    }
    let resultLabel = UILabel().then {
      $0.text = "\(keyword)의 검색결과가 없어요."
      $0.font = .systemFont(ofSize: 16)
      self.addSubview($0)
    }
    townLabel.snp.makeConstraints {
      $0.top.equalTo(daangImageView.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
    }
    resultLabel.snp.makeConstraints {
      $0.top.equalTo(townLabel.snp.bottom)
      $0.centerX.equalToSuperview()
    }
  }
  
  private func makeSuggestionLabel(town: String, type: SearchType) {
    let backgroundView = UIView().then {
      $0.backgroundColor = .lightGray
      $0.layer.cornerRadius = 8
      self.addSubview($0)
    }
    backgroundView.snp.makeConstraints {
      $0.top.equalTo(daangImageView.snp.bottom).offset(80)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalToSuperview().multipliedBy(0.2)
    }
    
    let titleLabel = UILabel().then {
      $0.text = "이건 어때요?"
      $0.textColor = .black
      $0.font = .systemFont(ofSize: 16, weight: .bold)
      backgroundView.addSubview($0)
    }
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.leading.equalToSuperview().offset(16)
    }
    
    let commonLabel = UILabel().then {
      $0.text = "• 키워드를 정확하게 입력하셨는지 확인해보세요."
      $0.font = .systemFont(ofSize: 16)
      $0.textColor = .gray
      backgroundView.addSubview($0)
    }
    commonLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
      $0.leading.equalTo(titleLabel)
    }
    
    switch type {
    case .usedDeal:
      let usedDealLabel = UILabel().then {
        $0.text = "• 일반적인 키워드로 검색해보세요. (예 : 빨간 가방 > 가방)" + "\n"
          + "• 키워드 알림을 등록해보세요. 새 글이 등록되면 알림을 받을 수 있어요."
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .gray
        backgroundView.addSubview($0)
      }
      usedDealLabel.snp.makeConstraints {
        $0.top.equalTo(commonLabel.snp.bottom)
        $0.leading.equalTo(titleLabel)
      }
    case .townInfo:
      let townInfoLabel = UILabel().then {
        $0.text = "• 업종으로 검색해보세요. (예: 인테리어, 미용실 등)" + "\n" +
        "• 동네생활 탭에서 \(town) 근처 이웃들에게 직접 질문해보세요."
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .gray
        backgroundView.addSubview($0)
      }
      townInfoLabel.snp.makeConstraints {
        $0.top.equalTo(commonLabel.snp.bottom)
        $0.leading.equalTo(titleLabel)
      }
    }
  }
}
