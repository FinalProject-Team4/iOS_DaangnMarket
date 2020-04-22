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
  private let guideLine = UIView().then {
    $0.backgroundColor = UIColor(named: ColorReference.borderLine.rawValue)
  }
  private let qnaView = UIView()
  
  private lazy var locationManager = CLLocationManager().then {
    $0.delegate = self
  }
  
  // MARK: Properties
  private let selectedTown = "청담동"
  private var currentTownList = ["성수2가제3동", "성수동2가", "성수동2가제1동"]
  private let currentTown = "성수동"
  
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
  
  private func myCheckAuthorizationStatus() {
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined: // 이 응용 프로그램과 관련하여 사용자가 아직 선택하지 않았습니다
      locationManager.requestWhenInUseAuthorization() // 위치 사용하게 할꺼냐고 사용자에게 물어봄
    case .restricted, // 비행기 모드와 같은 상태
    .denied: // 사용자가 거부
      break
    case .authorizedWhenInUse:
      fallthrough
    case .authorizedAlways:
      myStartUpdatingLocation()
    @unknown default: break
    }
  }
  
  func myStartUpdatingLocation() {
    let status = CLLocationManager.authorizationStatus() // 사용자의 설정 상태 확인
    guard status == .authorizedWhenInUse || status == .authorizedAlways else { return }
    guard CLLocationManager.locationServicesEnabled() else { return } // 기기에서 위치 서비스를 사용할 수 있는 상태 확인
    // 10m 면 정확도 낮춘거, 안해도 됨
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.distanceFilter = 10.0
    
    // 사용자 위치 확인하라는 내장 메소드 호출
    locationManager.startUpdatingLocation()
  }
  
  private func setupAttributes() {
    view.backgroundColor = .white
    [mapView, checkTownLabel, currentLocateView, guideLine, qnaView].forEach {
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
      $0.width.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func setupCurrentTownView() {
    let checkSelectedLocationLabel = UILabel().then {
      var list = ""
      currentTownList.forEach {
        list.append($0)
        if currentTownList.lastIndex(of: $0) != 2 {
          list.append(", ")
        }
      }
      let attrString = NSMutableAttributedString()
      let paragraphStyle = NSMutableParagraphStyle().then {
        $0.lineSpacing = 6
        $0.alignment = .center
      }
      attrString.addAttribute(
        NSAttributedString.Key.paragraphStyle,
        value: paragraphStyle,
        range: NSMakeRange(0, attrString.length)
      )
      $0.attributedText = attrString

      $0.attributedText = NSMutableAttributedString()
        .normal("현재 내 동네로 설정되어 있는 ", fontSize: 16)
        .bold("\(list)", fontSize: 16)
        .normal("에서만 동네인증을 할 수 있어요. 현재 위치를 확인해주세요.", fontSize: 16)
      $0.numberOfLines = 0
    }
    let changeLocationButton = UIButton().then {
      $0.setTitle("현재 위치로 동네 변경하기", for: .normal)
      $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
      $0.setTitleColor(.black, for: .normal)
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor(named: ColorReference.borderLine.rawValue)?.cgColor
      $0.layer.cornerRadius = 4
      $0.addTarget(self, action: #selector(didTapChangeTownButton), for: .touchUpInside)
    }
    [checkSelectedLocationLabel, changeLocationButton].forEach {
      currentLocateView.addSubview($0)
    }
    checkSelectedLocationLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-20)
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
  
  @objc private func didTapChangeTownButton() {
//    let alert =
    // 현재 위치 찾아서
    // 현재 위치가 내 동네로 설정한 '~'에 있습니다
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
