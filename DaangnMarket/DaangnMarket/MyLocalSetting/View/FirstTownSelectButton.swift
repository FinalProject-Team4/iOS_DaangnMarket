//
//  FirstTownSelectButton.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/05.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
protocol DeleteButtonDelegate: class {
  func didTapDeleteButton(_ button: UIButton)
}

class FirstTownSelectButton: UIButton {
  // MARK: Property
  
  weak var delegate: DeleteButtonDelegate?
  let noti = NotificationCenter.default
  
  // MARK: Views
  
  lazy var selectedFirstTownLabel = UILabel().then {
    guard let firstSelect = AuthorizationManager.shared.selectedTown else { fatalError("First Town Select Lable error") }
    $0.text = firstSelect.dong
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 16, weight: .bold)
  }
  lazy var deleteSelectedFirstTownButton = UIButton().then {
    $0.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
    $0.transform = .init(scaleX: 1.2, y: 1.2)
    $0.tintColor = .white
    $0.addTarget(self, action: #selector(didTapFirstTownDeleteButton), for: .touchUpInside)
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupFirstBtnConstraints()
    addObserve()
  }
  
  deinit {
    noti.removeObserver(self, name: NSNotification.Name("FirstSelectTownCountView"), object: nil)
  }
  
  private func setupFirstBtnConstraints() {
    let inButtonSubUI = [selectedFirstTownLabel, deleteSelectedFirstTownButton]
    inButtonSubUI.forEach { self.addSubview($0) }
    selectedFirstTownLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-16)
      $0.leading.equalToSuperview().offset(16)
    }
    deleteSelectedFirstTownButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-14)
      $0.width.equalTo(25)
      $0.height.equalTo(25)
    }
  }
  
  // MARK: Notification Observer
  private func addObserve() {
    noti.addObserver(
      self,
      selector: #selector(changeFirstTownName),
      name: NSNotification.Name("FirstSelectTownCountView"),
      object: nil
    )
  }
  
  // MARK: Action
  
  @objc private func didTapFirstTownDeleteButton(_ button: UIButton) {
    self.delegate?.didTapDeleteButton(button)
    print("Delete First Town")
  }
  
  @objc private func changeFirstTownName() {
    selectedFirstTownLabel.text = MyTownSetting.shared.firstSelectTown
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
