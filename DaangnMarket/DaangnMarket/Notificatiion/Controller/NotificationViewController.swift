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
    $0.setTableViewDelegate(self)
    $0.delegate = self
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
  
  private let model: NotificationModel
  
  // MARK: Properties
  
  private var shouldScrollWithPanGesture = false
  
  // MARK: Life Cycle
  
  init(userInfo: UserInfo) {
    self.model = NotificationModel(userInfo: userInfo)
    super.init(nibName: nil, bundle: nil)
  }
  
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
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(didReceiveActivityNotification(_:)),
      name: NotificationModel.didResponseActivityNotification,
      object: nil
    )
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
  
  // MARK: Observing
  
  @objc private func didReceiveActivityNotification(_ noti: Notification) {
    self.notificationTableView.reloadData(for: .activity)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UITableViewDataSource

extension NotificationViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.notificationTableView.isActivityNotification(tableView) ? 1 : 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.notificationTableView.isActivityNotification(tableView) {
//      return self.model.contents.count
      return self.model.notifications.count
    } else if section == 0 {
      return self.keywordEditButton.isSelected ? 1 : 0
    } else {
      return self.model.keywordContents.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if self.notificationTableView.isActivityNotification(tableView) {
      return self.activityCell(tableView, for: indexPath)
    } else if indexPath.section == 0 {
      return self.keywordHeader(tableView, for: indexPath)
    } else {
      return self.keywordCell(tableView, for: indexPath)
    }
  }
  
  private func activityCell(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
    let sortedNotis = Array(self.model.notifications.reversed())
    return self.notificationTableView
      
      .dequeueCell(.activity, for: indexPath)
      .then {
        $0.delegate = self
        $0.configure(
          thumbnail: UIImage(named: self.model.thumbnails[0].rawValue),
          content: sortedNotis[indexPath.row].body,
          date: sortedNotis[indexPath.row].created
        )
    }
  }
  
  private func keywordCell(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
    return self.notificationTableView
      .dequeueCell(.keyword, for: indexPath)
      .then {
        $0.delegate = self
        $0.configure(
          thumbnail: UIImage(named: "image1")!,
          content: self.model.keywordContents[indexPath.row],
          date: "\(indexPath.row + 1)시간 전"
        )
    }
  }
  
  private func keywordHeader(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
    guard let header = tableView.dequeueReusableCell(withIdentifier: KeywordNotificationHeader.identifier, for: indexPath) as? KeywordNotificationHeader else { return UITableViewCell() }
    header.delegate = self
    return header
  }
}

// MARK: - UITableViewDelegate

extension NotificationViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if self.notificationTableView.isActivityNotification(tableView),
      indexPath.row == self.model.notifications.count - 2 {
      self.model.requestNextActivityNoti()
    }
  }
}

// MARK: - NotificationTableViewDelegate

extension NotificationViewController: NotificationTableViewDelegate {
  func activityTableView(_ tableView: UITableView, didStartRefreshControl refreshControl: UIRefreshControl) {
    self.model.requestActivityNoti { refreshControl.endRefreshing() }
  }
  
  func keywordTableView(_ tableView: UITableView, didStartRefreshControl refreshControl: UIRefreshControl) {
    refreshControl.endRefreshing()
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

// MARK: - KeywordNotificationHeaderDelegate

extension NotificationViewController: KeywordNotificationHeaderDelegate {
  func headerView(_ headerView: KeywordNotificationHeader, didTapRemoveButton button: UIButton) {
    let cancel = UIAlertAction(title: "취소", style: .cancel)
    let remove = UIAlertAction(title: "삭제", style: .default) { (_) in
      self.model.keywordContents.removeAll()
      self.notificationTableView.reloadData(for: .keyword)
    }
    self.presentAlert(
      title: "키워드 알림을 모두 삭제하시겠어요?",
      actions: [cancel, remove]
    )
  }
}

// MARK: - NotificationCellDelegate

extension NotificationViewController: NotificationCellDelegate {
  func notificationCell(_ cell: NotificationCell, didSelectDeleteAt row: Int) {
    if cell is ActivityNotificationCell {
      self.model.removeContent(at: row)
      self.notificationTableView.deleteRows([IndexPath(row: row, section: 0)], for: .activity)
    }
    
    if cell is KeywordNotificationCell {
      self.model.keywordContents.remove(at: row)
      self.notificationTableView.deleteRows([IndexPath(row: row, section: 1)], for: .keyword)
    }
  }
}
