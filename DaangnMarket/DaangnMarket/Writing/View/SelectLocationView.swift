//
//  SelectLocationView.swift.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/03/26.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol SelectLocationButtonDelegate: class {
  func selectLocationButton(_ selectLocationButton: UIButton)
}

// MARK: - Class Level
class SelectLocationView: UIView {
  // MARK: Views
  weak var delegate: SelectLocationButtonDelegate?
  
  lazy var selectLocationButton = UIButton().then {
    $0.semanticContentAttribute = .forceRightToLeft
    $0.setTitle("게시글 보여줄 동네 고르기", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 14)
    $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
    $0.imageView?.contentMode = .scaleAspectFit
    $0.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    $0.tintColor = .black
    $0.addTarget(self, action: #selector(didTapSelectButton(_:)), for: .touchUpInside)
  }
  
  private lazy var keywordButton = UIButton().then {
    $0.setImage(UIImage(systemName: "doc.text"), for: .normal)
    $0.tintColor = .black
    $0.addTarget(self, action: #selector(didTapKeywordButton(_:)), for: .touchUpInside)
  }
  
  private lazy var keyboardButton = UIButton().then {
    $0.setImage(UIImage(systemName: "keyboard.chevron.compact.down"), for: .normal)
    $0.tintColor = .black
    $0.alpha = 0.0
    $0.addTarget(self, action: #selector(didTapKeyboardButotn(_:)), for: .touchUpInside)
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupNotification()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    self.backgroundColor = .white
    self.addSubview(selectLocationButton)
    self.addSubview(keywordButton)
    self.addSubview(keyboardButton)
  }
  
  private func setupConstraints() {
    selectLocationButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.centerY.equalToSuperview()
    }
    
    keywordButton.snp.makeConstraints {
      $0.centerY.equalTo(selectLocationButton)
      $0.trailing.equalToSuperview().offset(-16)
    }
    
    keyboardButton.snp.makeConstraints {
      $0.centerY.equalTo(selectLocationButton)
      $0.trailing.equalToSuperview().offset(-16)
    }
  }
  
  private func setupNotification() {
    NotificationCenter
      .default
      .addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .keyboardWillShow, object: nil)
  }
  
  // MARK: Action
  
  @objc private func didTapSelectButton(_ button: UIButton) {
    print("게시글 보여줄 동네 고르기")
    self.delegate?.selectLocationButton(button)
  }
  
  @objc private func didTapKeywordButton(_ button: UIButton) {
    print("자주쓰는 문구")
  }
  
  @objc private func didTapKeyboardButotn(_ button: UIButton) {
    self.parentViewController?.view.endEditing(true)
    UIView.animate(withDuration: 0.3) {
      self.keyboardButton.alpha = 0
      self.keywordButton.snp.updateConstraints {
        $0.trailing.equalToSuperview().offset(-16)
      }
      self.updateConstraints()
      self.layoutIfNeeded()
    }
  }
  
  @objc private func keyboardWillShow(_ notification: Notification) {
    buttonAnimaiton()
  }
  
  // MARK: Method
  
  private func buttonAnimaiton() {
    UIView.animate(withDuration: 0.3) {
      self.keyboardButton.alpha = 1
      self.keywordButton.snp.updateConstraints {
        $0.trailing.equalToSuperview().offset(-68)
      }
      self.updateConstraints()
      self.layoutIfNeeded()
    }
  }
}


