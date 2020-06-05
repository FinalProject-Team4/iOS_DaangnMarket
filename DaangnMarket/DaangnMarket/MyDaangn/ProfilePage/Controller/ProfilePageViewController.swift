//
//  ProfilePageViewController.swift
//  DaangnMarket
//
//  Created by Mac mini on 2020/04/11.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {
  // MARK: Views
  
  private let profileTableView = UITableView().then {
    $0.backgroundColor = .white
  }
  
  // MARK: Properties
  
  private var isUser = false
  private var profileName = ""
  private let titles = ["활동 뱃지", "판매상품", "동네생활", "받은 매너 평가", "받은 거래 후기"]
  private var profilePageData: [Post]
  private var refreshControl = UIRefreshControl().then {
    $0.tintColor = UIColor(named: ColorReference.daangnMain.rawValue)
  }
  
  // MARK: Initialize
  
  init(ownSelf: Bool, name: String, profileData: [Post]) {
    self.isUser = ownSelf
    self.profileName = name
    self.profilePageData = profileData
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    navigationController?.navigationBar.barStyle = .default
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    self.hidesBottomBarWhenPushed = false
    if isUser {
      self.tabBarController?.tabBar.isHidden = false
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func setupUI() {
    view.backgroundColor = .white
    setupNavigationBar()
    setupTableView()
    setupConstraints()
  }
  private func setupNavigationBar() {
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    self.navigationController?.navigationBar.backgroundColor = .white
    self.navigationController?.navigationBar.isTranslucent = false
    self.navigationController?.navigationBar.tintColor = .black
    title = "프로필"
    
    let shareOptionButton = UIButton().then {
      $0.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
      $0.imageView?.contentMode = .scaleAspectFit
      $0.tintColor = .black
    }
    let otherOptionButton = UIButton().then {
      let image = UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate)
      let size: CGFloat = 23
      $0.setImage(image, for: .normal)
      $0.imageView?.contentMode = .scaleAspectFit
      $0.tintColor = .black
      $0.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
    }
    navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: otherOptionButton), UIBarButtonItem(customView: shareOptionButton)]
  }
  
  private func setupTableView() {
    profileTableView.dataSource = self
    profileTableView.delegate = self
    profileTableView.register(ProfileUserInformTableViewCell.self, forCellReuseIdentifier: ProfileUserInformTableViewCell.identifier)
    profileTableView.register(UITableViewCell.self, forCellReuseIdentifier: "profileCell")
    profileTableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(didPullrefreshControl(_:)), for: .valueChanged)
  }
  
  private func setupConstraints() {
    self.profileTableView
      .then { view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.trailing.bottom.equalTo(view)
    }
  }
  
  // MARK: Actions
  
  @objc func didTapButton(_ sender: Any) {
  }
  
  @objc func didPullrefreshControl(_ sender: Any) {
    self.refreshControl.endRefreshing()
  }
}
// MARK: - UITableViewDataSource

extension ProfilePageViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let clearView = UIView()
    clearView.backgroundColor = .clear
    clearView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 10)
    return clearView
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      guard let cell = profileTableView.dequeueReusableCell(withIdentifier: ProfileUserInformTableViewCell.identifier, for: indexPath) as? ProfileUserInformTableViewCell else { return UITableViewCell() }
      cell.configure(isMyProfile: isUser, name: profileName)
      cell.selectionStyle = .none
      cell.separatorInset = UIEdgeInsets.zero
      return cell
    default:
      let cell = profileTableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
      if indexPath.row == 2 {
        let tempText = "\(titles[(indexPath.row) - 1]) \(profilePageData.count)개"
        cell.textLabel?.text = tempText
      } else {
        cell.textLabel?.text = titles[(indexPath.row) - 1]
      }
      cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
      cell.separatorInset = UIEdgeInsets.zero
      let accSize: CGFloat = 10
      let accImage = UIImage(systemName: "chevron.right")!
      let accImageView = UIImageView()
      accImageView.contentMode = .scaleAspectFill
      accImageView.frame.size = CGSize(width: accSize, height: accSize)
      accImageView.image = accImage
      cell.accessoryView = accImageView
      accImageView.tintColor = .black
      cell.selectionStyle = .none
      return cell
    }
  }
}
// MARK: - UITableViewDelegate

extension ProfilePageViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.row {
    case 0:
      return UITableView.automaticDimension
    default:
      return 80
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 2 {
      guard let sellingItemsVC = ViewControllerGenerator.shared.make(.sellingItems, parameters: ["sellingData": profilePageData]) else { return }
      navigationController?.pushViewController(sellingItemsVC, animated: true)
    }
  }
}
