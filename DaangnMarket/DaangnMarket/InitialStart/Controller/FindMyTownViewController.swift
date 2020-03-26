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
  
  private lazy var townSearchBar = TownSearchBar().then {
    $0.delegate = self
  }
  private lazy var searchWithLocationButton = DGButton(title: "현재 위치로 찾기").then {
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
  
  // MARK: Model
  
  private var addresses = [String]() {
    didSet {
      let backgroundView = UIView().then { backgroundView in
        TownNoResultView()
          .then { backgroundView.addSubview($0) }
          .snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-52)
        }
      }
      self.tableView.backgroundView = addresses.isEmpty ? backgroundView : nil
      self.tableView.reloadData()
    }
  }
  private var sectionTitle = "근처 동네"
  
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
    UIBarButtonItem(
      image: UIImage(systemName: ImageReference.arrowLeft.rawValue),
      style: .plain,
      target: self,
      action: #selector(didTapBackButton(_:))
    ).do { self.navigationItem.leftBarButtonItem = $0 }
    self.navigationItem.title = "내 동네 찾기"
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.tintColor = .black
  }
  
  private func setupConstraints() {
    self.townSearchBar
      .then { self.view.addSubview($0) }
      .snp
      .makeConstraints {
        $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
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
  
  @objc private func didTapBackButton(_ sender: UIBarButtonItem) {
    self.navigationController?.isNavigationBarHidden = true
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func didTapSearchWithLocationButton(_ sender: UIButton) {
    self.activityIndicator.startAnimating()
    self.locationManager.startUpdatingLocation()
  }
}

// MARK: - UITableViewDataSource

extension FindMyTownViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.addresses.isEmpty ? 0 : 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.addresses.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TownAddressCell.identifier, for: indexPath) as? TownAddressCell else {
      return UITableViewCell()
    }
    cell.update(address: self.addresses[indexPath.row])
    return cell
  }
}

// MARK: - UITableViewDelegate

extension FindMyTownViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("Select Address. Present to Home through alert")
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
}

// MARK: - LocationManagerDelegate

extension FindMyTownViewController: LocationManagerDelegate {
  func locationManager(_ manager: LocationManager, didReceiveLocation location: Location) {
    self.sectionTitle = "근처 동네"
    self.townSearchBar.clear()
    self.activityIndicator.startAnimating()
    DataProvider.requestAddress(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { (result) in
      defer { self.activityIndicator.stopAnimating() }
      
      switch result {
      case .success(let addresses):
        self.addresses = addresses.map { $0.address }
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
      DataProvider.requestAddress(address: text) { (result) in
        defer { self.activityIndicator.stopAnimating() }
        
        switch result {
        case .success(let addresses):
          self.addresses = addresses.map { $0.address }
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  }
}
