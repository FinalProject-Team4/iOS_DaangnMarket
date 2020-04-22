//
//  SecondTownSelectButton.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/05.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class SecondTownSelectButton: UIButton {
  // MARK: Property
  
  weak var delegate: DeleteButtonDelegate?
  let noti = NotificationCenter.default
  
  // MARK: Views
  
  lazy var selectedSecondTownLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .systemFont(ofSize: 16, weight: .bold)
  }
  lazy var deleteSelectedSecondTownButton = UIButton().then {
    $0.transform = .init(scaleX: 1.2, y: 1.2)
    $0.tintColor = UIColor(named: ColorReference.noResultImage.rawValue)
    $0.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
    $0.addTarget(self, action: #selector(didTapSecondTownDeleteButton(_:)), for: .touchUpInside)
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSecondBtnConstraints()
    observeAnotherTownNameNoti()
  }
  
  deinit {
    noti.removeObserver(
      self,
      name: NSNotification.Name("anotherTownSecondTownBtn"),
      object: nil
    )
  }
  
  func setupSecondBtnConstraints() {
    let inButtonSubUI = [selectedSecondTownLabel, deleteSelectedSecondTownButton]
    inButtonSubUI.forEach { self.addSubview($0) }
    selectedSecondTownLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-16)
      $0.leading.equalToSuperview().offset(16)
    }
    deleteSelectedSecondTownButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-14)
      $0.width.equalTo(25)
      $0.height.equalTo(25)
    }
  }
  
  private func observeAnotherTownNameNoti() {
    noti.addObserver(
      self,
      selector: #selector(addAnotherTownNameToButton),
      name: NSNotification.Name("anotherTownSecondTownBtn"),
      object: nil
    )
  }
  
  // MARK: Action
  
  @objc func didTapSecondTownDeleteButton(_ sender: UIButton) {
    self.delegate?.didTapDeleteButton(sender)
  }
  @objc func addAnotherTownNameToButton() {
    selectedSecondTownLabel.text = MyTownSetting.shared.secondSelectTown
//    deleteSelectedSecondTownButton.isHidden = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
