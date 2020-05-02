//
//  DGAlertAction.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/03.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

extension DGAlertAction {
  enum Style {
    case orange, white, cancel
  }
}

class DGAlertAction: UIButton {
  private var handler: (() -> Void)?
  
  init(title: String, style: DGAlertAction.Style, handler: (() -> Void)? = nil) {
    super.init(frame: .zero)
    setupBasic(title)
    switch style {
    case .orange:
      setupOrange()
    case .white:
      setupWhite()
    case .cancel:
      setupCancel()
    }
    self.handler = handler
    self.addTarget(self, action: #selector(handlerAction), for: .touchUpInside)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    UIView.animate(withDuration: 0.3) {
      self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    UIView.animate(withDuration: 0.3) {
      self.transform = .identity
    }
  }
  
  @objc func handlerAction() {
//    guard let handler = self.handler else { return }
//    handler()
//    guard let superView = self.superview else { return }
//    superView.parentViewController?.dismiss(animated: false, completion: nil)
    
    // Optional Chaining : Optional type의 변수 및 함수 호출 시 ?. 으로 이어가면
    // closure 및 변수가 nil인 경우 ?에서 실행이 중지되어 끝나고, nil이 아니면 . 다음으로 넘어감
    self.superview?.parentViewController?.dismiss(animated: false) {
      self.handler?()
    }
  }
  
  private func setupOrange() {
    self.backgroundColor = .orange
    self.setTitleColor(.white, for: .normal)
  }
  
  private func setupWhite() {
    self.backgroundColor = .white
    self.setTitleColor(.black, for: .normal)
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.borderWidth = 1
  }
  
  private func setupCancel() {
    self.backgroundColor = .white
    self.setTitleColor(.black, for: .normal)
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.borderWidth = 1
    self.addTarget(self, action: #selector(didTapCancel(_:)), for: .touchUpInside)
  }
  
  @objc func didTapCancel(_ button: UIButton) {
    print("didTap")
    guard let superView = self.superview else { return }
    superView.parentViewController?.dismiss(animated: false, completion: nil)
  }
  
  private func setupBasic(_ title: String) {
    self.layer.cornerRadius = 4
    self.setTitle(title, for: .normal)
    self.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
  }
}
