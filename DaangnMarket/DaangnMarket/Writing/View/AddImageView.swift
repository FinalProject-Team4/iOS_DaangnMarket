//
//  AddImageView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/03/25.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol AddImageViewDelegate: class {
  func presentAlert(alert: UIAlertController)
  func openAlbum()
  func openCamera()
}

// MARK: - Class Level
class AddImageView: UIView {
  weak var delegate: AddImageViewDelegate?
  
  // MARK: Views
  
  private var cameraLabelView = UIView().then {
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray.cgColor
    $0.layer.cornerRadius = 4
  }
  
  private let cameraImageView = UIImageView().then {
    $0.image = UIImage(systemName: "camera.fill")
    $0.tintColor = .gray
  }
  
  private lazy var countLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12)
    $0.text = "\(imageCount)/10"
    $0.textColor = .gray
    $0.textAlignment = .center
  }
  
  // MARK: Properties
  
  var imageCount = 0 {
    didSet {
      countLabel.text = "\(self.imageCount)/10"
      if self.imageCount != 0 {
        countLabel.attributedText = NSMutableAttributedString()
          .normal("\(self.imageCount)", textColor: UIColor(named: ColorReference.daangnMain.rawValue), fontSize: 12)
          .normal("/10", fontSize: 12)
      }
    }
  }
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  init(count: Int) {
    self.init()
    imageCount = count
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    self.isExclusiveTouch = true
    self.isUserInteractionEnabled = true
    self.backgroundColor = .white
    self.addSubview(cameraLabelView)
    cameraLabelView.addSubview(cameraImageView)
    cameraLabelView.addSubview(countLabel)
  }
  
  private func setupConstraints() {
    cameraLabelView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 8))
      $0.width.equalTo(cameraLabelView.snp.height)
    }
    
    cameraImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.centerX.equalToSuperview()
    }
    
    countLabel.snp.makeConstraints {
      $0.top.equalTo(cameraImageView.snp.bottom).offset(8)
      $0.bottom.equalToSuperview().offset(-12)
      $0.centerX.equalToSuperview()
    }
  }
  
  // MARK: Methods
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if imageCount < 10 {
      delegate?.presentAlert(alert: albumAlert())
    } else {
      fullImagesAlert()
    }
  }
  
  private func fullImagesAlert() {
    let countAlert = UIAlertController(title: "알림", message: "최대 이미지 첨부 갯수는 10개 입니당.", preferredStyle: .alert)
    let closeAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
    countAlert.addAction(closeAction)
    guard let parentVC = self.parentViewController as? WriteUsedViewController else {
      print("not found parentViewController")
      return
    }
    parentVC.presentAlert(alert: countAlert)
  }
  
  private func albumAlert() -> UIAlertController {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let albumAction = UIAlertAction(title: "앨범에서 선택", style: .default) { _ in
      self.delegate?.openAlbum()
    }
    let camerAction = UIAlertAction(title: "카메라 촬영", style: .default) { _ in
      self.delegate?.openCamera()
    }
    let closeAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
    [albumAction, camerAction, closeAction].forEach {
      alert.addAction($0)
    }
    return alert
  }
}
