//
//  TownAuthorizationViewController.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/21.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import MapKit

class TownAuthorizationViewController: UIViewController {
  // MARK: Views
  private let mapView = MKMapView().then {
    $0.setUserTrackingMode(.follow, animated: true)
  }
  private let findScopeButton = FindMyLocationButton().then {
    $0.layer.cornerRadius = 28
  }
  private lazy var checkTownLabel = UILabel().then {
    $0.attributedText = NSMutableAttributedString()
      .normal("잠깐만요! 현재 위치가 ", fontSize: 15)
      .bold("\(selectedTown)", fontSize: 15)
      .normal("이 맞나요?", fontSize: 15)
    $0.textColor = .white
    $0.textAlignment = .center
    $0.backgroundColor = UIColor(named: ColorReference.warning.rawValue)
  }
  private let currentLocateView = UIView()
  private lazy var checkSelectedLocationLabel = UILabel().then {
    currentTownList.forEach {
      currentTownListToString.append($0)
      if currentTownList.lastIndex(of: $0) != 2 {
        currentTownListToString.append(", ")
      }
    }
    $0.attributedText = NSMutableAttributedString()
      .normal("현재 내 동네로 설정되어 있는 ", fontSize: 16)
      .bold("\(currentTownListToString)", fontSize: 16)
      .normal("에서만 동네인증을 할 수 있어요. 현재 위치를 확인해주세요.", fontSize: 16)
    $0.numberOfLines = 0
  }
  private let changeLocationButton = UIButton().then {
    $0.setTitle("현재 위치로 동네 변경하기", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
    $0.setTitleColor(.black, for: .normal)
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor(named: ColorReference.borderLine.rawValue)?.cgColor
    $0.layer.cornerRadius = 4
    $0.addTarget(self, action: #selector(didTapChangeTownButton), for: .touchUpInside)
  }
  private let guideLine = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  private let qnaView = UIView()
  
  private lazy var locationManager = CLLocationManager().then {
    $0.delegate = self
  }
  
  // MARK: Properties
  private let selectedTown = "두번째동네선택"
  private var currentTownList = ["현재동네1", "현재동네2", "현재동네3"]
  private var userSelectedCurrentTown = ""
  var currentTownListToString = ""
  
  // MARK: Initialize
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func setupUI() {
    myCheckAuthorizationStatus()
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    view.backgroundColor = .white
    [mapView, findScopeButton, checkTownLabel, currentLocateView, guideLine, qnaView].forEach {
      view.addSubview($0)
    }
    setupCurrentTownView()
    setupQnAView()
  }
  
  private func setupConstraints() {
    mapView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.5)
    }
    findScopeButton.snp.makeConstraints {
      $0.size.equalTo(56)
      $0.trailing.equalTo(mapView.snp.trailing).offset(-24)
      $0.bottom.equalTo(checkTownLabel.snp.top).offset(-26)
    }
    checkTownLabel.snp.makeConstraints {
      $0.top.equalTo(mapView.snp.bottom)
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(40)
    }
    currentLocateView.snp.makeConstraints {
      $0.top.equalTo(checkTownLabel.snp.bottom)
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    guideLine.snp.makeConstraints {
      $0.top.equalTo(currentLocateView.snp.bottom)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
      $0.height.equalTo(1)
    }
    qnaView.snp.makeConstraints {
      $0.top.equalTo(guideLine.snp.bottom)
      $0.width.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(60)
    }
  }
  
  private func setupCurrentTownView() {
    [checkSelectedLocationLabel, changeLocationButton].forEach {
      currentLocateView.addSubview($0)
    }
    checkSelectedLocationLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.equalToSuperview().offset(-76)
    }
    changeLocationButton.snp.makeConstraints {
      $0.top.equalTo(checkSelectedLocationLabel.snp.bottom).offset(16)
      $0.leading.trailing.equalTo(checkSelectedLocationLabel)
      $0.bottom.equalToSuperview().offset(-24)
      $0.height.equalTo(36)
    }
  }
  
