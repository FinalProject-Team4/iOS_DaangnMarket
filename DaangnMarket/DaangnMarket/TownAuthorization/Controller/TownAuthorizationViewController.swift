//
//  TownAuthorizationViewController.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/21.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

struct SaveLocate: Codable {
  let locate: String
  let distance: String
  let verified: String
  let activated: String
}

class TownAuthorizationViewController: UIViewController {
  // MARK: Views
  private let mapView = MKMapView().then {
    $0.setUserTrackingMode(.follow, animated: true)
  }
  private let findScopeButton = FindMyLocationButton().then {
    $0.layer.cornerRadius = 28
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor(white: 0.9, alpha: 0.2).cgColor
    $0.addTarget(self, action: #selector(findMyLocate), for: .touchUpInside)
  }
  private lazy var noticeLabel = UILabel().then {
    $0.textAlignment = .center
    $0.backgroundColor = UIColor(named: ColorReference.warning.rawValue)
  }
  private var statusView = UIView()
  private lazy var checkSelectedLocationLabel = UILabel().then {
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
  private let successButton = UIButton().then {
    $0.isHidden = true
    $0.setTitle("동네 인증 완료하기", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
    $0.layer.cornerRadius = 8
    $0.backgroundColor = UIColor(named: ColorReference.daangnMain.rawValue)
    $0.addTarget(self, action: #selector(didTapAuthSuccessButton), for: .touchUpInside)
  }
  
  private lazy var locationManager = CLLocationManager().then { $0.delegate = self }
  
  // MARK: Properties
  private let selectedTown = AuthorizationManager.shared.activatedTown?.locate.dong ?? "unknown"
  private var currentTownList: [String] = [] {
    didSet {
      currentTownList.forEach {
        if $0 == currentTownList[currentTownList.count - 1] {
        currentTownListToString.append($0)
        } else {
          currentTownListToString.append($0 + ", ")
        }
      }
    }
  }
  var currentTownListToString = ""
  private var userSelectedCurrentTown = "" {
    didSet {
      checkSelectedLocationLabel.attributedText = NSMutableAttributedString()
        .normal("현재 위치가 내 동네로 설정한 ", fontSize: 16)
        .bold("\(self.userSelectedCurrentTown)", fontSize: 16)
        .normal("에 있습니다.", fontSize: 16)
      noticeLabel.isHidden = true
      changeLocationButton.isHidden = true
      successButton.isHidden = false
    }
  }
  
  // MARK: LifeCylce
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    checkAuthorizationStatus()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    locationManager.stopUpdatingLocation()
  }
  
  // MARK: Initialize
  init(_ selectedAddress: String) {
    super.init(nibName: nil, bundle: nil)
    // 2. check adress <-> longi,lati adress
    checkGPSAdress { result in
      switch result {
      case .success(let data):
        self.currentTownList = data.results.map { $0.dong }
      case .failure(let err):
        print(err.localizedDescription)
      }
      for town in self.currentTownList {
        if "서초동" == town {
          //        if selectedAddress == town {
          self.setAuthSelectedLocateView(town)
          break
        } else {
          self.setChangeGPSLocateView(selectedAddress)
        }
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
//    checkAuthorizationStatus()
    setupAttributes()
    setupConstraints()
  }
  
  private func setupAttributes() {
    view.backgroundColor = .white
    [mapView, findScopeButton, statusView, guideLine, qnaView, successButton].forEach {
      view.addSubview($0)
    }
    setupCurrentTownView()
    setupQnAView()
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
  
  private func setupConstraints() {
    mapView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.5)
    }
    findScopeButton.snp.makeConstraints {
      $0.size.equalTo(56)
      $0.trailing.equalTo(mapView.snp.trailing).offset(-24)
      $0.bottom.equalTo(mapView.snp.top).offset(-26)
    }
    statusView.snp.makeConstraints {
      $0.top.equalTo(mapView.snp.bottom)
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    guideLine.snp.makeConstraints {
      $0.top.equalTo(statusView.snp.bottom)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
      $0.height.equalTo(1)
    }
    qnaView.snp.makeConstraints {
      $0.top.equalTo(guideLine.snp.bottom)
      $0.width.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(60)
    }
    successButton.snp.makeConstraints {
      $0.top.equalTo(qnaView.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.height.equalTo(44)
    }
  }
  
  private func setupCurrentTownView() {
    [noticeLabel, checkSelectedLocationLabel, changeLocationButton].forEach {
      statusView.addSubview($0)
    }
    noticeLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(40)
    }
    checkSelectedLocationLabel.snp.makeConstraints {
      $0.top.equalTo(noticeLabel.snp.bottom).offset(24)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalTo(changeLocationButton.snp.top).offset(-16)
    }
    changeLocationButton.snp.makeConstraints {
      $0.top.equalTo(checkSelectedLocationLabel.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalToSuperview().offset(-24)
      $0.height.equalTo(36)
    }
  }
  
  private func setChangeGPSLocateView(_ selectedTown: String) {
    noticeLabel.attributedText = NSMutableAttributedString()
      .normal("잠깐만요! 현재 위치가 ", fontSize: 15)
      .bold("\(selectedTown)", fontSize: 15)
      .normal("이 맞나요?", fontSize: 15)
    noticeLabel.textColor = .white
    
    checkSelectedLocationLabel.attributedText = NSMutableAttributedString()
      .normal("현재 내 동네로 설정되어 있는 ", fontSize: 16)
      .bold("'\(currentTownListToString)'", fontSize: 16)
      .normal("에서만 동네인증을 할 수 있어요. 현재 위치를 확인해주세요.", fontSize: 16)
  }
  
  private func setAuthSelectedLocateView(_ town: String) {
    checkSelectedLocationLabel.attributedText = NSMutableAttributedString()
      .normal("현재 위치가 내 동네로 설정한 ", fontSize: 16)
      .bold("\(town)", fontSize: 16)
      .normal("에 있습니다.", fontSize: 16)
    noticeLabel.isHidden = true
    changeLocationButton.isHidden = true
    successButton.isHidden = false
  }
  
  // MARK: Actions
  @objc private func findMyLocate() {
    let current = locationManager.location!
    let coordinate = current.coordinate
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    mapView.setRegion(region, animated: true)
  }
  
  @objc private func didTapChangeTownButton(_ sender: UIButton) {
    UIView.animate(withDuration: 0.3) {
      sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
      self.view.setNeedsDisplay()
    }
    
    let listView = CurrentTownListView(list: currentTownList)
    listView.viewDelegate = self
    let alert = DGAlertController(title: "현재 위치에 있는 동네는 아래와 같아요. 변경하려는 동네를 선택해주세요.", view: listView)
    let okButton = DGAlertAction(title: "동네 변경", style: .orange) {
      alert.dismiss(animated: false)
    }
    let cancelButton = DGAlertAction(title: "취소", style: .white) {
      alert.dismiss(animated: false)
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
    // get -> My Location List/locate/id <-> selecte locate id 비교
    // post -> My Location Save
    // AuthorizationManager.updateSecondTown
    print("----------------!!!!!!!------------------")
    print("----------------!!!!!!!------------------")
    print("----------------!!!!!!!------------------")
    print("----------------!!!!!!!------------------")
    print("----------------!!!!!!!------------------")
    print("선택한 동네가 유저의 첫번째 동네와 동일하면 따로 추가 X, 다르면 유저의 두번째 동네로 추가하면서 dismiss -> toast alert -> HomeFeedVC")
    print("----------------!!!!!!!------------------")
    print("----------------!!!!!!!------------------")
    print("----------------!!!!!!!------------------")
    print("----------------!!!!!!!------------------")
    print("----------------!!!!!!!------------------")
  }
  
  // MARK: Methods
  private func setAlert() {
    let alert = UIAlertController(title: "위치정보 이용에 대한 엑세스 권한이 없습니당.", message: "앱 설정으로 가서 액세스 권한을 수정 하실 수가 있습니당. 이동하시겠나요?", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
      self.dismiss(animated: true)
    }
    let okAction = UIAlertAction(title: "예", style: .default) { _ in
      guard let url = URL(string: UIApplication.openSettingsURLString),
      UIApplication.shared.canOpenURL(url) else { return }
      UIApplication.shared.open(url)
      self.dismiss(animated: true)
    }
    alert.addAction(cancelAction)
    alert.addAction(okAction)
    self.present(alert, animated: false)
  }
  
  private func checkAuthorizationStatus() {
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .restricted, .denied:
      setAlert()
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
  
  private func checkGPSAdress(_ completion: @escaping ( Result<TownInfo, AFError>) -> Void) {
    guard let coordinate = locationManager.location?.coordinate else { return }
    guard let url = URL(string: "http://13.125.217.34/location/range?lati=\(coordinate.latitude)&longi=\(coordinate.longitude)&distance=1200") else { return }
    AF.request(url)
      .validate()
      .responseDecodable { (response: DataResponse<TownInfo, AFError>) in
        switch response.result {
        case .success(let data):
          completion(.success(data))
        case .failure(let err):
          completion(.failure(err))
        }
    }
    self.locationManager.stopUpdatingLocation()
  }
}

// MARK: Extension
extension TownAuthorizationViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    //
  }
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let current = locations.last!
    let coordinate = current.coordinate
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    mapView.setRegion(region, animated: true)
  }
}

extension TownAuthorizationViewController: CurrentTownListViewDelegate {
  func selectedTown(_ town: String) {
    userSelectedCurrentTown = town
  }
}
