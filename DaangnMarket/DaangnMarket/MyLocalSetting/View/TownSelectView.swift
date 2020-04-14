//
//  selectTownView.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/03.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class TownSelectView: UIView {
  private let partitionLineView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.noResultImage.rawValue)
  }
  private lazy var townSelectLabel = UILabel().then {
    $0.text = "동네 선택"
    $0.font = .systemFont(ofSize: 17, weight: .bold)
  }
  private let townSelectDescribeLabel = UILabel().then {
    $0.text = "지역은 최소 1개 이상 최대 2개까지 설정가능해요."
    $0.font = .systemFont(ofSize: 13, weight: .regular)
    $0.textColor = UIColor(named: ColorReference.noResultImage.rawValue)
  }
  private let firstTownSelectBtn = FirstTownSelectButton().then {
    $0.layer.cornerRadius = 5
    $0.addTarget(self, action: #selector(didTapSelectTownButton), for: .touchUpInside)
    $0.backgroundColor = UIColor(named: ColorReference.daangnMain.rawValue)
  }
  private let secondTownSelectBtn = SecondTownSelectButton().then {
    $0.addTarget(self, action: #selector(didTapSelectTownButton), for: .touchUpInside)
    $0.layer.cornerRadius = 5
    $0.layer.borderColor = UIColor(named: ColorReference.noResultImage.rawValue)?.cgColor
    $0.layer.borderWidth = 1
    $0.backgroundColor = .white
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    inViewSetupConstraints()
  }
  
  private func inViewSetupConstraints() {
    let viewSubUI = [townSelectLabel, townSelectDescribeLabel, partitionLineView, firstTownSelectBtn, secondTownSelectBtn]
    viewSubUI.forEach { self.addSubview($0) }
    townSelectLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(24)
    }
    townSelectDescribeLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(townSelectLabel.snp.bottom).offset(8)
    }
    firstTownSelectBtn.snp.makeConstraints {
      $0.top.equalTo(townSelectDescribeLabel.snp.bottom).offset(16)
      $0.leading.equalTo(self.snp.leading).offset(12)
      $0.width.equalTo(172)
      $0.height.equalTo(50)
    }
    secondTownSelectBtn.snp.makeConstraints {
      $0.top.equalTo(firstTownSelectBtn)
      $0.trailing.equalTo(self.snp.trailing).offset(-12)
      $0.width.equalTo(172)
      $0.height.equalTo(50)
    }
    partitionLineView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.width.equalTo(self.snp.width).multipliedBy(0.9)
      $0.height.equalTo(0.5)
    }
  }
  private func changeSelectedTownButton(_ item: UIView) {
    item.backgroundColor = UIColor(named: ColorReference.daangnMain.rawValue)
    item.layer.borderWidth = 1
    item.layer.borderColor = UIColor(named: ColorReference.daangnMain.rawValue)?.cgColor
    if item == firstTownSelectBtn {
      firstTownSelectBtn.selectedMyFirstTownLabel.textColor = .white
      firstTownSelectBtn.deleteSelectedMyFirstTownButton.tintColor = .white
    } else if item == secondTownSelectBtn {
      secondTownSelectBtn.selectedMySecondTownLabel.textColor = .white
      secondTownSelectBtn.deleteSelectedMySecondTownButton.tintColor = .white
    }
  }
  private func changeUnSelectedTownButton(_ item: UIView) {
    item.layer.borderWidth = 1
    item.layer.borderColor = UIColor(named: ColorReference.noResultImage.rawValue)?.cgColor
    item.backgroundColor = .white
    if item == firstTownSelectBtn {
      firstTownSelectBtn.selectedMyFirstTownLabel.textColor = .black
      firstTownSelectBtn.deleteSelectedMyFirstTownButton.tintColor = UIColor(named: ColorReference.noResultImage.rawValue)
    } else if item == secondTownSelectBtn {
      secondTownSelectBtn.selectedMySecondTownLabel.textColor = .black
      secondTownSelectBtn.deleteSelectedMySecondTownButton.tintColor = UIColor(named: ColorReference.noResultImage.rawValue)
    }
  }
  
  @objc func didTapSelectTownButton(_ sender: UIButton) {
    switch sender {
    case firstTownSelectBtn:
      changeSelectedTownButton(firstTownSelectBtn)
      changeUnSelectedTownButton(secondTownSelectBtn)
    case secondTownSelectBtn:
      if MyTownSetting.shared.towns["second"] != nil {
        changeSelectedTownButton(secondTownSelectBtn)
        changeUnSelectedTownButton(firstTownSelectBtn)
      } else {
      }
    default: break
    }
  }
  
//  private func addSecondMyTownAction() {
//    let alertController = UIAlertController()
//
//    alertController.addAction(alertAction)
//  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