  private func setupQnAView() {
    let qnaLable = UILabel().then {
      $0.text = "왜 동네 인증에 실패하나요?"
      $0.font = .systemFont(ofSize: 16)
    }
    let qnaInfoButton = UIButton().then {
      $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
      $0.tintColor = .gray
    }
    [qnaLable, qnaInfoButton].forEach {
      qnaView.addSubview($0)
    }
    qnaLable.snp.makeConstraints {
      $0.top.equalToSuperview().offset(26)
      $0.leading.equalToSuperview().offset(16)
    }
    qnaInfoButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(26)
      $0.trailing.equalToSuperview().offset(-16)
    }
  }
  
  // MARK: Actions
  @objc private func didTapChangeTownButton(_ sender: UIButton) {
    UIView.animate(withDuration: 0.3) {
      sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
      self.view.setNeedsDisplay()
    }
    
    let listView = CurrentTownListView(list: currentTownList)
    listView.viewDelegate = self
    let alert = DGAlertController(title: "현재 위치에 있는 동네는 아래와 같아요. 변경하려는 동네를 선택해주세요.", view: listView)
    let okButton = DGAlertAction(title: "동네 변경", style: .orange) {
      self.changeTown()
      self.dismiss(animated: false)
    }
    let cancelButton = DGAlertAction(title: "취소", style: .white) {
      self.dismiss(animated: false)
    }
    alert.addAction(okButton)
    alert.addAction(cancelButton)
    self.present(alert, animated: false) {
      UIView.animate(withDuration: 0.3) {
        sender.transform = .identity
      }
    }
  }
  
  @objc private func didTapAuthSuccessButton() {
    print("선택한 동네가 유저의 첫번째 동네와 동일하면 따로 추가 X, 다르면 유저의 두번째 동네로 추가하면서 dismiss -> toast alert -> HomeFeedVC")
  }
  
  // MARK: Methods
  private func changeTown() {
    self.checkSelectedLocationLabel.attributedText = NSMutableAttributedString()
      .normal("현재 위치가 내 동네로 설정한 ", fontSize: 16)
      .bold("\(self.userSelectedCurrentTown)", fontSize: 16)
      .normal("에 있습니다.", fontSize: 16)
    self.changeLocationButton.removeFromSuperview()
    self.checkSelectedLocationLabel.snp.updateConstraints {
      $0.bottom.equalToSuperview().offset(-24)
    }
    setupSuccessButton()
  }
  
  private func setupSuccessButton() {
    let successButton = UIButton().then {
      $0.backgroundColor = UIColor(named: ColorReference.daangnMain.rawValue)
      $0.setTitle("동네 인증 완료하기", for: .normal)
      $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
      $0.layer.cornerRadius = 8
      $0.addTarget(self, action: #selector(didTapAuthSuccessButton), for: .touchUpInside)
    }
    view.addSubview(successButton)
    successButton.snp.makeConstraints {
      $0.top.equalTo(qnaView.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(44)
    }
  }
  
  private func myCheckAuthorizationStatus() {
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .restricted, .denied:
      break
    case .authorizedWhenInUse:
      fallthrough
    case .authorizedAlways:
      myStartUpdatingLocation()
    @unknown default: break
    }
  }
  
  private func myStartUpdatingLocation() {
    let status = CLLocationManager.authorizationStatus()
    guard status == .authorizedWhenInUse || status == .authorizedAlways else { return }
    guard CLLocationManager.locationServicesEnabled() else { return }
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.distanceFilter = 10.0
    locationManager.startUpdatingLocation()
  }
}

// MARK: Extension
extension TownAuthorizationViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let current = locations.last!
    let coordinate = current.coordinate
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    mapView.setRegion(region, animated: true)
  }
}

extension TownAuthorizationViewController: CurrentTownListViewDelegate {
  func selectedTag(_ tag: Int) {
    userSelectedCurrentTown = currentTownList[tag]
  }
}
