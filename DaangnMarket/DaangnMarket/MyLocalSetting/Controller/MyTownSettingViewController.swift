//
//  MyTownSettingViewController.swift
//  DaangnMarket
//
//  Created by Demian on 2020/04/03.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class MyTownSettingViewController: UIViewController {
  // MARK: Property
  
  let manager = AuthorizationManager.shared
//  let noti = NotificationCenter.default
  weak var showDelegate: ShowAroundTownsNameDelegate?
  weak var deleteDelegate: DeleteButtonDelegate?
  
  // MARK: Views
  
  var townSelectView = TownSelectView().then {
    $0.backgroundColor = .white
  }
  var townAroundView = MyTownAroundView().then {
    $0.backgroundColor = .white
  }
  var naviTitle = UILabel().then {
    $0.text = "내 동네 설정하기"
    $0.font = .systemFont(ofSize: 17, weight: .semibold)
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    callDelegate()
    setupConstraint()
    setupNaviBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //    MyTownSetting.shared.register(townInfo: AuthorizationManager.shared.aroundTown)
//    saveTownsInfo(MyTownSetting.shared.isFirstTown)
    setupTowns()
    willDisappearAboutSeoncondTownBtn(manager.secondTown == nil)
//    willDisappearAboutSeoncondTownBtn(MyTownSetting.shared.secondSelectTown.isEmpty)
  }
  
//  private func setupSelectTownForm() {
//    let manager = AuthorizationManager.shared
//    
//    if let firstTown = manager.firstTown, firstTown.activated {
//      // UI Setting
//      self.townSelectView.firstTownSelectBtn.isSelected = true
//      self.townSelectView.secondTownSelectBtn.isSelected = false
//      self.townSelectView.setupFirstTown()
//    }
//    
//    if let secondTown = manager.secondTown, secondTown.activated {
//      self.townSelectView.firstTownSelectBtn.isSelected = false
//      self.townSelectView.secondTownSelectBtn.isSelected = true
//      self.townSelectView.setupSecondTown()
//    }
//  }
  
  private func callDelegate() {
    townSelectView.delegate = self
    townAroundView.townCountView.delegate = self
    townSelectView.firstTownSelectBtn.delegate = self
    townSelectView.secondTownSelectBtn.delegate = self
  }
  
  // MARK: Initialize
  
  private func setupNaviBar() {
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationItem.titleView = naviTitle
    self.navigationItem.leftBarButtonItem = .init(image: UIImage(systemName: "multiply"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(didTapLeftBarButton))
  }
  private func setupConstraint() {
    [townSelectView, townAroundView].forEach { self.view.addSubview($0) }
    townSelectView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      $0.height.equalTo(160)
    }
    townAroundView.snp.makeConstraints {
      $0.top.equalTo(townSelectView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-128)
    }
  }
  
//  private func showAroundTownsDistance(_ isFirstTown: Bool) {
//    switch isFirstTown {
//    case trucalculateNumberOfAourndTowne:
//      if MyTownSetting.shared.firstAroundTownList.isEmpty {
//        MyTownSettingViewController.calculateNumberOfAourndTown(isFirstTown, 1.0)
//      } else {
//        MyTownSettingViewController.calculateNumberOfAourndTown(isFirstTown, Float(MyTownSetting.shared.numberOfAroundTownByFirst.1))
//      }
//    case false:
//      if MyTownSetting.shared.secondAroundTownList.isEmpty {
//        MyTownSettingViewController.calculateNumberOfAourndTown(isFirstTown, 1.0)
//      } else {
//        MyTownSettingViewController.calculateNumberOfAourndTown(isFirstTown, Float(MyTownSetting.shared.numberOfAroundTownBySecond.1))
//      }
//    }
//  }
  
  // MARK: Method
  
  private func willDisappearAboutSeoncondTownBtn(_ isEmpty: Bool) {
    townSelectView.secondTownSelectBtn.isHidden = isEmpty
    townSelectView.addTownBtn.isHidden = !isEmpty
//    switch isEmpty {
//    case true:
//      townSelectView.secondTownSelectBtn.isHidden = true
//      townSelectView.secondTownSetBtn.isHidden = false
//    case false:
//      townSelectView.secondTownSelectBtn.isHidden = false
//      townSelectView.secondTownSetBtn.isHidden = true
//    }
  }
  
