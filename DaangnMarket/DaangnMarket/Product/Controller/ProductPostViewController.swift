//
//  ProductPostViewController.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import Alamofire

class ProductPostViewController: UIViewController {
  // MARK: Properties
  var productPostData: [Post] = [] {
    didSet {
      print("productPostData", productPostData)
      self.tableView.reloadData()
    }
  }
  var productPostID: Int {
    didSet {
      print("productPostID", productPostData)
    }
  }
  let viewWidth = UIScreen.main.bounds.width
  var homeVC: UIViewController?
  
  let postService = ProductPostServiceManager.shared
  let myService = MyDaangnServiceManager.shared
  var postParameters: Parameters = [String: Any]()
  var likeParameters: Parameters = [String: Any]()
  var otherItemsParameters: Parameters = [String: Any]()
  var otherItems: [Post] = [] {
    didSet {
      self.tableView.reloadData()
    }
  }
  var httpHeaders: HTTPHeaders
  private var likeData: [Int] = []
  
  // MARK: Views
  lazy var bottomButtons = BottomButtonsView(postPrice: productPostData[0].price, nego: false, isLogin: (AuthorizationManager.shared.userInfo != nil))
  lazy var navigationBar = CustomNavigationBarView()
  private let tableView = UITableView().then {
    $0.backgroundColor = .white
    $0.contentInsetAdjustmentBehavior = .never
  }
  private var imageSet: [String] = []
  lazy var hScrollView = ImagesScrollView(items: imageSet)
  //lazy var hScrollView = ImagesScrollView(items: productPostData[0].photos)
  let pageControl = UIPageControl().then {
    $0.pageIndicatorTintColor = UIColor(named: ColorReference.noResultImage.rawValue)
    $0.currentPageIndicatorTintColor = .white
  }
  let spinner = UIActivityIndicatorView().then {
    $0.color = .white
    $0.style = .large
    $0.hidesWhenStopped = true
  }
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.postParameters = ["post_id": "\(productPostID)"]
    self.requestProductPost(postParameters)
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
    if tableView.contentOffset.y < -viewWidth / 2.5 {
      navigationController?.navigationBar.barStyle = .black
    }
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.barStyle = .default
    navigationController?.navigationBar.isHidden = false
    self.hidesBottomBarWhenPushed = false
  }
  
  // MARK: Initialize
  init(postID: Int, postPhotos: [String]) {
    self.productPostID = postID
    self.imageSet = postPhotos
    let nowHeader = AuthorizationManager.shared.userInfo?.authorization ?? ""
    self.httpHeaders = ["Authorization": "\(nowHeader)"]
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func setupUI() {
    setupNavigationBar()
    setupAttributes()
    setupConstraints()
    self.setNeedsStatusBarAppearanceUpdate()
  }
  private func setupNavigationBar() {
    navigationBar.delegate = self
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    let size: CGFloat = 4
    let backImage = UIImage(systemName: "arrow.left")!.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: size, right: 0))
    navigationController?.navigationBar.backIndicatorImage = backImage
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
  }
  private func setupAttributes() {
    view.backgroundColor = .white
    pageControl.numberOfPages = imageSet.count
    hScrollView.delegate = self
    bottomButtons.delegate = self
    setupTableView()
    if !imageSet.isEmpty {
      setupScrollView()
      navigationController?.navigationBar.barStyle = .black
    } else {
      navigationController?.navigationBar.barStyle = .default
    }
  }
  private func setupConstraints() {
    let guide = view.safeAreaLayoutGuide
    
    self.bottomButtons.then { view.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.bottom.trailing.equalTo(guide)
    }
    self.tableView
      .then { view.addSubview($0) }
      .snp.makeConstraints {
        if !imageSet.isEmpty {
          $0.top.equalTo(view)
        } else {
          $0.top.equalTo(view).offset(91)
        }
        $0.leading.trailing.equalTo(guide)
        $0.bottom.equalTo(bottomButtons.snp.top)
    }
    if !imageSet.isEmpty {
      self.pageControl.then { tableView.addSubview($0) }
        .snp.makeConstraints {
          $0.centerX.equalTo(tableView)
          $0.bottom.equalTo(hScrollView)
      }
      self.spinner.then { tableView.addSubview($0) }
        .snp.makeConstraints {
          $0.centerX.equalTo(view)
          $0.centerY.equalTo(hScrollView)
      }
    }
    view.addSubview(navigationBar)
  }
  private func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorStyle = .none
    tableView.register(SellerInformationTableViewCell.self, forCellReuseIdentifier: SellerInformationTableViewCell.identifier)
    tableView.register(ContentsTableViewCell.self, forCellReuseIdentifier: ContentsTableViewCell.identifier)
    tableView.register(OtherItemsTableViewCell.self, forCellReuseIdentifier: OtherItemsTableViewCell.identifier)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  private func setupScrollView() {
    tableView.contentInset = .init(top: viewWidth, left: 0, bottom: 0, right: 0)
    tableView.contentOffset = CGPoint(x: 0, y: -viewWidth)
    self.tableView.addSubview(hScrollView)
    hScrollView.frame = CGRect(x: 0, y: -viewWidth, width: viewWidth, height: viewWidth)
    hScrollView.contentSize = CGSize(width: viewWidth * CGFloat(imageSet.count), height: viewWidth)
  }
  
  // MARK: Actions
  private func whiteBackNavigationBar() {
    navigationBar.gradientLayer.backgroundColor = UIColor.white.cgColor
    navigationBar.gradientLayer.colors = [UIColor.white.cgColor]
    [navigationBar.backButton, navigationBar.sendOptionButton, navigationBar.otherOptionButton].forEach {
      $0.tintColor = .black
    }
    navigationBar.lineView.isHidden = false
    navigationController?.navigationBar.barStyle = .default
  }
  private func blackBackNavigationBar() {
    if !imageSet.isEmpty {
      navigationBar.gradientLayer.backgroundColor = UIColor.clear.cgColor
      navigationBar.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.clear.cgColor]
      [navigationBar.backButton, navigationBar.sendOptionButton, navigationBar.otherOptionButton].forEach {
        $0.tintColor = .white
      }
      navigationBar.lineView.isHidden = true
      navigationController?.navigationBar.barStyle = .black
    }
  }
  func requestLikeButton(_ parameters: Parameters, _ headers: HTTPHeaders) {
    AF.request(
      "http://13.125.217.34/post/like/",
      method: .post,
      parameters: parameters,
      headers: headers
    )
      .validate()
      .responseJSON { response in
        switch response.response?.statusCode {
        case 200:
          print("좋아요 해지")
        // 좋아요 -1
        case 201:
          print("좋아요 추가")
        // 좋아요 +1
        default:
          print("실패")
        }
    }
  }
  func requestOtherItems(_ parameters: Parameters) {
    myService.requestOtherItems(parameters) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let otherItemsData):
        self.otherItems.append(contentsOf: otherItemsData.results)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  func requestLikeList(_ headers: HTTPHeaders) {
    print("LikeList.headers", headers)
    self.likeData = []
    myService.requestLikeList(headers) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let likeListData):
        let temp: [LikeList] = likeListData.results
        for idx in 0..<temp.count {
          self.likeData.append(temp[idx].post.postId)
        }
        if self.likeData.contains(self.productPostData[0].postId) {
          self.bottomButtons.switchHeartButton(isFullHerat: true)
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  func requestProductPost(_ parameters: Parameters) {
    postService.requestProductPost(parameters) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let productPost):
        self.productPostData.append(productPost)
      case .failure(let error):
        print(error.localizedDescription)
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        self.requestLikeList(self.httpHeaders)
        self.otherItemsParameters = ["username": "\(self.productPostData[0].username)"]
        self.requestOtherItems(self.otherItemsParameters)
        self.setupUI()
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
// MARK: - UITableViewDataSouce
extension ProductPostViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: SellerInformationTableViewCell.identifier, for: indexPath) as? SellerInformationTableViewCell else { return UITableViewCell() }
      cell.configure(image: UIImage(named: "sellerImage1"), sellerId: productPostData[0].username, addr: productPostData[0].address)
      cell.selectionStyle = .none
      return cell
    case 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentsTableViewCell.identifier, for: indexPath) as? ContentsTableViewCell else { return UITableViewCell() }
      cell.selectionStyle = .none
      cell.configure(contentsData: productPostData[0])
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      cell.selectionStyle = .none
      cell.textLabel?.text = "이 게시글 신고하기"
      cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
      return cell
    case 3:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherItemsTableViewCell.identifier, for: indexPath) as? OtherItemsTableViewCell else { return UITableViewCell() }
      let name = productPostData[0].username
      cell.delegate = self
      cell.configure(items: otherItems, sellerName: name)
      cell.selectionStyle = .none
      return cell
    default :
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      cell.textLabel?.text = "\(indexPath.section)"
      return cell
    }
  }
}
// MARK: - UITableViewDelegate
extension ProductPostViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 2:
      return 50
    case 3:
      if otherItems.isEmpty {
        return 0
      } else if otherItems.count > 2 {
        return viewWidth + (CGFloat(16) * 3)
      } else {
        return ( viewWidth + (CGFloat(16) * 3)) / 1.8
      }
    default:
      return UITableView.automaticDimension
    }
  }
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 400
  }
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = scrollView.contentOffset
    if offset.y < -viewWidth {
      spinner.startAnimating()
      hScrollView.frame = CGRect(x: 0, y: offset.y, width: viewWidth, height: -offset.y)
      let index = Int(hScrollView.contentOffset.x / viewWidth)
      self.hScrollView.imageViews[index].frame = CGRect(x: viewWidth * CGFloat(index), y: 0, width: viewWidth, height: -offset.y)
    }
    if tableView.contentOffset.y > -viewWidth / 2.5 {
      whiteBackNavigationBar()
    } else {
      blackBackNavigationBar()
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      if AuthorizationManager.shared.userInfo == nil {
        self.loginSignupMsg()
      } else {
        guard let profilePageVC = ViewControllerGenerator.shared.make(.profilePage, parameters: ["ownSelf": false, "name": productPostData[0].username, "profileData": self.otherItems]) else { return }
        navigationController?.pushViewController(profilePageVC, animated: true)
      }
    }
  }
}
// MARK: - UIScrollViewDelegate
extension ProductPostViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    spinner.stopAnimating()
    if scrollView == hScrollView {
      let offset = scrollView.contentOffset.x
      let pageNumber = Int(floor((offset - viewWidth / 2) / viewWidth) + 1)
      pageControl.currentPage = pageNumber
    }
  }
}
// MARK: - CustomNavigationBarViewDelegate

extension ProductPostViewController: CustomNavigationBarViewDelegate {
  func goBackPage() {
    navigationController?.popViewController(animated: true)
  }
}
// MARK: - OtherItemsTableViewCellDelegate

extension ProductPostViewController: OtherItemsTableViewCellDelegate {
  func moveToPage(otherItem: Post) {
    guard let productPostVC = ViewControllerGenerator.shared.make(.productPost, parameters: ["postID": otherItem.postId, "postPhotos": otherItem.photos]) else { return }
    navigationController?.pushViewController(productPostVC, animated: true)
  }
}
extension ProductPostViewController: BottomButtonsDelegate {
  func likeButton() {
    if AuthorizationManager.shared.userInfo == nil {
      self.loginSignupMsg()
    } else {
      self.likeParameters = ["post_id": "\(productPostData[0].postId)"]
      self.requestLikeButton(likeParameters, httpHeaders)
    DGToastAlert(message: "관심 목록에 추가되었어요.").show(at: .bottom, from: self.view)
    }
  }
}
