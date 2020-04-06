//
//  FirstAlertViewController.swift
//  DaangnMarket
//
//  Created by Demian on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class FirstAlertViewController: UIViewController {
  static let orangeish = UIColor(red: 254.0 / 255.0, green: 138.0 / 255.0, blue: 61.0 / 255.0, alpha: 1.0)
  static let lightBlueGrey = UIColor(red: 206.0 / 255.0, green: 212.0 / 255.0, blue: 217.0 / 255.0, alpha: 1.0)
  private let firsAlertView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 10
  }
  private let mascotImage = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(named: "DaanggnMascot")
  }
  private let startViewTopLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.text = "가입하고 군자동"
    $0.contentMode = .center
    $0.font = .systemFont(ofSize: 20, weight: .bold)
  }
  private let startViewBottomLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.text = "중고 상품을 구경하세요!"
    $0.contentMode = .center
    $0.font = .systemFont(ofSize: 20, weight: .bold)
  }
  private let signUpAndWatchButton = UIButton().then {
    $0.setTitle("가입하고 구경하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = UIColor(named: "symbolColor")
    $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
    $0.layer.cornerRadius = 5.0
    $0.addTarget(self, action: #selector(didTapButtonsAction(_:)), for: .touchUpInside)
  }
  private let signUpButton = UIButton().then {
    $0.setTitle("로그인하기", for: .normal)
    $0.setTitleColor(UIColor(named: "symbolColor"), for: .normal)
    $0.backgroundColor = .white
    $0.layer.borderWidth = 2.0
    $0.layer.borderColor = orangeish.cgColor
    $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
    $0.layer.cornerRadius = 5.0
    $0.addTarget(self, action: #selector(didTapButtonsAction(_:)), for: .touchUpInside)
  }
  private let lookAroundButton = UIButton().then {
    $0.setTitle("둘러보기", for: .normal)
    $0.setTitleColor(lightBlueGrey, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 15)
    $0.addTarget(self, action: #selector(didTapButtonsAction(_:)), for: .touchUpInside)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    dummyData()
    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    setupUI()
  }
  
  private func setupUI() {
    let viewElements = [mascotImage, startViewTopLabel, startViewBottomLabel, signUpAndWatchButton, signUpButton, lookAroundButton]
    self.view.addSubview(firsAlertView)
    viewElements.forEach { firsAlertView.addSubview($0) }
    setupConstrains()
  }
  
  private func setupConstrains() {
    firsAlertView.snp.makeConstraints {
      $0.center.equalTo(self.view)
      $0.width.equalTo(314)
      $0.height.equalTo(445)
    }
    mascotImage.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(lookAroundButton.snp.bottom)
      $0.width.equalTo(self.view.bounds.width * 0.5)
      $0.height.equalTo(self.view.bounds.width * 0.5)
    }
    startViewTopLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(mascotImage.snp.bottom).offset(20)
    }
    startViewBottomLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(startViewTopLabel.snp.bottom).offset(3)
    }
    signUpAndWatchButton.snp.makeConstraints {
      $0.top.equalTo(startViewBottomLabel.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().offset(-24)
      $0.height.equalToSuperview().multipliedBy(0.1)
    }
    signUpButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(signUpAndWatchButton.snp.bottom).offset(15)
      $0.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().offset(-24)
      $0.height.equalToSuperview().multipliedBy(0.1)
    }
    lookAroundButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.trailing.equalToSuperview().offset(-16)
    }
  }
  
  private var homeVC: UIViewController?
  
  @objc private func didTapButtonsAction(_ sender: UIButton) {
    if sender == lookAroundButton {
      dismiss(animated: false)
    } else {
      self.homeVC = self.presentingViewController
      self.dismiss(animated: true) {
        guard let phoneAuthVC = ViewControllerGenerator.shared.make(.phoneAuth) else { return }
        phoneAuthVC.modalPresentationStyle = .fullScreen
        self.homeVC?.present(phoneAuthVC, animated: true)
      }
    }
  }
}
