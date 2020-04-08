//
//  FirstTownSelectButton.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/05.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class FirstTownSelectButton: UIButton {
  lazy var selectedMyFirstTownLabel = UILabel().then {
    $0.text = MyTownSetting.shared.towns["first"]
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 16, weight: .bold)
  }
  lazy var deleteSelectedMyFirstTownButton = UIButton().then {
    $0.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
    $0.transform = .init(scaleX: 1.2, y: 1.2)
    $0.tintColor = .white
    $0.addTarget(self, action: #selector(didTapDeleteTownButton), for: .touchUpInside)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupConstraints()
  }
  
  private func setupConstraints() {
    let inButtonSubUI = [selectedMyFirstTownLabel, deleteSelectedMyFirstTownButton]
    inButtonSubUI.forEach { self.addSubview($0) }
    selectedMyFirstTownLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
    }
    deleteSelectedMyFirstTownButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-14)
      $0.width.equalTo(25)
      $0.height.equalTo(25)
    }
  }
  
  @objc private func didTapDeleteTownButton() {
    print("Delete First Town")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
