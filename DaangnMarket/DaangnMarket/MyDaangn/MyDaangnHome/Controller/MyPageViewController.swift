//
//  MyPageViewController.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import Alamofire

class MyPageViewController: UIViewController {
  // MARK: View
  private var myPageTableView = UITableView()
  private var homeVC: UIViewController?
  let service = MyDaangnServiceManager.shared
  var otherItemsParameters: Parameters = [String: Any]()
  var otherItems: [Post] = []
  
  // MARK: Life Cycle
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.myPageTableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.requestOtherItems(self.otherItemsParameters)
    setupUI()
  }
  
  // MARK: Initialize
  
  init() {
    let username = AuthorizationManager.shared.userInfo?.username ?? ""
    self.otherItemsParameters = ["username": "\(username)"]
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
  
  // MARK: Action
  
  @objc func didTapNaviSettingButton(_ sender: UIButton) {
    print("설정화면")
  }
  
  func requestOtherItems(_ parameters: Parameters) {
    service.requestOtherItems(parameters) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let otherItemsData):
        self.otherItems.append(contentsOf: otherItemsData.results)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  private func loginSignupMsg() {
    let alert = DGAlertController(title: "회원가입 또는 로그인 후 이용할 수 있습니다.")
    let loginSignup = DGAlertAction(title: "로그인/가입", style: .orange) {
      self.dismiss(animated: true) {
        guard let phoneAuthVC = ViewControllerGenerator.shared.make(.phoneAuth) else { return }
        phoneAuthVC.modalPresentationStyle = .fullScreen
        self.present(phoneAuthVC, animated: true)
      }
    }
    let cancel = DGAlertAction(title: "취소", style: .cancel) {
      self.dismiss(animated: false)
    }
    alert.addAction(loginSignup)
    alert.addAction(cancel)
    alert.modalPresentationStyle = .overFullScreen
    present(alert, animated: false)
  }
}
// MARK: - UITableViewDataSource

extension MyPageViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageUserInformTableViewCell.identifier, for: indexPath) as? MyPageUserInformTableViewCell else { return UITableViewCell() }
      cell.selectionStyle = .none
      let username = AuthorizationManager.shared.userInfo?.username ?? ""
      let useraddr = AuthorizationManager.shared.activatedTown?.locate.dong ?? ""
      cell.configure(userName: username, userAddr: useraddr, isLogin: (AuthorizationManager.shared.userInfo != nil))
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
      cell.delegate = self
      cell.separatorInset = UIEdgeInsets.zero
      return cell
    case 3:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageSettingButtonsTableViewCell.identifier, for: indexPath) as? MyPageSettingButtonsTableViewCell else { return UITableViewCell() }
      cell.selectionStyle = .none
      cell.separatorInset = UIEdgeInsets.zero
      cell.delegate = self
      return cell
    default:
      return UITableViewCell()
    }
  }
}

// MARK: - UITableViewDelegate

extension MyPageViewController: UITableViewDelegate {
}

// MARK: - MyPageUserInformDelegate

extension MyPageViewController: MyPageUserInformDelegate {
  func goToPage(tag: String) {
    if AuthorizationManager.shared.userInfo == nil {
      self.loginSignupMsg()
    } else {
      switch tag {
      case "profileImageButton":
        print("프로필 수정 페이지 띄우기")
      case "showProfileButton":
        let username = AuthorizationManager.shared.userInfo?.username ?? ""
        self.tabBarController?.tabBar.isHidden = true
        guard let profilePageVC = ViewControllerGenerator.shared.make(.profilePage, parameters: ["ownSelf": true, "name": "\(username)", "profileData": otherItems]) else { return }
        self.navigationController?.pushViewController(profilePageVC, animated: true)
      default:
        break
      }
    }
  }
}

// MARK: - MyPageListButtonDelegate

extension MyPageViewController: MyPageListButtonDelegate {
  func moveToPage(tag: String) {
    if AuthorizationManager.shared.userInfo == nil {
      self.loginSignupMsg()
    } else {
      switch tag {
      case "salesListButton":
        guard let salesListVC = ViewControllerGenerator.shared.make(.salesList) else { return }
        self.navigationController?.pushViewController(salesListVC, animated: true)
      case "likeListButton":
        guard let likeListVC = ViewControllerGenerator.shared.make(.likeList) else { return }
        self.navigationController?.pushViewController(likeListVC, animated: true)
      default:
        break
      }
    }
  }
}

extension MyPageViewController: MyPageOptionButtonsTVCDelegate {
  func moveToPageForOption(tag: String) {
    if AuthorizationManager.shared.userInfo == nil && tag != "myTownSettingButton" {
      self.loginSignupMsg()
    } else {
      switch tag {
      case "myTownSettingButton":
        print("내 동네 설정 띄우기")
      case "confirmMyTownButton":
        print("동네 인증하기 띄우기")
      case "gatheringButton":
        print("모아 보기 구현 안함")        
      default:
        print("default")
      }
    }
  }
}

extension MyPageViewController: MyPageSettinButtonsTVCDelegate {
  func moveToPageForSetting(tag: String) {
    switch tag {
    case "shareButton":
      print("당근마켓 공유")
    case "noticeButton":
      print("공지사항")
    case "settingButton":
      print("설정")
    default:
      print("default")
    }
  }
}
