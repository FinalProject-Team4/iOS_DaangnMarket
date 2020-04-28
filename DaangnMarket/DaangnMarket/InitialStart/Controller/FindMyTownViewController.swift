//
//  FindMyTownViewController.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class FindMyTownViewController: UIViewController {
  // MARK: Views
  
  private lazy var navigationBar = DGNavigationBar().then {
    $0.leftButton = UIButton().then { button in
      button.setBackgroundImage(UIImage(systemName: ImageReference.arrowLeft.rawValue), for: .normal)
      button.tintColor = .black
      button.addTarget(self, action: #selector(didTapBackButton(_:)), for: .touchUpInside)
    }
    $0.title = "내 동네 찾기"
  }
  private lazy var townSearchBar = TownSearchBar().then {
    $0.delegate = self
  }
  private lazy var searchWithLocationButton = DGButton().then {
    $0.setTitle("현재 위치로 찾기", for: .normal)
    $0.addTarget(self, action: #selector(didTapSearchWithLocationButton), for: .touchUpInside)
    $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.layer.cornerRadius = 18
  }
  private lazy var tableView = UITableView().then {
    $0.dataSource = self
    $0.delegate = self
    $0.register(TownAddressCell.self, forCellReuseIdentifier: TownAddressCell.identifier)
    $0.register(TownHeaderView.self, forHeaderFooterViewReuseIdentifier: TownHeaderView.identifier)
    $0.tableFooterView = UIView()
  }
  private let activityIndicator = UIActivityIndicatorView().then {
    $0.color = UIColor(named: ColorReference.daangnMain.rawValue)
    $0.hidesWhenStopped = true
  }
  private lazy var backgroundView = TownBackgroundView().then {
    $0.addTarget(self, action: #selector(didTapReSearchButton(_:)))
  }
  
  // MARK: Model
  
  private var towns = [Town]() {
    didSet {
      self.tableView.backgroundView = towns.isEmpty ? self.backgroundView : nil
      self.tableView.reloadData()
    }
  }
  private var sectionTitle = "근처 동네"
  
  private enum TownRequestType {
    case gps, search
  }
  
  private var townRequestType: TownRequestType = .gps
  
  // MARK: Services
  
  private let locationManager = LocationManager()
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
  }
  
  // MARK: Initialize
  
  private func setupUI() {
    self.setupAttributes()
    self.setupConstraints()
  }
  
  private func setupAttributes() {
    self.view.backgroundColor = .systemBackground
    self.locationManager.delegate = self
    
    let isPushedFromInitial = self.navigationController?.lastViewController(offset: 1) is InitialStartViewController
    
    if !isPushedFromInitial {
      let button = UIButton().then { button in
        button.setBackgroundImage(UIImage(systemName: ImageReference.arrowLeft.rawValue), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapBackButton(_:)), for: .touchUpInside)
      }
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
  }
  
  private func setupConstraints() {
    let isPushedFromInitial = self.navigationController?.lastViewController(offset: 1) is InitialStartViewController
    
    if isPushedFromInitial {
      self.navigationBar
        .then { self.view.addSubview($0) }
        .snp
        .makeConstraints {
          $0.top.equalToSuperview().offset(UINavigationBar.statusBarSize.height)
          $0.centerX.equalToSuperview()
      }
    }
        
    self.townSearchBar
      .then { self.view.addSubview($0) }
      .snp
      .makeConstraints {
        if isPushedFromInitial {
          $0.top.equalTo(self.navigationBar.snp.bottom)
        } else {
          $0.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      }
    
    let buttonSize: CGFloat = 36
    let padding: CGFloat = 16
    self.searchWithLocationButton
      .then { self.view.addSubview($0) }
      .snp
      .makeConstraints {
        $0.top
          .equalTo(self.townSearchBar.snp.bottom)
          .offset(padding)
        $0.leading.trailing
          .equalToSuperview()
          .inset(UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding))
        $0.height.equalTo(buttonSize)
    }
    
    self.tableView
      .then { self.view.addSubview($0) }
      .snp
      .makeConstraints {
        $0.top.equalTo(self.searchWithLocationButton.snp.bottom).offset(16)
        $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    self.activityIndicator
      .then { self.view.addSubview($0) }
      .snp
      .makeConstraints {
        $0.center.equalToSuperview()
    }
  }
  
  // MARK: Actions
  
  @objc private func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func didTapSearchWithLocationButton(_ sender: UIButton) {
    self.townSearchBar.endEditing(false)
    self.activityIndicator.startAnimating()
    self.locationManager.startUpdatingLocation()
  }
  
  @objc private func didTapReSearchButton(_ sender: UIButton) {
    self.townSearchBar
      .clear()
      .startEditing()
  }
}

// MARK: - UITableViewDataSource

extension FindMyTownViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.towns.isEmpty ? 0 : 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.towns.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TownAddressCell.identifier, for: indexPath) as? TownAddressCell else {
      return UITableViewCell()
    }
    cell.update(address: self.towns[indexPath.row].address)
    return cell
  }
}

