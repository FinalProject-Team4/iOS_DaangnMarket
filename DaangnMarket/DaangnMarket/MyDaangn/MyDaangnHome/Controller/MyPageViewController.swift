//
//  MyPageViewController.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController {
  private var myPageTableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func setupUI() {
    setupNavigationBar()
    setupTableView()
    setupAttributes()
    setupConstraints()
  }
  
  private func setupNavigationBar() {
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    let size: CGFloat = 4
    let backImage = UIImage(systemName: "arrow.left")!.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: size, right: 0))
    navigationController?.navigationBar.backIndicatorImage = backImage
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
    navigationController?.navigationBar.shadowImage = .none
    title = "나의 당근"
    self.navigationController?.navigationBar.backgroundColor = .white
    self.navigationController?.navigationBar.isTranslucent = false
    self.navigationController?.navigationBar.tintColor = .black
    let settingButton = UIButton().then {
      let image = UIImage(named: "settings2")?.withRenderingMode(.alwaysTemplate)
      let size: CGFloat = 5
      $0.setImage(image, for: .normal)
      $0.imageView?.contentMode = .scaleAspectFit
      $0.tintColor = .black
      $0.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
      $0.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
    }
    settingButton.addTarget(self, action: #selector(didTapNaviSettingButton(_:)), for: .touchUpInside)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingButton)
  }
  
  private func setupAttributes() {
    self.view.backgroundColor = .white
  }
  
  private func setupTableView() {
    myPageTableView.backgroundColor = UIColor(named: ColorReference.backGray.rawValue)
    myPageTableView.delegate = self
    myPageTableView.dataSource = self
    myPageTableView.register(MyPageUserInformTableViewCell.self, forCellReuseIdentifier: MyPageUserInformTableViewCell.identifier)
    myPageTableView.register(MyPageListButtonsTableViewCell.self, forCellReuseIdentifier: MyPageListButtonsTableViewCell.identifier)
    myPageTableView.register(MyPageOptionButtonsTableViewCell.self, forCellReuseIdentifier: MyPageOptionButtonsTableViewCell.identifier)
    myPageTableView.register(MyPageSettingButtonsTableViewCell.self, forCellReuseIdentifier: MyPageSettingButtonsTableViewCell.identifier)
  }
  
  private func setupConstraints() {
    let guide = view.safeAreaLayoutGuide
    
    self.myPageTableView.then { view.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.trailing.bottom.equalTo(guide)
    }
  }
  
  @objc func didTapNaviSettingButton(_ sender: UIButton) {
    print("설정화면")
  }
}
extension MyPageViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    4
  }
  
  //  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
  //    let clearView = UIView()
  //    clearView.backgroundColor = .clear
  //    clearView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 10)
  //    return clearView
  //  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageUserInformTableViewCell.identifier, for: indexPath) as? MyPageUserInformTableViewCell else { return UITableViewCell() }
      cell.selectionStyle = .none
      cell.delegate = self
      cell.separatorInset = UIEdgeInsets.zero
      return cell
    case 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageListButtonsTableViewCell.identifier, for: indexPath) as? MyPageListButtonsTableViewCell else { return UITableViewCell() }
      cell.delegate = self
      cell.selectionStyle = .none
      cell.separatorInset = UIEdgeInsets.zero
      return cell
    case 2:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageOptionButtonsTableViewCell.identifier, for: indexPath) as? MyPageOptionButtonsTableViewCell else { return UITableViewCell() }
      cell.selectionStyle = .none
      cell.separatorInset = UIEdgeInsets.zero
      return cell
    case 3:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageSettingButtonsTableViewCell.identifier, for: indexPath) as? MyPageSettingButtonsTableViewCell else { return UITableViewCell() }
      cell.selectionStyle = .none
      cell.separatorInset = UIEdgeInsets.zero
      return cell
    default:
      return UITableViewCell()
    }
  }
}

extension MyPageViewController: UITableViewDelegate {
}

extension MyPageViewController: MyPageUserInformDelegate {
  func goToPage(tag: String) {
    switch tag {
    case "showProfileButton":
      self.tabBarController?.tabBar.isHidden = true
      guard let profilePageVC = ViewControllerGenerator.shared.make(.profilePage, parameters: ["ownSelf": true, "name": "라이언", "profileData": userItemsData]) else { return }
      self.navigationController?.pushViewController(profilePageVC, animated: true)
    default:
      break
    }
  }
}

extension MyPageViewController: MyPageListButtonDelegate {
  func moveToPage(tag: String) {
//    switch tag {
//    case "salesListButton":
//      //let salesListVC = SalesListViewController()
//      guard let salesListVC = ViewControllerGenerator.shared.make(.salesList, parameters: ["salesListData": sellerItemsData1]) else { return }
//      self.navigationController?.pushViewController(salesListVC, animated: true)
//    case "likeListButton":
//      let dummyData = PostData.shared.dummyData
//      guard let likeListVC = ViewControllerGenerator.shared.make(.likeList, parameters: ["likeListData": dummyData]) else { return }
//      self.navigationController?.pushViewController(likeListVC, animated: true)
//    default:
//      break
//    }
  }
}
