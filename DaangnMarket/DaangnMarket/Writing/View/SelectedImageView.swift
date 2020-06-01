//
//  SelectedImageView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/01.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol  SelectedImageViewDelegate: class {
  func deleteImage(_ view: UIView)
}

// MARK: - Class Level
class SelectedImageView: UIView {
  weak var delegate: SelectedImageViewDelegate?
  
  // MARK: Initialize
  
  init(image: UIImage, button: Bool) {
    super.init(frame: .zero)
    makeImageView(image)
    makeButton(button)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Actions
  
  @objc private func didTabXbutton(_ button: UIButton) {
    delegate?.deleteImage(self)
  }
  
  // MARK: Methods
  
  private func makeImageView(_ image: UIImage) {
    UIImageView().then {
      $0.image = image
      $0.layer.cornerRadius = 4
      $0.contentMode = .scaleAspectFill
      $0.clipsToBounds = true
      self.addSubview($0)
    }.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 8))
    }
  }
  
  private func makeButton(_ button: Bool) {
    guard button == true else { return }
    UIButton().then {
      $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
      $0.tintColor = .black
      $0.alpha = 0.8
      $0.addTarget(self, action: #selector(didTabXbutton(_:)), for: .touchUpInside)
      self.addSubview($0)
    }.snp.makeConstraints {
      $0.top.trailing.equalToSuperview()
      $0.size.equalToSuperview().multipliedBy(0.3)
    }
  }
}
