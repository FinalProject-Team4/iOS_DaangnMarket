//
//  SecurityNoteView.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/31.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class AuthDescriptionView: UIView {
  // MARK: Views
  
  private let imageView = UIImageView(named: ImageReference.daangnAuth.rawValue).then {
    $0.contentMode = .scaleAspectFit
  }
  private let authDescription = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .leading
    $0.distribution = .fillProportionally
    $0.spacing = 5
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    self.imageView
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.bottom.equalToSuperview()
        $0.size.equalTo(CGSize(width: 95, height: 81))
    }
    
    self.authDescription
      .then { description in
        self.addSubview(description)
        
        UILabel().do {
          $0.text = "당근마켓은 휴대폰 번호로 가입해요."
          $0.font = .systemFont(ofSize: 15)
          description.addArrangedSubview($0)
        }
        
        UILabel().do {
          $0.attributedText = NSMutableAttributedString()
            .normal("번호는 ", fontSize: 15)
            .bold("안전하게 보관 ", fontSize: 15)
            .normal("되며", fontSize: 15)
          description.addArrangedSubview($0)
        }
        
        UILabel().do {
          $0.text = "어디에도 공개되지 않아요."
          $0.font = .systemFont(ofSize: 15)
          description.addArrangedSubview($0)
        }
      }.snp.makeConstraints {
        $0.leading
          .equalTo(self.imageView.snp.trailing)
          .offset(16)
        $0.centerY.equalTo(self.imageView)
      }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  } 
}