//  private func saveTownsInfo(_ isFirstTowns: Bool) {
  
  private func setupTowns() {
    if let firstTown = manager.firstTown {
      setupFirstTown(firstTown)
    }
    
    if let secondTown = manager.secondTown {
      setupSecondTown(secondTown)
    }
//    postNotificationForDefineMyTown(isFirstTowns)
  }
  
  private func setupFirstTown(_ firstTown: UserTown) {
    self.townSelectView.firstTownSelectBtn.selectedFirstTownLabel.text = firstTown.locate.dong
    if firstTown.activated {
      self.townSelectView.firstTownSelectBtn.isSelected = true
      self.townSelectView.secondTownSelectBtn.isSelected = false
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
      
      setupSelectedTownBGColor(true)
    }
  }
  
  private func setupSecondTown(_ secondTown: UserTown) {
    self.townSelectView.secondTownSelectBtn.selectedSecondTownLabel.text = secondTown.locate.dong
    if secondTown.activated {
      self.townSelectView.firstTownSelectBtn.isSelected = false
      self.townSelectView.secondTownSelectBtn.isSelected = true
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
      
      setupSelectedTownBGColor(false)
    }
    //      MyTownSetting.shared.secondSelectTown = secondTown.locate.dong
    //      noti.post(name: NSNotification.Name("anotherTownSecondTownBtn"), object: nil)
  }
  
//  private func postNotificationForDefineMyTown(_ isFirstTowns: Bool) {
//    switch isFirstTowns {
//    case true:
//      noti.post(name: NSNotification.Name("FirstSelectTownCountView"), object: nil)
//    case false:
//      noti.post(name: NSNotification.Name("SecondSelectTownCountView"), object: nil)
//    }
//    setupSelectedTownBGColor(isFirstTowns)
//  }
  
  private func setupSelectedTownBGColor(_ isFirstTowns: Bool) {
    switch isFirstTowns {
    case true:
      townSelectView.changeBtnColor(townSelectView.firstTownSelectBtn)
    case false:
      townSelectView.changeBtnColor(townSelectView.secondTownSelectBtn)
    }
  }
  
  private func willDisplayDeleteAlert(_ numberOfTownsSet: MyTownSetting.DeleteTown, _ sender: UIButton? = nil) {
    switch numberOfTownsSet {
    case .oneTown:
      let title = "동네가 1개만 선택된 상태에서는 삭제를 할 수 없습니당. 현재 설정된 동네를 변경하시겠어요?"
      let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
      let changeAction = UIAlertAction(title: "변경", style: .default) { _ in
        self.didDeleteTownAction(.oneTown, sender)
      }
      let cancelAction = UIAlertAction(title: "취소", style: .default)
      alertController.addAction(cancelAction)
      alertController.addAction(changeAction)
      self.present(alertController, animated: false, completion: nil)
    case .twoTown:
      let title = "선택한 지역을 삭제하시겠습니까?"
      let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
      let changeAction = UIAlertAction(title: "확인", style: .default) { _ in
        self.didDeleteTownAction(.twoTown, sender)
      }
      let cancelAction = UIAlertAction(title: "취소", style: .default)
      alertController.addAction(cancelAction)
      alertController.addAction(changeAction)
      self.present(alertController, animated: false, completion: nil)
    }
  }
  
  private func didDeleteTownAction(_ numberOfTown: MyTownSetting.DeleteTown, _ sender: UIButton? = nil) {
    switch numberOfTown {
    case .oneTown:
      manager.do {
        $0.firstTown = nil
        $0.secondTown = nil
      }
      let findVC = FindMyTownViewController()
      self.navigationController?.pushViewController(findVC, animated: true)
      self.townSelectView.setupAroundViewFirstTown()
      self.townSelectView.firstTownSelectBtn.isSelected = true
      
    case .twoTown:
      guard let sender = sender else { return }
      deleteTownReset(sender)
      resetAddTownButton()
    }
  }
  
  private func deleteTownReset(_ sender: UIButton) {
    let firstTownDeleteBtn = self
      .townSelectView
      .firstTownSelectBtn
      .deleteSelectedFirstTownButton

    if sender == firstTownDeleteBtn {
      self.resetFirstTownSetting()
      if let firstTown = manager.firstTown {
        setupFirstTown(firstTown)
      }
    } else {
      manager.removeTown(forKey: .secondTown)
      self.townSelectView.firstTownSelectBtn.isSelected = true
    }
    self.townSelectView.setupAroundViewFirstTown()
  }
  
  private func resetAddTownButton() {
    self.townSelectView.secondTownSelectBtn.isHidden = true
    self.townSelectView.addTownBtn.isHidden = false
  }
  
  private func resetFirstTownSetting() {
    UserDefaults.standard.remove(forKey: .firstTown)
    manager.firstTown = manager.secondTown
    manager.firstAroundTown = manager.secondAroundTown
    UserDefaults.standard.remove(forKey: .secondTown)
  }
  
