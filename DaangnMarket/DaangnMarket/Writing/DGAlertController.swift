//
//  DGAlertController.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/03.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class DGAlertController: UIViewController {
  // MARK: Interface
  func addAction(_ action: DGAlertAction) {
    buttonsView.addArrangedSubview(action)
    action.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(40)
    }
  }
  
  private let alertView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 10
  }
  
  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 17)
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  private let contentView = UIView().then {
    $0.backgroundColor = .white
  }
  
  private let buttonsView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
    $0.alignment = .center
    $0.distribution = .fillEqually
  }
  
  init(title: String) {
    super.init(nibName: nil, bundle: nil)
    setUI()
    setTitleLabel(title)
  }
  
  convenience init(title: String, view: UIView) {
    self.init(title: title)
    setAddView(newView: view)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setTitleLabel(_ title: String) {
    titleLabel.text = title
    alertView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().offset(-24)
      $0.bottom.equalTo(buttonsView.snp.top).offset(-24)
    }
    let attrString = NSMutableAttributedString(string: title)
    let paragraphStyle = NSMutableParagraphStyle().then {
      $0.lineSpacing = 6
      $0.alignment = .center
    }
    attrString.addAttribute(
      NSAttributedString.Key.paragraphStyle,
      value: paragraphStyle,
      range: NSMakeRange(0, attrString.length)
    )
    titleLabel.attributedText = attrString
  }
  
  private func setAddView(newView: UIView) {
    titleLabel.snp.removeConstraints()
    titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.leading.equalToSuperview().offset(24)
      $0.trailing.equalToSuperview().offset(-24)
    }
    alertView.addSubview(newView)
    newView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
      $0.bottom.equalTo(buttonsView.snp.top).offset(-20)
      $0.leading.trailing.equalTo(titleLabel)
      $0.height.equalTo(120)
    }
  }
  
  private func setUI() {
//    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapViewGesture(_:)))
//    self.view.addGestureRecognizer(tapGesture)
    self.modalPresentationStyle = .overFullScreen
    view.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
    view.addSubview(alertView)
    alertView.snp.makeConstraints {
      $0.width.equalToSuperview().multipliedBy(0.85)
      $0.center.equalToSuperview()
    }
    alertView.addSubview(buttonsView)
    buttonsView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(24)
      $0.bottom.trailing.equalToSuperview().offset(-24)
    }
  }
  
  @objc private func tapViewGesture(_ sender: UITapGestureRecognizer) {
    if !alertView.point(inside: sender.location(in: alertView), with: nil) {
      self.dismiss(animated: false, completion: nil)
    }
  }
}
