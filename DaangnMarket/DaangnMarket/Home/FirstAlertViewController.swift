//
//  FirstAlertViewController.swift
//  DaangnMarket
//
//  Created by Demian on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import Then
import SnapKit

class FirstAlertViewController: UIViewController {
  static let orangeish = UIColor(red: 254.0 / 255.0, green: 138.0 / 255.0, blue: 61.0 / 255.0, alpha: 1.0)
  static let lightBlueGrey = UIColor(red: 206.0 / 255.0, green: 212.0 / 255.0, blue: 217.0 / 255.0, alpha: 1.0)
  private let beggingView = UIView().then {
    $0.backgroundColor = .white
  }
  private let mascotImage = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(named: "DanggnMascot")
  }
  private let startViewLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.text = "가입하고 군자동/n 중고 상품을 구경하세요!"
    $0.contentMode = .center
    $0.font = .systemFont(ofSize: 20, weight: .bold)
  }
  private let signUpAndWatchButton = UIButton().then {
    $0.setTitle("가입하고 구경하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = orangeish
    $0.layer.borderColor = orangeish.cgColor
    $0.layer.borderWidth = 2
    $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
  }
  private let signUpButton = UIButton().then {
    $0.setTitle("로그인하기", for: .normal)
    $0.setTitleColor(orangeish, for: .normal)
    $0.backgroundColor = .white
    $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
  }
  private let lookAroundButton = UIButton().then {
    $0.setTitle("둘러보기", for: .normal)
    $0.setTitleColor(lightBlueGrey, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 13)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    setupUI()
  }
  
  private func setupUI() {
  }
  
  private func didTapButtonsAction(_ sender: UIButton) {
    if (sender == signUpAndWatchButton) || (sender == signUpButton) {
      print("Go to SignUp Page")
    } else {
      dismiss(animated: true)
    }
  }
}
