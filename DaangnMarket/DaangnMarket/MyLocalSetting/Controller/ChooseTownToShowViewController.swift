//
//  ChooseTownToShowViewController.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/07.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ChooseTownToShowViewController: UIViewController {
  // MARK: Propoerty
  let noti = NotificationCenter.default
  
  // MARK: Views
  
  lazy var townAroundView = MyTownAroundView().then {
    $0.backgroundColor = .white
  }
  var naviTitle = UILabel().then {
    $0.text = "게시글 보여줄 동네 고르기"
    $0.font = .systemFont(ofSize: 17, weight: .semibold)
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    //    MyTownSetting.shared.towns["first"] = AuthorizationManager.shared.selectedTown?.dong ?? "unknown"
    setupConstraint()
    setupNaviBar()
    //    saveTownsInfo(MyTownSetting.shared.isFirstTown)
    saveTownsInfo()
  }
  
  // MARK: Initialize
  
  private func setupNaviBar() {
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationItem.titleView = naviTitle
    self.navigationItem.leftBarButtonItem = .init(image: UIImage(systemName: "arrow.left"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(didTapLeftBarButton))
  }
  private func setupConstraint() {
    self.view.addSubview(townAroundView)
    townAroundView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  // MARK: Method
  
  //  private func saveTownsInfo(_ isFirstTowns: Bool) {
  private func saveTownsInfo() {
    let manager = AuthorizationManager.shared
    if let firstTown = manager.firstTown, firstTown.activated {
      self.townAroundView.townCountView.myTownLabel.text = firstTown.locate.dong
      
      // slider 설정
      
      var level = firstTown.distance / 1_200 - 1
      level = level < 0 ? 0 : level
      self.townAroundView.distanceSlider.slider.value = Float(level) // 초기값
      self.townAroundView.changeImageAlpha(level)
      
      // 근처 동네 개수 설정
      let count = manager.firstAroundTown
        .compactMap { $0.distance }
        .filter { $0 <= 1_200 * Double(level + 1) }
        .count
      let townCount = NSMutableAttributedString()
        .underlineBold(
          "근처 동네 \(count)개",
          fontSize: 17
      )
      self.townAroundView
        .townCountView
        .aroundTownCountBtn
        .setAttributedTitle(townCount, for: .normal)
    } else if let secondTown = AuthorizationManager.shared.secondTown, secondTown.activated {
      self.townAroundView.townCountView.myTownLabel.text = secondTown.locate.dong
      
      // slider 설정
      
      var level = secondTown.distance / 1_200 - 1
      level = level < 0 ? 0 : level
      self.townAroundView.distanceSlider.slider.value = Float(level) // 초기값
      self.townAroundView.changeImageAlpha(level)
      
      // 근처 동네 개수 설정
      let count = manager.secondAroundTown
        .compactMap { $0.distance }
        .filter { $0 <= 1_200 * Double(level + 1) }
        .count
      let townCount = NSMutableAttributedString()
        .underlineBold(
          "근처 동네 \(count)개",
          fontSize: 17
      )
      self.townAroundView
        .townCountView
        .aroundTownCountBtn
        .setAttributedTitle(townCount, for: .normal)
    }
    //      MyTownSetting.shared.firstSelectTown = firstTown.locate.dong
    
    
    //    if let firstTown = AuthorizationManager.shared.firstTown {
    //      MyTownSetting.shared.firstSelectTown = firstTown.locate.dong
    //    }
    //    if let secondTown = AuthorizationManager.shared.firstTown {
    //      MyTownSetting.shared.secondSelectTown = secondTown.dong
    ////      noti.post(name: NSNotification.Name("anotherTownSecondTownBtn"), object: nil)
    //    }
    //    postNotificationForDefineAroundTown(isFirstTowns)
  }
  
  //  private func postNotificationForDefineAroundTown(_ isFirstTown: Bool) {
  //    print("first town", MyTownSetting.shared.firstSelectTown)
  //    switch isFirstTown {
  //    case true:
  //      noti.post(name: NSNotification.Name("FirstSelectTownCountView"), object: nil)
  //    case false:
  //      noti.post(name: NSNotification.Name("SecondSelectTownCountView"), object: nil)
  //    }
  //  }
  
  // MARK: Action
  
  @objc private func didTapLeftBarButton() {
    self.navigationController?.popViewController(animated: true)
  }
}

