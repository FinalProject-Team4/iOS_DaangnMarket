//
//  UserProfilePercentageView.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/13.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class UserProfilePercentageView: UIView {
  // MARK: Property
  
  private let viewWidth = UIScreen.main.bounds.width
  
  // MARK: Views
  
  private let heartMark = UIButton().then {
    $0.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    $0.tintColor = .systemGreen  // 색상 추가!!!!!!!!
    $0.contentMode = .scaleAspectFit
  }
  private let hopingRebuyingLabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.boldSystemFont(ofSize: 14)
    $0.text = "재거래희망률 -%"
    let fontSize = UIFont.systemFont(ofSize: 13)
    let title = NSMutableAttributedString(string: $0.text!)
    title.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String), value: fontSize, range: ($0.text! as NSString).range(of: "재거래희망률"))
    $0.attributedText = title
  }
  private let hopingRebuyingExplainLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.text = "표시될 만큼 충분히 거래하지 않았어요."
    $0.textColor = UIColor(named: ColorReference.subText.rawValue)
    $0.font = UIFont.systemFont(ofSize: 13)
  }
  private let storyBubbleMark = UIButton().then {
    $0.setImage(UIImage(systemName: "bubble.right.fill"), for: .normal)
    $0.tintColor = .systemYellow
    $0.contentMode = .scaleAspectFit
  }
  private let chatResponseLabel = UILabel().then {
    $0.textColor = .black
    $0.font = UIFont.boldSystemFont(ofSize: 14)
    $0.text = "응답률 -%"
    let fontSize = UIFont.systemFont(ofSize: 13)
    let title = NSMutableAttributedString(string: $0.text!)
    title.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String), value: fontSize, range: ($0.text! as NSString).range(of: "응답률"))
    $0.attributedText = title
  }
  private let chatResponseExplainLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.text = "표시될 만큼 충분히 채팅하지 않았어요."
    $0.textColor = UIColor(named: ColorReference.subText.rawValue)
    $0.font = UIFont.systemFont(ofSize: 13)
  }
  
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
  }
  
  private func setupAttributes() {
  }
  
  private func setupConstraints() {
    let spacing: CGFloat = 16
    let labelWidth: CGFloat = (viewWidth - (spacing * 6)) / 2
    
    self.heartMark.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalToSuperview().offset(spacing)
        $0.leading.equalToSuperview().offset(spacing)
        $0.width.equalTo(17)
        $0.height.equalTo(14)
    }
    self.hopingRebuyingLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.centerY.equalTo(heartMark)
        $0.leading.equalTo(heartMark.snp.trailing).offset(spacing / 2)
    }
    self.hopingRebuyingExplainLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(hopingRebuyingLabel.snp.bottom).offset(spacing / 2)
        $0.leading.equalTo(hopingRebuyingLabel)
        $0.width.equalTo(labelWidth)
        $0.bottom.equalToSuperview().offset(-spacing)
    }
    self.chatResponseExplainLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.trailing.equalToSuperview().offset(-spacing)
        $0.top.width.equalTo(hopingRebuyingExplainLabel)
        $0.bottom.equalToSuperview().offset(-spacing)
    }
    self.chatResponseLabel.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.bottom.equalTo(chatResponseExplainLabel.snp.top).offset(-spacing / 2)
        $0.leading.equalTo(chatResponseExplainLabel.snp.leading)
    }
    self.storyBubbleMark.then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.width.height.equalTo(heartMark)
        $0.centerY.equalTo(chatResponseLabel)
        $0.trailing.equalTo(chatResponseLabel.snp.leading).offset(-spacing / 2)
    }
  }
}
