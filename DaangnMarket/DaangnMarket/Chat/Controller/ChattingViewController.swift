//
//  ChattingViewController.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/21.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ChattingViewController: UIViewController {
  // MARK: Views
  
  private lazy var chattingTableView = ChattingTableView().then {
    $0.register(ChattingCell.self, forCellReuseIdentifier: ChattingCell.identifier)
    $0.separatorStyle = .none
    $0.dataSource = self
    $0.delegate = self
  }
  private lazy var messageField = MessageField().then {
    $0.delegate = self
  }
  private let productPreview = ProductPreview()
  
  // MARK: Model
  
  private var messages: [Message] = [
    .init(user: "device", message: "#1 Some message for test", date: "2020-04-01 09:50:43"),
    .init(user: "device", message: "#2 Some message for test", date: "2020-04-01 09:50:43"),
    .init(user: "device", message: "#3 Some message for test", date: "2020-04-01 09:50:43"),
    .init(user: "device", message: "#4 Some message for test", date: "2020-04-01 09:50:43"),
    .init(user: "simulator", message: "#5 Some message for test", date: "2020-04-01 09:50:43"),
    .init(user: "simulator", message: "#6 Some message for test", date: "2020-04-01 09:50:43"),
    .init(user: "simulator", message: "#7 Some message for test", date: "2020-04-01 09:50:43"),
    .init(user: "simulator", message: "#8 Some message for test", date: "2020-04-01 09:50:43"),
    .init(user: "device", message: "#9 Some long message for test", date: "2020-04-02 09:50:43"),
    .init(user: "device", message: "#10 Some long message for test", date: "2020-04-02 09:50:43"),
    .init(user: "device", message: "#11 Some long message for test", date: "2020-04-02 09:50:43"),
    .init(user: "device", message: "#12 Some long message for test", date: "2020-04-02 09:50:43"),
    .init(user: "device", message: "#13 Some long message for test", date: "2020-04-02 09:50:43"),
    .init(user: "device", message: "#14 Some long message for test", date: "2020-04-02 09:50:43"),
    .init(user: "simulator", message: "#15 Some long long message for test", date: "2020-04-02 09:51:00"),
    .init(user: "device", message: "#16 Some long long message for test", date: "2020-04-02 09:51:00"),
    .init(user: "simulator", message: "#17 Some long long message for test", date: "2020-04-02 09:51:00"),
    .init(user: "device", message: "#18 Some long long message for test", date: "2020-04-02 09:51:00"),
    .init(user: "simulator", message: "#19 Some long long long message for test", date: "2020-04-02 09:52:00"),
    .init(user: "device", message: "#20 Some long long long message for test", date: "2020-04-03 09:52:00"),
    .init(user: "simulator", message: "#21 Some long long long message for test", date: "2020-04-03 09:52:00"),
    .init(user: "device", message: "#22 Some long long long message for test", date: "2020-04-03 09:52:00"),
    .init(user: "device", message: "#23 Some long long long long long long message for test", date: "2020-04-03 09:52:00"),
    .init(user: "simulator", message: "#24 Some long long long long long long message for test", date: "2020-04-03 09:53:00"),
    .init(user: "simulator", message: "#25 Some long long long long long long message for test", date: "2020-04-03 09:53:00"),
    .init(user: "device", message: "#26 Some long long long long long long message for test", date: "2020-04-03 09:53:00"),
    .init(user: "device", message: "#27 Some long long long message for test", date: "2020-04-03 09:53:00"),
    .init(user: "simulator", message: "#28 Some long long long message for test", date: "2020-04-03 09:56:00")
  ]
  
  private let product = Post(
    postId: 1,
    username: "Seller",
    title: "펜탁스-A 50mm F1.2팔아요",
    content: "팝니다팔아요",
    category: "digital",
    viewCount: 10,
    created: "",
    updated: "",
    likes: 1,
    address: "성수",
    price: 450_000,
    state: "sales",
    photos: ["image1"]
  )
  
  private var dateIndicatables = [(date: String, row: Int)]()
  private var timeIndicatables = [(time: String, row: Int)]()
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
    self.messages.enumerated().forEach { (index, message) in
      let date = message.date.components(separatedBy: " ").first ?? ""
      let isExist = self.dateIndicatables.contains { $0.date == date }
      if !isExist {
        self.dateIndicatables.append((date, index))
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.chattingTableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
  }
  
  private func setupUI() {
    self.setupAttributes()
    self.setupNavigationBar()
    self.setupConstraints()
  }
  
  private func setupAttributes() {
    self.view.backgroundColor = .systemBackground
    self.productPreview.configure(
      title: self.product.title,
      price: self.product.price,
      thumbnail: UIImage(named: self.product.photos.first ?? "")
    )
    
    // Add Observers
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private func setupNavigationBar() {
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationItem.title = self.product.username
    self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: ImageReference.arrowLeft.rawValue),
      style: .plain,
      target: self,
      action: #selector(didTapBackButton(_:))
    )
    let rightBarButtonItems = UIStackView().then {
      $0.axis = .horizontal
      $0.alignment = .fill
      $0.distribution = .fillEqually
      $0.spacing = 8
    }
    UIButton()
      .then {
        $0.setBackgroundImage(UIImage(named: ImageReference.Chatting.calendar.rawValue), for: .normal)
        $0.addTarget(self, action: #selector(didTapCalendarButton(_:)), for: .touchUpInside)
        rightBarButtonItems.addArrangedSubview($0)
      }
      .snp.makeConstraints { $0.size.equalTo(22) }
    UIButton()
      .then {
        $0.setImage(UIImage(named: ImageReference.Chatting.menu.rawValue), for: .normal)
        $0.addTarget(self, action: #selector(didTapMenuButton(_:)), for: .touchUpInside)
        rightBarButtonItems.addArrangedSubview($0)
      }
      .snp.makeConstraints { $0.size.equalTo(22) }
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButtonItems)
  }
  
  private func setupConstraints() {
    self.productPreview
      .then { self.view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    self.chattingTableView
      .then { self.view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self.productPreview.snp.bottom)
        $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    self.messageField
      .then { self.view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self.chattingTableView.snp.bottom)
        $0.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
  // MARK: Actions
  
  @objc private func didTapBackButton(_ sender: UIBarButtonItem) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func didTapCalendarButton(_ sender: UIButton) {
    print(#function)
  }
  
  @objc private func didTapMenuButton(_ sender: UIButton) {
    print(#function)
  }
  
  @objc func keyboardWillShow(_ noti: Notification) {
    guard let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
    self.messageField.snp.updateConstraints {
      $0.bottom
        .equalTo(self.view.safeAreaLayoutGuide)
        .offset(-frame.height + self.view.safeAreaInsets.bottom)
    }
    let newOffset = self.chattingTableView.contentOffset.y + frame.height
    self.chattingTableView.contentOffset = CGPoint(x: 0, y: newOffset)
  }
  
  @objc func keyboardDidShow(_ noti: Notification) {
    UIView.setAnimationsEnabled(true)
  }
  
  @objc func keyboardWillHide(_ noti: Notification) {
    guard let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
    self.messageField.snp.updateConstraints {
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    let newOffset = max(0.0, self.chattingTableView.contentOffset.y - frame.height)
    self.chattingTableView.contentOffset = CGPoint(x: 0, y: newOffset)
  }
}

// MARK: - UITableViewDataSource

extension ChattingViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.messages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingCell.identifier, for: indexPath) as? ChattingCell else { return UITableViewCell() }
    let chat = self.messages[indexPath.row]
    let comp = chat.date.components(separatedBy: " ")
    let indicatable = self.dateIndicatables.first { $0.row == indexPath.row }
    
    cell.configure(
      message: chat.message,
      date: comp[0],
      time: comp[1],
      profile: nil,
      isMe: chat.user == "device",
      displayDateIndicator: indicatable != nil
    )
    
    return cell
  }
}

// MARK: - UITableViewDelegate

extension ChattingViewController: UITableViewDelegate {
//  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    guard let cell = cell as? ChattingCell else { return }
//    cell.removeConstraints()
//  }
}

// MARK: - MessageFieldDelegate

extension ChattingViewController: MessageFieldDelegate {
  func messageField(_ messageField: MessageField, shouldSendMessage message: String) -> Bool {
    let user: String
    #if targetEnvironment(simulator)
    user = "simulator"
    #else
    user = "device"
    #endif
    
    let formatter = DateFormatter().then {
      $0.locale = .init(identifier: "ko_kr")
      $0.dateFormat = "yyyy-MM-dd hh:mm:ss"
    }
    let message = Message(user: user, message: message, date: formatter.string(from: Date()))
    self.messages.append(message)
    let insertPath = IndexPath(row: self.messages.count - 1, section: 0)
    self.chattingTableView.reloadData()
    self.chattingTableView.scrollToRow(at: insertPath, at: .bottom, animated: true)
    return true
  }
}