// MARK: - UITableViewDelegate

extension FindMyTownViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selected = self.towns[indexPath.row]
    API.default.request(.distance(dongId: selected.id)) { (result) in
      switch result {
      case .success(let around):
        let userInfo = AuthorizationManager.shared.userInfo
        let userTown = UserTown(
          user: userInfo?.username ?? "unknown",
          verified: self.townRequestType == .gps,
          activated: true,
          distance: 3_600,
          locate: selected
        )
        
        let manager = AuthorizationManager.shared
        if manager.firstTown == nil {
          manager.firstTown = userTown
          manager.firstAroundTown = around
        } else {
          // second에 넣기
          manager.secondTown = userTown
          manager.secondAroundTown = around
        }
//        AuthorizationManager.shared.do {
//          $0.register(town: userTown)
//          $0.aroundTown = around
//        }
      case .failure(let error):
        self.presentAlert(title: "Around Address Error", message: error.localizedDescription)
        return
      }
      
      switch self.navigationController?.lastViewController(offset: 1) {
      case is InitialStartViewController:
        ViewControllerGenerator.shared.make(.default)?.do {
          UIApplication.shared.switchRootViewController($0)
        }
//        MyTownSetting.shared.isFirstTown = true
//        MyTownSetting.shared.register(isFirstTown: true)
      case is MyTownSettingViewController:
        self.navigationController?.popViewController(animated: true)
      default:
        return
      }
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TownHeaderView.identifier) as? TownHeaderView else { return nil }
    sectionView.update(title: self.sectionTitle)
    return sectionView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 36
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    self.townSearchBar.endEditing(false)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == self.towns.count - 2 {
      API.default.requestNext { (result) in
        switch result {
        case .success(let addresses):
          self.towns.append(contentsOf: addresses)
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  }
}

// MARK: - LocationManagerDelegate

extension FindMyTownViewController: LocationManagerDelegate {
  func locationManager(_ manager: LocationManager, didReceiveLocation location: Location) {
    self.sectionTitle = "근처 동네"
    self.townSearchBar.clear()
    self.activityIndicator.startAnimating()
    let coordinate = location.coordinate
    API.default
      .request(.GPS(lat: coordinate.latitude, lon: coordinate.longitude)) { (result) in
        defer { self.activityIndicator.stopAnimating() }
        switch result {
        case .success(let addresses):
          self.townRequestType = .gps
          self.towns = addresses
        case .failure(let error):
          print(error.localizedDescription)
        }
    }
  }
}

// MARK: - TownSearchBarDelegate

extension FindMyTownViewController: TownSearchBarDelegate {
  func townSearchBar(_ townSearchBar: TownSearchBar, willSearchWith text: String) {
    if text.isEmpty {
      DGToastAlert(message: "검색어를 입력하세요").show(at: .center, from: self.view)
    } else {
      self.sectionTitle = "'\(text)' 검색 결과"
      self.activityIndicator.startAnimating()
      API.default
        .request(.search(text: text)) { (result) in
          defer { self.activityIndicator.stopAnimating() }
          
          switch result {
          case .success(let addresses):
            self.townRequestType = .search
            self.towns = addresses
          case .failure(let error):
            print(error.localizedDescription)
          }
      }
    }
  }
}
