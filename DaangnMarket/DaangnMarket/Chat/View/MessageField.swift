//
//  MessageField.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/21.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class MessageField: UIView {
  // MARK: Views
  
  private lazy var moreButton = UIButton().then {
    $0.setBackgroundImage(UIImage(named: ImageReference.Chatting.more.rawValue), for: .normal)
    $0.addTarget(self, action: #selector(didTapMoreButton(_:)), for: .touchUpInside)
    $0.tintColor = .blue
  }
  private let messageInputArea = UIView().then {
    $0.layer.cornerRadius = 16
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor(named: ColorReference.borderLine.rawValue)?.cgColor
    $0.backgroundColor = .white
  }
  private lazy var messageInputField = UITextView().then {
    $0.font = .systemFont(ofSize: 15)
    $0.delegate = self
    $0.isScrollEnabled = false
    $0.textContainerInset = .zero
    $0.textContainer.lineFragmentPadding = 0
    $0.backgroundColor = .white
  }
  private lazy var emoticonButton = UIButton().then {
    $0.setBackgroundImage(UIImage(named: ImageReference.Chatting.emoticon.rawValue), for: .normal)
    $0.addTarget(self, action: #selector(didTapEmoticonButton(_:)), for: .touchUpInside)
  }
  private lazy var sendButton = UIButton().then {
    $0.titleLabel?.font = .systemFont(ofSize: 20)
    $0.isEnabled = false
    $0.setBackgroundImage(UIImage(named: ImageReference.Chatting.enabledSend.rawValue), for: .normal)
    $0.setBackgroundImage(UIImage(named: ImageReference.Chatting.disabledSend.rawValue), for: .disabled)
    $0.addTarget(self, action: #selector(didTapSendButton(_:)), for: .touchUpInside)
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor(named: ColorReference.Chatting.inputFieldBackground.rawValue)
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    let padding: (x: CGFloat, y: CGFloat) = (12, 6)
    
    self.moreButton
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading
          .equalToSuperview()
          .offset(padding.x)
        $0.bottom
          .equalToSuperview()
          .offset(-14)
        $0.size.equalTo(22)
    }
    
    self.setupInputFieldConstraints()
    
    self.sendButton
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading
          .equalTo(self.messageInputArea.snp.trailing)
          .offset(padding.x)
        $0.trailing.equalToSuperview()
          .offset(-padding.x)
        $0.bottom
          .equalToSuperview()
          .offset(-14)
        $0.size.equalTo(22)
    }
  }
  
  private func setupInputFieldConstraints() {
    let padding: (x: CGFloat, y: CGFloat) = (12, 6)
    
    self.messageInputArea
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.bottom
          .equalToSuperview()
          .inset(padding.y)
        $0.leading
          .equalTo(self.moreButton.snp.trailing)
          .offset(padding.x)
        $0.height.equalTo(36)
    }
    
    self.messageInputField
      .then { self.messageInputArea.addSubview($0) }
      .snp.makeConstraints {
        $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
    }
    
    self.emoticonButton
      .then { self.messageInputArea.addSubview($0) }
      .snp.makeConstraints {
        $0.centerY.equalTo(self.moreButton)
        $0.trailing.equalToSuperview().offset(-8)
        $0.width.equalTo(20)
        $0.height.equalTo(self.emoticonButton.snp.width)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Actions
  
  @objc private func didTapSendButton(_ sender: UIButton) {
    print(#function)
  }
  
  @objc private func didTapMoreButton(_ sender: UIButton) {
    print(#function)
  }
  
  @objc private func didTapEmoticonButton(_ sender: UIButton) {
    print(#function)
  }
  
  // MARK: Draws
  
  override func draw(_ rect: CGRect) {
    UIBezierPath().do {
      $0.lineWidth = 1
      $0.move(to: CGPoint(x: rect.minX, y: 0))
      $0.addLine(to: CGPoint(x: rect.maxX, y: 0))
      $0.close()
      UIColor(named: ColorReference.borderLine.rawValue)?.setStroke()
      $0.stroke()
    }
  }
}

// MARK: - UITextViewDelegate

extension MessageField: UITextViewDelegate {
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    UIView.setAnimationsEnabled(false)
    return true
  }
  
  func textViewDidChange(_ textView: UITextView) {
    // Update text view height
    var height = textView.sizeThatFits(textView.frame.size).height + 16
    height = height < 36 ? 36 : height
    self.messageInputArea.snp.updateConstraints {
      $0.height.equalTo(height)
    }
    
    // Update send button state
    self.sendButton.isEnabled = !textView.text.isEmpty
  }
}
