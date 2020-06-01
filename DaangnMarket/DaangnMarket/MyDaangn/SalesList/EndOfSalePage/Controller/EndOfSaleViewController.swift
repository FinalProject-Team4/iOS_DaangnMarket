//
//  EndOfSaleViewController.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class EndOfSaleViewController: UIViewController {  
  // MARK: Views
  
  private let firstBackView = BackView().then {
    $0.backgroundColor = .white
  }
  private let checkMark = UIButton().then {
    $0.setImage(UIImage(systemName: "checkmark"), for: .normal)
    $0.backgroundColor = UIColor(named: ColorReference.daangnMain.rawValue)
    $0.tintColor = .white
    $0.layer.cornerRadius = 25
    $0.clipsToBounds = true
  }
  private let dealOverMsgLabel = UILabel().then {
    $0.text = "거래가 완료되었습니당."
    $0.font = UIFont.boldSystemFont(ofSize: 17)
  }
  private let choosePurchaserLabel = UILabel().then {
    $0.text = "구매자를 선택해주세요."
    $0.font = UIFont.systemFont(ofSize: 17)
  }
  
  private let secondBackView = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.backGray.rawValue)
  }
  private let dealingItemLabel = UILabel().then {
    $0.text = "거래한 상품"
    $0.textColor = .lightGray
    $0.font = UIFont.systemFont(ofSize: 13)
  }
  private let titleLabel = UILabel().then {
    $0.text = "니트"
    $0.textColor = .black
    $0.font = UIFont.systemFont(ofSize: 15)
  }
  
  private let thirdBackView = UIView().then {
    $0.backgroundColor = .white
  }
  private let noPerchaserInListLabel = UILabel().then {
    $0.text = "목록에 구매자가 없으신가요?"
    $0.textColor = .black
    $0.font = UIFont.systemFont(ofSize: 15)
  }
  private let findPerchaserButton = UIButton().then {
    $0.setTitle("최근 채팅 목록에서 구매자 찾기", for: .normal)
    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    $0.setTitleColor(.black, for: .normal)
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = 3
    $0.layer.borderColor = UIColor(named: ColorReference.borderLine.rawValue)?.cgColor
  }
  
  private let notNowButton = UIButton().then {
    $0.setTitle("지금 안할래요", for: .normal)
    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    $0.setTitleColor(UIColor(named: ColorReference.subText.rawValue), for: .normal)
    $0.backgroundColor = UIColor(named: ColorReference.backGray.rawValue)
  }
  
  // MARK: Life Cycle
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.hidesBottomBarWhenPushed = true
     self.tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.hidesBottomBarWhenPushed = false
    self.tabBarController?.tabBar.isHidden = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: Initialize
  
  init(title: String) {
     super.init(nibName: nil, bundle: nil)
     self.titleLabel.text = title
   }
   
   required init?(coder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
   }
  
  private func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    view.backgroundColor = .white
    setupNavigationBar()
    self.notNowButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
  }
  
  private func setupNavigationBar() {
    title = "구매자 선택"
    let backImage = UIImage(systemName: "arrow.left")!.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0))
    navigationController?.navigationBar.backIndicatorImage = backImage
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
    self.navigationController?.navigationBar.backgroundColor = .white
    self.navigationController?.navigationBar.isTranslucent = false
    self.navigationController?.navigationBar.tintColor = .black
    navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  private func setupConstraints() {
    let guide = view.safeAreaLayoutGuide
    let spacing: CGFloat = 36
    let markSize: CGFloat = 50
    
    self.firstBackView.then { view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.trailing.equalTo(guide)
    }
    self.checkMark.then { firstBackView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(firstBackView).offset(spacing)
        $0.centerX.equalTo(firstBackView)
        $0.width.height.equalTo(markSize)
    }
    
    self.dealOverMsgLabel.then { firstBackView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(checkMark.snp.bottom).offset(spacing)
        $0.centerX.equalTo(firstBackView)
    }
    
    self.choosePurchaserLabel.then { firstBackView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(dealOverMsgLabel.snp.bottom)
        $0.centerX.equalTo(firstBackView)
        $0.bottom.equalTo(firstBackView).offset(-spacing)
    }
    
    self.secondBackView.then { view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(firstBackView.snp.bottom)
        $0.leading.trailing.equalTo(guide)
    }
    
    self.dealingItemLabel.then { secondBackView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(secondBackView).offset(20)
        $0.leading.equalTo(secondBackView).offset(16)
    }
    
    self.titleLabel.then { secondBackView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(dealingItemLabel.snp.bottom).offset(8)
        $0.leading.equalTo(dealingItemLabel)
        $0.bottom.equalTo(secondBackView).offset(-20)
    }
    
    self.thirdBackView.then { view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(secondBackView.snp.bottom)
        $0.leading.trailing.bottom.equalTo(guide)
    }
    
    self.noPerchaserInListLabel.then { thirdBackView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(thirdBackView).offset(spacing)
        $0.centerX.equalTo(thirdBackView)
    }
    
    self.findPerchaserButton.then { thirdBackView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(noPerchaserInListLabel.snp.bottom).offset(20)
        $0.centerX.equalTo(thirdBackView)
        $0.width.equalTo(224)
        $0.height.equalTo(40)
    }
    
    self.notNowButton.then { view.addSubview($0) }
      .snp.makeConstraints {
        $0.bottom.leading.equalTo(guide)
        $0.width.equalTo(view.frame.width)
        $0.height.equalTo(56)
    }
  }
  
  // MARK: Action
  
  @objc func didTapButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}
