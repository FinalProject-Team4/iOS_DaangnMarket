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
  
  static var isFirstButton = true
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
    $0.font = .systemFont(ofSize: 17, weight: .light)
  }
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    callDelegate()
    setupConstraint()
    setupNaviBar()
//    postNotification()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    postNotification()
  }
  
  private func callDelegate() {
    townSelectView.delegate = self
    townAroundView.townCountView.delegate = self
    townSelectView.firstTownSelectBtn.delegate = self
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
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  // MARK: Method
  
  private func postNotification() {
    if let firstTown = AuthorizationManager.shared.selectedTown {
      MyTownSetting.shared.firstSelectTown = firstTown.dong
      noti.post(name: NSNotification.Name("FirstSelectTownCountView"), object: nil)
    }
    if let secondTown = AuthorizationManager.shared.anotherTown {
      print("secondTown", secondTown.dong.isEmpty ? secondTown.dong : "nil")
      MyTownSettingViewController.self.isFirstButton.toggle()
      MyTownSetting.shared.secondSelectTown = secondTown.dong
      noti.post(name: NSNotification.Name("anotherTownSecondTownBtn"), object: nil)
      noti.post(name: NSNotification.Name("hidePlusTownSelectView"), object: nil)
      noti.post(name: NSNotification.Name("SecondSelectTownCountView"), object: nil)
    }
    setupSelectedTownBGColor(MyTownSettingViewController.self.isFirstButton)
  }
  
  private func setupSelectedTownBGColor(_ isFirstButton: Bool) {
    if isFirstButton {
      townSelectView.changeBtnBGColor(townSelectView.firstTownSelectBtn)
    } else {
      townSelectView.changeBtnBGColor(townSelectView.secondTownSelectBtn)
    }
    saveAroundTown()
  }
  
  private func saveAroundTown() {
    if MyTownSetting.shared.numberOfAroundFirstTownByDistance.isEmpty {
      MyTownSetting.shared.numberOfAroundFirstTownByDistance = AuthorizationManager.shared.aroundTown
    } else {
      MyTownSetting.shared.numberOfAroundSecondTownByDistance = AuthorizationManager.shared.aroundTown
    }
  }
  
  private func willDisplayDeleteAlert(_ situation: MyTownSetting.DeleteTown) {
    switch situation {
    case .oneTown:
      let title = "동네가 1개만 선택된 상태에서는 삭제를 할 수 없습니당. 현재 설정된 동네를 변경하시겠어요?"
      let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
      let changeAction = UIAlertAction(title: "변경", style: .default)
      let cancelAction = UIAlertAction(title: "취소", style: .default)
      alertController.addAction(cancelAction)
      alertController.addAction(changeAction)
      self.present(alertController, animated: false, completion: nil)
    case .towTown:
      let title = "선택한 지역을 삭제하시겠습니까?"
      let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
      let changeAction = UIAlertAction(title: "확인", style: .default)
      let cancelAction = UIAlertAction(title: "취소", style: .default)
      alertController.addAction(cancelAction)
      alertController.addAction(changeAction)
      self.present(alertController, animated: false, completion: nil)
    }
  }
   
  // MARK: Action
  
  @objc private func didTapLeftBarButton() {
    dismiss(animated: true)
  } 
}

// MARK: SecondTownSelectButton Delegate
extension MyTownSettingViewController: SecondTownButtonDelegate {
  func secondTownSelectBtn(_ secondButton: UIButton) {
    let findTownVC = FindMyTownViewController()
    self.navigationController?.pushViewController(findTownVC, animated: true)
  }
}

// MARK: ShowAroundTownsName ViewController Delegte
extension MyTownSettingViewController: ShowAroundTownsNameDelegate {
  func showAroundTownsName() {
    let aroundTownsVC = AroundTownsViewController()
    self.navigationController?.pushViewController(aroundTownsVC, animated: true)
  }
}

// MARK: DeleteButton Delegate
extension MyTownSettingViewController: DeleteButtonDelegate {
  func didTapDeleteButton(_ button: UIButton) {
    let mySetting = MyTownSetting.shared
    switch button {
    case townSelectView.firstTownSelectBtn.deleteSelectedFirstTownButton:
      if !mySetting.firstSelectTown.isEmpty && !mySetting.secondSelectTown.isEmpty {
        willDisplayDeleteAlert(.towTown)
        NotificationCenter.default.post(name: NSNotification.Name("FirstSelectTownCountView"), object: nil)
      } else {
        willDisplayDeleteAlert(.oneTown)
      }
    case townSelectView.secondTownSelectBtn.deleteSelectedSecondTownButton:
      willDisplayDeleteAlert(.towTown)
      mySetting.secondSelectTown = ""
      MyTownSettingViewController.self.isFirstButton.toggle()
      setupSelectedTownBGColor(MyTownSettingViewController.self.isFirstButton)
    default: break
    }
  }
}
