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
    $0.rightButton = self.activityEditButton
    $0.title = "알림"
    $0.isShadowHidden = true
  }
  private lazy var segmentedControl = DGSegmentedControl(items: ["활동 알림", "키워드 알림"]).then {
    $0.delegate = self
  }
  private lazy var notificationTableView = NotificationTableView().then {
    $0.scrollViewDelegate = self
    $0.setTableViewDataSource(self)
  }
  private let activityEditButton = UIButton().then { button in
    button.setBackgroundImage(UIImage(systemName: ImageReference.trash.rawValue), for: .normal)
    button.setBackgroundImage(UIImage(systemName: ImageReference.checkmark.rawValue), for: .selected)
    button.tintColor = .black
    button.addTarget(self, action: #selector(didTapEditButton(_:)), for: .touchUpInside)
  }
  private let keywordEditButton = UIButton().then { button in
    button.setBackgroundImage(UIImage(systemName: ImageReference.trash.rawValue), for: .normal)
    button.setBackgroundImage(UIImage(systemName: ImageReference.checkmark.rawValue), for: .selected)
    button.tintColor = .black
    button.addTarget(self, action: #selector(didTapEditButton(_:)), for: .touchUpInside)
  }
  private let keywordConfigButton = UIButton().then { button in
    button.setBackgroundImage(UIImage(systemName: ImageReference.pencil.rawValue), for: .normal)
    button.setBackgroundImage(nil, for: .selected)
    button.tintColor = .black
    button.addTarget(self, action: #selector(didTapKeywordConfigButton(_:)), for: .touchUpInside)
  }
  
  // MARK: Model
  
  private let model = NotificationModel()
  
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
    
    self.notificationTableView
      .then { self.view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self.segmentedControl.snp.bottom)
        $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
  // MARK: Actions
  
  @objc private func didTapBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func didTapEditButton(_ sender: UIButton) {
    sender.isSelected.toggle()
    if sender.isEqual(self.keywordEditButton) {
      self.keywordConfigButton.isHidden = sender.isSelected
    }
    self.notificationTableView.setEditing(sender.isSelected)
  }
  
  @objc private func didTapKeywordConfigButton(_ sender: UIButton) {
    print("Configure Keyword")
  }
}

// MARK: - UITableViewDataSource

extension NotificationViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.notificationTableView.isActivityNotification(tableView) {
      return self.model.contents.count
    } else {
      return self.model.keywordContents.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if self.notificationTableView.isActivityNotification(tableView) {
      return self.notificationTableView
        .dequeueCell(.activity, for: indexPath)
        .configure(
          thumbnail: UIImage(named: self.model.thumbnails[indexPath.row].rawValue),
          content: self.model.contents[indexPath.row],
          date: "\(indexPath.row + 1)시간 전"
      )
    } else {
      return self.notificationTableView
        .dequeueCell(.keyword, for: indexPath)
        .configure(
          thumbnail: UIImage(named: "image1")!,
          content: self.model.keywordContents[indexPath.row],
          date: "\(indexPath.row + 1)시간 전"
      )
    }
  }
}

// MARK: - ScrollViewDelegate

extension NotificationViewController: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    self.shouldScrollWithPanGesture = true
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    self.shouldScrollWithPanGesture = false
    // Dragging을 통해 offset이 바뀌는 경우
    self.switchNavigationItem()
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    // SegmentControl을 통해 offfset이 바뀌는 경우
    self.switchNavigationItem()
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if self.shouldScrollWithPanGesture {
      let offset = scrollView.contentOffset.x
      let numberOfSegments = CGFloat(self.segmentedControl.numberOfSegments)
      self.segmentedControl.updateSelectedIndicator(offset: offset / numberOfSegments, animated: false)
    }
  }
  
  private func switchNavigationItem() {
    switch self.notificationTableView.notificationType {
    case .activity:
      self.navigationBar.rightButton = self.activityEditButton
    case .keyword:
      self.navigationBar.rightButtons = [self.keywordConfigButton, self.keywordEditButton]
    }
  }
}

// MARK: - DGSegmentControlDelegate

extension NotificationViewController: DGSegmentControlDelegate {
  func segmentControl(_ segmentControl: DGSegmentedControl, didSelectSegmeentAt index: Int) {
    let offset = CGPoint(x: CGFloat(index) * self.notificationTableView.frame.width, y: 0)
    self.notificationTableView.setContentOffset(offset, animated: true)
  }
}
