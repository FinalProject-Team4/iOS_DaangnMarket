//
//  WriteTypeViewController.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class WriteTypeViewController: UIViewController {
  private let selectTypeView = UIView().then {
    $0.backgroundColor = .white
  }

  private let usedMarket = WriteTypeButtonView(
    image: UIImage(systemName: "bag")!,
    title: "중고거래",
    subTitle: "중고 물건을 판매할 수 있어요."
  ).then {
    $0.layer.addBorder(edge: .bottom, color: .red, thickness: 1)
  }
  
  private let townLife = WriteTypeButtonView(
    image: UIImage(systemName: "person.2")!,
    title: "동네생활",
    subTitle: "우리 동네에 관련된 질문이나 이야기를 할 수 있어요."
  ).then {
    $0.layer.addBorder(edge: .bottom, color: .red, thickness: 1)
  }
  
  private let townAD = WriteTypeButtonView(
    image: UIImage(systemName: "cube.box")!,
    title: "동네홍보",
    subTitle: "업체소개, 부동산, 농수산물 등을 올릴 수 있어요."
  ).then {
    $0.layer.addBorder(edge: .bottom, color: .red, thickness: 1)
  }
  
  private let underline = UILabel().then {
    $0.frame = CGRect(x: 0, y: 0, width: 0, height: 1)
    $0.backgroundColor = .red
  }
  
  private var idToken: String
  
  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    UIView.animate(withDuration: 0.2) {
      self.selectTypeView.snp.updateConstraints {
        $0.top.equalTo(self.view.snp.bottom).offset(-(self.selectTypeView.bounds.height))
      }
      self.view.layoutIfNeeded()
    }
  }
  
  override func viewWillLayoutSubviews() {
    [usedMarket, townLife, townAD].forEach {
      $0.layer.addBorder(edge: .bottom, color: UIColor(named: ColorReference.borderLine.rawValue)!, thickness: 1)
    }
  }
  
  // MARK: Initialize
  init(token: String) {
    idToken = token
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    self.navigationController?.navigationBar.isHidden = true
    view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    view.addSubview(selectTypeView)
    [usedMarket, townLife, townAD].forEach {
      selectTypeView.addSubview($0)
      $0.layer.addBorder(edge: .bottom, color: .red, thickness: 1)
    }
  }
  
  private func setupConstraints() {
    selectTypeView.snp.makeConstraints {
      $0.height.equalToSuperview().multipliedBy(0.3).offset(view.safeAreaInsets.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(view.snp.bottom)
    }
    
    [usedMarket, townLife, townAD].forEach {
      $0.snp.makeConstraints {
        $0.leading.trailing.equalToSuperview()
        $0.height.equalToSuperview().offset(view.safeAreaInsets.bottom).multipliedBy(0.3)
      }
    }
    usedMarket.snp.makeConstraints {
      $0.top.equalToSuperview()
    }
    townLife.snp.makeConstraints {
      $0.top.equalTo(usedMarket.snp.bottom)
    }
    townAD.snp.makeConstraints {
      $0.top.equalTo(townLife.snp.bottom)
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touchPoint = touches.first?.location(in: selectTypeView) else { return }
    if usedMarket.frame.contains(touchPoint) {
      self.dismiss(animated: false)
      guard let presentingVC = presentingViewController as? UITabBarController else { return }
      guard let writeUsedVC = ViewControllerGenerator.shared.make(.writeUsed, parameters: ["id_token": idToken]) else { return }
      writeUsedVC.modalPresentationStyle = .fullScreen
      presentingVC.present(writeUsedVC, animated: true)
    } else if townLife.frame.contains(touchPoint) {
      print("동네생활 비활성화")
    } else if townAD.frame.contains(touchPoint) {
      print("동네홍보 비활성화")
    } else {
      dismiss(animated: false, completion: nil)
    }
  }
}
