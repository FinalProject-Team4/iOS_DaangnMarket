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
  
  let noti = NotificationCenter.default
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
    noti.post(
      name: NSNotification.Name("PopoverDismiss"),
      object: nil
      )
//    saveTownsInfo(MyTownSetting.shared.isFirstTown)
//    willDisappearAboutSeoncondTownBtn(MyTownSetting.shared.secondSelectTown.isEmpty)
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    MyTownSetting.shared.register(townInfo: AuthorizationManager.shared.aroundTown)
    saveTownsInfo(MyTownSetting.shared.isFirstTown)
    willDisappearAboutSeoncondTownBtn(MyTownSetting.shared.secondSelectTown.isEmpty)
  }
  
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
  
  // MARK: Method
  
  private func willDisappearAboutSeoncondTownBtn(_ isEmpty: Bool) {
    switch isEmpty {
    case true:
      townSelectView.secondTownSelectBtn.isHidden = true
      townSelectView.secondTownSetBtn.isHidden = false
    case false:
      townSelectView.secondTownSelectBtn.isHidden = false
      townSelectView.secondTownSetBtn.isHidden = true
    }
  }
  
  private func saveTownsInfo(_ isFirstTown: Bool) {
    if let firstTown = AuthorizationManager.shared.selectedTown {
      MyTownSetting.shared.firstSelectTown = firstTown.dong
    }
    if let secondTown = AuthorizationManager.shared.anotherTown {
      MyTownSetting.shared.secondSelectTown = secondTown.dong
      noti.post(name: NSNotification.Name("anotherTownSecondTownBtn"), object: nil)
    }
    postNotificationForDefineMyTown(isFirstTown)
  }
  
  private func postNotificationForDefineMyTown(_ isFirstTown: Bool) {
    switch isFirstTown {
    case true:
      noti.post(name: NSNotification.Name("FirstSelectTownCountView"), object: nil)
    case false:      
      noti.post(name: NSNotification.Name("SecondSelectTownCountView"), object: nil)
    }
    setupSelectedTownBGColor(isFirstTown)
  }
  
  private func setupSelectedTownBGColor(_ isFirstTown: Bool) {
    switch isFirstTown {
    case true:
      townSelectView.changeBtnColor(townSelectView.firstTownSelectBtn)
    case false:
      townSelectView.changeBtnColor(townSelectView.secondTownSelectBtn)
    }
  }
  
  private func willDisplayDeleteAlert(_ numberOfTownsSet: MyTownSetting.DeleteTown) {
    switch numberOfTownsSet {
    case .oneTown:
      let title = "동네가 1개만 선택된 상태에서는 삭제를 할 수 없습니당. 현재 설정된 동네를 변경하시겠어요?"
      let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
      let changeAction = UIAlertAction(title: "변경", style: .default) { _ in
        self.didDeleteTownAction(.oneTown)
      }
      let cancelAction = UIAlertAction(title: "취소", style: .default)
      alertController.addAction(cancelAction)
      alertController.addAction(changeAction)
      self.present(alertController, animated: false, completion: nil)
    case .towTown:
      let title = "선택한 지역을 삭제하시겠습니까?"
      let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
      let changeAction = UIAlertAction(title: "확인", style: .default) { _ in
        self.didDeleteTownAction(.towTown)
      }
      let cancelAction = UIAlertAction(title: "취소", style: .default)
      alertController.addAction(cancelAction)
      alertController.addAction(changeAction)
      self.present(alertController, animated: false, completion: nil)
    }
  }
  
  private func didDeleteTownAction(_ numberOfTown: MyTownSetting.DeleteTown) {
    switch numberOfTown {
    case .oneTown:
      let findVC = FindMyTownViewController()
      self.navigationController?.pushViewController(findVC, animated: true)
//      AuthorizationManager.shared.removeTown(forKey: .selectedTown)
      MyTownSetting.shared.firstSelectTown = ""
      townSelectView.didTapSelectTownButton(townSelectView.firstTownSelectBtn)
    case .towTown:
      secondTownInit()
      secondBtnInit()
      townSelectView.didTapSelectTownButton(townSelectView.firstTownSelectBtn)
    }
  }
  
  private func secondTownInit() {
    AuthorizationManager.shared.removeTown(forKey: .anotherTown)
    UserDefaults.standard.remove(forKey: .secondTownByDistance)
    MyTownSetting.shared.secondAroundTownList = [Town]()
    MyTownSetting.shared.secondSelectTown = ""
    MyTownSetting.shared.towns.removeValue(forKey: "second")
    MyTownSetting.shared.isFirstTown = true
  }
  private func secondBtnInit() {
    self.townSelectView.secondTownSelectBtn.isHidden = MyTownSetting.shared.isFirstTown
    self.townSelectView.secondTownSetBtn.isHidden = !MyTownSetting.shared.isFirstTown
    self.setupSelectedTownBGColor(MyTownSetting.shared.isFirstTown)
  }
  
  static func calculateNumberOfAourndTown(_ isFirstTown: Bool, _ distanceValue: Float) {
    defer {
      NotificationCenter.default.post(
        name: NSNotification.Name("AroundTownCountView"),
        object: nil,
        userInfo: [
          "SingleTon": MyTownSetting.shared
        ]
      )
    }
    switch isFirstTown {
    case true:
      guard let firstTownByDistance = MyTownSetting.shared.firstTownByDistance else { return }
      let firstAroundTownCount = firstTownByDistance.filter {
        Float($0.distance!/1_200) <= (distanceValue.rounded() + 1)
      }
      MyTownSetting.shared.firstAroundTownList = firstAroundTownCount
      MyTownSetting.shared.numberOfAroundTownByFirst = (firstAroundTownCount.count, Int(distanceValue))
    case false:
      guard let secondTownByDistance = MyTownSetting.shared.secondTownByDistance else { return }
      let secondAroundTownCount = secondTownByDistance.filter {
        Float($0.distance!/1_200) <= (distanceValue.rounded() + 1)
      }
      MyTownSetting.shared.secondAroundTownList = secondAroundTownCount
      MyTownSetting.shared.numberOfAroundTownBySecond = (secondAroundTownCount.count, Int(distanceValue))
    }
  }
  
  // MARK: Action
  
  @objc private func didTapLeftBarButton() {
    dismiss(animated: true)
  }
}