//  static func calculateNumberOfAourndTown(_ isFirstTown: Bool, _ distanceValue: Float) {
//    defer {
//      NotificationCenter.default.post(
//        name: NSNotification.Name("AroundTownCountView"),
//        object: nil,
//        userInfo: [
//          "SingleTon": MyTownSetting.shared
//        ]
//      )
//    }
//    switch isFirstTown {
//    case true:
//      guard let firstTownByDistance = MyTownSetting.shared.firstTownByDistance else { return }
//      let firstAroundTownCount = firstTownByDistance.filter {
//        Float($0.distance!/1_200) <= (distanceValue.rounded() + 1)
//      }
//      MyTownSetting.shared.firstAroundTownList = firstAroundTownCount
//      MyTownSetting.shared.numberOfAroundTownByFirst = (firstAroundTownCount.count, Int(distanceValue))
//    case false:
//      guard let secondTownByDistance = MyTownSetting.shared.secondTownByDistance else { return }
//      let secondAroundTownCount = secondTownByDistance.filter {
//        Float($0.distance!/1_200) <= (distanceValue.rounded() + 1)
//      }
//      MyTownSetting.shared.secondAroundTownList = secondAroundTownCount
//      MyTownSetting.shared.numberOfAroundTownBySecond = (secondAroundTownCount.count, Int(distanceValue))
//    }
//    var temp = MyTownSetting.shared.firstAroundTownList
//  }
  
  // MARK: Action
  
  @objc private func didTapLeftBarButton() {
    dismiss(animated: true)
  }
}

// MARK: - SecondTownSelectButton Delegate
extension MyTownSettingViewController: SecondTownButtonDelegate {
  func secondTownSetBtn(_ secondButton: UIButton) {
    // Second가 설정되지 않았을 때
    let findTownVC = FindMyTownViewController()
    self.navigationController?.pushViewController(findTownVC, animated: true)
//    MyTownSetting.shared.register(isFirstTown: false)
  }
}

// MARK: - ShowAroundTownsName ViewController Delegte
extension MyTownSettingViewController: ShowAroundTownsNameDelegate {
  func showAroundTownsName(aroundTowns: [Town]) {
    // 근처 동네 목록 보기
    let aroundTownsVC = AroundTownsViewController(towns: aroundTowns)
    self.navigationController?.pushViewController(aroundTownsVC, animated: true)
  }
}

// MARK: - DeleteButton Delegate
extension MyTownSettingViewController: DeleteButtonDelegate {
  func didTapDeleteButton(_ button: UIButton) {
//    let mySetting = MyTownSetting.shared
    switch button {
    case townSelectView
      .firstTownSelectBtn
      .deleteSelectedFirstTownButton:
//      if !mySetting.firstSelectTown.isEmpty && !mySetting.secondSelectTown.isEmpty {
      if manager.firstTown != nil, manager.secondTown != nil {
        willDisplayDeleteAlert(.twoTown, button)
      } else {
        willDisplayDeleteAlert(.oneTown, button)
      }
    case townSelectView
      .secondTownSelectBtn
      .deleteSelectedSecondTownButton:
      willDisplayDeleteAlert(.twoTown, button)
    default: break
    }
  }
}
