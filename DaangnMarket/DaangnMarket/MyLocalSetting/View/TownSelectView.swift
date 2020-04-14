//
//  selectTownView.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/03.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
protocol SecondTownButtonDelegate: class {
  func secondTownSelectBtn(_ button: UIButton)
}

class TownSelectView: UIView {
  // MARK: Delegate creation
  
  weak var delegate: SecondTownButtonDelegate?
  
  // MARK: Propoerty
  let noti = NotificationCenter.default
  
  // MARK: Views
  
  private let partitionLineView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.noResultImage.rawValue)
  }
  private let townSelectLabel = UILabel().then {
    $0.text = "동네 선택"
    $0.font = .systemFont(ofSize: 17, weight: .bold)
  }
  private let townSelectDescribeLabel = UILabel().then {
    $0.text = "지역은 최소 1개 이상 최대 2개까지 설정가능해요."
    $0.font = .systemFont(ofSize: 13, weight: .regular)
    $0.textColor = UIColor(named: ColorReference.noResultImage.rawValue)
  }
  var firstTownSelectBtn = FirstTownSelectButton().then {
    $0.layer.cornerRadius = 5
    $0.addTarget(self, action: #selector(didTapSelectTownButton(_:)), for: .touchUpInside)
    $0.backgroundColor = UIColor(named: ColorReference.daangnMain.rawValue)
    }
  var secondTownSelectBtn = SecondTownSelectButton().then {
    $0.addTarget(self, action: #selector(didTapSelectTownButton(_:)), for: .touchUpInside)
    $0.setImage(UIImage(systemName: "plus"), for: .normal)
    $0.tintColor = UIColor(named: ColorReference.noResultImage.rawValue)
    $0.layer.cornerRadius = 5
    $0.layer.borderColor = UIColor(named: ColorReference.noResultImage.rawValue)?.cgColor
    $0.layer.borderWidth = 1
    $0.backgroundColor = .white
  }
  lazy var upperAlert = DGUpperAlert()
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    inViewSetupConstraints()
    hidePlusImageNoti()
  }
  
  deinit {
    noti.removeObserver(
      self,
      name: NSNotification.Name("hidePlusTownSelectView"),
      object: nil
    )
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
    partitionLineView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.width.equalTo(self.snp.width).multipliedBy(0.9)
      $0.height.equalTo(0.5)
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
  }
  
  // MARK: Method
  
  private func changeSelectedTownButton(_ item: UIView) {
    item.backgroundColor = UIColor(named: ColorReference.daangnMain.rawValue)
    item.layer.borderWidth = 1
    item.layer.borderColor = UIColor(named: ColorReference.daangnMain.rawValue)?.cgColor
    if item == firstTownSelectBtn {
      firstTownSelectBtn.selectedFirstTownLabel.textColor = .white
      firstTownSelectBtn.deleteSelectedFirstTownButton.tintColor = .white
    } else if item == secondTownSelectBtn {
      secondTownSelectBtn.selectedSecondTownLabel.textColor = .white
      secondTownSelectBtn.deleteSelectedSecondTownButton.tintColor = .white
    }
  }
  private func changeUnSelectedTownButton(_ item: UIView) {
    item.layer.borderWidth = 1
    item.layer.borderColor = UIColor(named: ColorReference.noResultImage.rawValue)?.cgColor
    item.backgroundColor = .white
    if item == firstTownSelectBtn {
      firstTownSelectBtn.selectedFirstTownLabel.textColor = .black
      firstTownSelectBtn.deleteSelectedFirstTownButton.tintColor = UIColor(named: ColorReference.noResultImage.rawValue)
    } else if item == secondTownSelectBtn {
      secondTownSelectBtn.selectedSecondTownLabel.textColor = .black
      secondTownSelectBtn.deleteSelectedSecondTownButton.tintColor = UIColor(named: ColorReference.noResultImage.rawValue)
    }
  }
  private func hidePlusImageNoti() {
    noti.addObserver(
      self,
      selector: #selector(hidePlusImage),
      name: NSNotification.Name("hidePlusTownSelectView"),
      object: nil
    )
  }
  
  // MARK: Action

  @objc func didTapSelectTownButton(_ sender: UIButton) {
    switch sender {
    case firstTownSelectBtn:
      noti.post(
        name: NSNotification.Name("FirstSelectTownCountView"),
        object: nil
      )
      changeBtnBGColor(firstTownSelectBtn)
      willDisplayUpperAlert(.firstBtn)
    case secondTownSelectBtn:
      if !MyTownSetting.shared.secondSelectTown.isEmpty {
        noti.post(
          name: NSNotification.Name("SecondSelectTownCountView"),
          object: nil
        )
        changeBtnBGColor(secondTownSelectBtn)
        willDisplayUpperAlert(.secondBtn)
      } else {
        self.delegate?.secondTownSelectBtn(sender)
      }
    default: break
    }
  }
  @objc func hidePlusImage() {
    secondTownSelectBtn.setImage(UIImage(), for: .normal)
  }
  func changeBtnBGColor(_ sender: UIButton) {
    switch sender {
    case firstTownSelectBtn:
      changeSelectedTownButton(firstTownSelectBtn)
      changeUnSelectedTownButton(secondTownSelectBtn)
    case secondTownSelectBtn:
      if !MyTownSetting.shared.secondSelectTown.isEmpty {
        changeSelectedTownButton(secondTownSelectBtn)
        changeUnSelectedTownButton(firstTownSelectBtn)
      }
    default: break
    }
  }
  private func willDisplayUpperAlert(_ selectButton: MyTownSetting.UpperAlerCallBtn) {
    switch selectButton {
    case .firstBtn:
      upperAlert.show(message: "\(MyTownSetting.shared.firstSelectTown)으로 설정되었습니다.")
    case .secondBtn:
      upperAlert.show(message: "\(MyTownSetting.shared.secondSelectTown)으로 설정되었습니다.")
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
