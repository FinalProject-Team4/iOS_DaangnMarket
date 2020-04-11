//
//  NotificationViewController.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/11.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
  // MARK: Views
  
  private lazy var navigationBar = DGNavigationBar().then {
    $0.leftButton = UIButton().then { button in
      button.setBackgroundImage(UIImage(systemName: ImageReference.arrowLeft.rawValue), for: .normal)
      button.tintColor = .black
      button.addTarget(self, action: #selector(didTapBackButton(_:)), for: .touchUpInside)
    }
    $0.rightButton = UIButton().then { button in
      button.setBackgroundImage(UIImage(systemName: ImageReference.trash.rawValue), for: .normal)
      button.tintColor = .black
      button.addTarget(self, action: #selector(didTapEditButton(_:)), for: .touchUpInside)
    }
    $0.title = "알림"
    $0.isShadowHidden = true
  }
  private lazy var segmentedControl = DGSegmentedControl(items: ["활동 알림", "키워드 알림"]).then {
    $0.delegate = self
  }
  private lazy var scrollView = UIScrollView().then {
    $0.isPagingEnabled = true
    $0.delegate = self
    $0.showsHorizontalScrollIndicator = false
  }
  private lazy var activityNotiTableView = UITableView().then {
    $0.dataSource = self
  }
  private lazy var keywordNotiTableView = UITableView().then {
    $0.dataSource = self
  }
  
  // MARK: Properties
  
  private var shouldScrollWithPanGesture = false
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
  }
  
  private func setupUI() {
    self.setupAttributes()
    self.setupConstraints()
  }
  
  private func setupAttributes() {
    self.view.backgroundColor = .systemBackground
  }
  
  private func setupConstraints() {
    self.navigationBar
      .then { self.view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalToSuperview().offset(UINavigationBar.statusBarSize.height)
        $0.centerX.equalToSuperview()
    }
    
    self.segmentedControl
      .then { self.view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self.navigationBar.snp.bottom)
        $0.leading.trailing.equalTo(self.navigationBar)
        $0.height.equalTo(40)
    }
      
    scrollView
      .then { self.view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self.segmentedControl.snp.bottom)
        $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    self.activityNotiTableView
      .then { scrollView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.bottom.equalToSuperview()
        $0.size.equalToSuperview()
    }
    
    self.keywordNotiTableView
      .then { scrollView.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(self.activityNotiTableView.snp.trailing)
        $0.top.trailing.bottom.equalToSuperview()
        $0.size.equalToSuperview()
    }
  }
  
  // MARK: Actions
  
  @objc private func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func didTapEditButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}

// MARK: - UITableViewDataSource

extension NotificationViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
    cell.textLabel?.text = "Row \(indexPath.row)"
    return cell
  }
}

// MARK: - ScrollViewDelegate

extension NotificationViewController: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    self.shouldScrollWithPanGesture = true
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    self.shouldScrollWithPanGesture = false
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if self.shouldScrollWithPanGesture {
      let offset = scrollView.contentOffset.x
      let numberOfSegments = CGFloat(self.segmentedControl.numberOfSegments)
      self.segmentedControl.updateSelectedIndicator(offset: offset / numberOfSegments, animated: false)
    }
  }
}

// MARK: - DGSegmentControlDelegate

extension NotificationViewController: DGSegmentControlDelegate {
  func segmentControl(_ segmentControl: DGSegmentedControl, didSelectSegmeentAt index: Int) {
    let offset = CGPoint(x: CGFloat(index) * self.scrollView.frame.width, y: 0)
    self.scrollView.setContentOffset(offset, animated: true)
  }
}
