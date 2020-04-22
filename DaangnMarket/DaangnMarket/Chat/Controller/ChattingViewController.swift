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
  }
  private let messageField = MessageField()
  private let productPreview = ProductPreview()
  
  // MARK: Model
  
  private let messages: [Message] = [
    .init(user: "hey", message: "hi", date: ""),
    .init(user: "hey", message: "hi", date: "")
  ]
  
  private let product = Post(
    postId: 1,
    username: "you",
    title: "펜탁스-A 50mm F1.2팔아요",
    content: "팝니다팔아요",
    category: "digital",
    viewCount: 10,
    updated: "",
    address: "성수",
    price: 450_000,
    state: "sales",
    postImageSet: [PostImage(imageId: 1, photo: "image1", postId: 1)]
  )
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupUI()
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
      thumbnail: UIImage(named: self.product.postImageSet.first?.photo ?? "")
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
    #if targetEnvironment(simulator)
    cell.configure(message: chat.message, isMe: chat.user == "simulator")
    #else
    cell.configure(message: chat.message, isMe: chat.user == "device")
    #endif
    
    return cell
  }
}