// MARK: - SecondTownSelectButton Delegate
extension MyTownSettingViewController: SecondTownButtonDelegate {
  func secondTownSetBtn(_ secondButton: UIButton) {
    let findTownVC = FindMyTownViewController()
    self.navigationController?.pushViewController(findTownVC, animated: true)
    MyTownSetting.shared.isFirstTown = false
  }
}

// MARK: - ShowAroundTownsName ViewController Delegte
extension MyTownSettingViewController: ShowAroundTownsNameDelegate {
  func showAroundTownsName() {
    let aroundTownsVC = AroundTownsViewController()
    self.navigationController?.pushViewController(aroundTownsVC, animated: true)
  }
}

// MARK: - DeleteButton Delegate
extension MyTownSettingViewController: DeleteButtonDelegate {
  func didTapDeleteButton(_ button: UIButton) {
    let mySetting = MyTownSetting.shared
    switch button {
    case townSelectView
      .firstTownSelectBtn
      .deleteSelectedFirstTownButton:
      if !mySetting.firstSelectTown.isEmpty && !mySetting.secondSelectTown.isEmpty {
        willDisplayDeleteAlert(.towTown)
      } else {
        willDisplayDeleteAlert(.oneTown)
      }
    case townSelectView
      .secondTownSelectBtn
      .deleteSelectedSecondTownButton:
      willDisplayDeleteAlert(.towTown)
    default: break
    }
  }
}
