//
//  SecondTownSelectButton.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/05.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class SecondTownSelectButton: UIButton {
  lazy var selectedMySecondTownLabel = UILabel().then {
    if MyTownSetting.shared.towns["second"] == nil {
      $0.isHidden = true
    } else {
      $0.isHidden = false
      $0.text = MyTownSetting.shared.towns["second"]
      $0.textColor = .black
      $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
  }
  lazy var deleteSelectedMySecondTownButton = UIButton().then {
    if MyTownSetting.shared.towns["second"] == nil {
      $0.isHidden = true
    } else {
      $0.isHidden = false
      $0.tintColor = UIColor(named: ColorReference.noResultImage.rawValue)
      $0.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
      $0.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
  }
  private let findAndAddButton = UIButton().then {
    if MyTownSetting.shared.towns["second"] == nil {
      $0.isHidden = false
      $0.setImage(UIImage(systemName: "plus"), for: .normal)
      $0.transform = .init(scaleX: 1.2, y: 1.2)
      $0.tintColor = UIColor(named: ColorReference.noResultImage.rawValue)
      $0.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    } else {
      $0.isHidden = true
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    inButtonSetupConstraints()
  }
  
  private func inButtonSetupConstraints() {
    let inButtonSubUI = [selectedMySecondTownLabel, deleteSelectedMySecondTownButton, findAndAddButton]
    inButtonSubUI.forEach { self.addSubview($0) }
    selectedMySecondTownLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
    }
    deleteSelectedMySecondTownButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-14)
      $0.width.equalTo(25)
      $0.height.equalTo(25)
    }
    findAndAddButton.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
  
  @objc private func didTapButton() {
    print("Delete Second Town")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
