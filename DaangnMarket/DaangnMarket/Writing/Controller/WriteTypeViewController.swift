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
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touchPoint = touches.first?.location(in: selectTypeView) else { return }
    if usedMarket.frame.contains(touchPoint) {
      self.dismiss(animated: false)
      guard let presentingVC = presentingViewController as? UITabBarController else { return }
      if let idToken = AuthorizationManager.shared.userInfo?.authorization {
        guard let writeUsedVC = ViewControllerGenerator.shared.make(.writeUsed, parameters: ["id_token": idToken]) else { return }
        writeUsedVC.modalPresentationStyle = .fullScreen
        presentingVC.present(writeUsedVC, animated: true)
      } else {
        let alert = DGAlertController(title: "회원가입 또는 로그인후 이용할 수 있습니다.")
        let signInAction = DGAlertAction(title: "로그인/가입", style: .orange) {
          print("어~디로~가야하죠~아저씨~")
        }
        let cancelAction = DGAlertAction(title: "취소", style: .white) {
          self.dismiss(animated: false)
        }
        [signInAction, cancelAction].forEach { alert.addAction($0) }
        presentingVC.present(alert, animated: true)
      }
    } else if townLife.frame.contains(touchPoint) {
      print("동네생활 비활성화")
    } else if townAD.frame.contains(touchPoint) {
      print("동네홍보 비활성화")
    } else {
      dismiss(animated: false, completion: nil)
    }
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
}
