//
//  WriteUsedViewController.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import Then

extension Notification.Name {
  static let keyboardWillShow = Notification.Name("keyboardWillShow")
}

extension MultipartFormData: Then { }

protocol WriteUsedViewControllerDelegate: class {
  func selectImage(image: UIImage)
}

// MARK: - Class Level
class WriteUsedViewController: UIViewController {
  weak var delegate: WriteUsedViewControllerDelegate?
  
  // MARK: Views
  private lazy var writeTableView = UITableView()
    .then {
      $0.dataSource = self
      $0.delegate = self
      $0.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: $0.frame.width, height: 1))
      $0.register(WriteTableAlbumCell.self, forCellReuseIdentifier: WriteTableAlbumCell.cellID)
      $0.register(WriteTableTitleCell.self, forCellReuseIdentifier: WriteTableTitleCell.cellID)
      $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
      $0.register(WriteTablePriceCell.self, forCellReuseIdentifier: WriteTablePriceCell.cellID)
      $0.register(WriteTableDescriptionCell.self, forCellReuseIdentifier: WriteTableDescriptionCell.cellID)
  }
  
  private lazy var selectLocationView = SelectLocationView().then {
    $0.delegate = self
  }
  
  private let imagePicker = UIImagePickerController()
  
  var currentCategory = "카테고리 선택"{
    didSet {
      writeTableView.cellForRow(at: IndexPath(row: 2, section: 0))?.textLabel?.text = currentCategory
    }
  }
  var header: HTTPHeader
  var uploadImages: [UIImage] = []
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewWillLayoutSubviews() {
    selectLocationView.layer.addBorder(edge: .top, color: .lightGray, thickness: 1)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard let cell = writeTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? WriteTableAlbumCell else {
      print("guard fail")
      return
    }
    cell.addImageView.delegate = self
    self.delegate = cell
  }
  
  // MARK: Initialize
  init(token: String) {
    header = HTTPHeader(name: "Authorization", value: token)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: .keyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private func setupUI() {
    setupNavigation()
    setupAttributes()
    setupConstraints()
    setupNotification()
  }
  
  private func setupNavigation() {
    self.navigationController?.title = "중고거래 글쓰기"
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationItem.rightBarButtonItem =
      UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didTapCreateButton))
    self.navigationItem.leftBarButtonItem =
      UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(dismissVC))
  }
  
  private func setupAttributes() {
    view.backgroundColor = .white
    view.addSubview(writeTableView)
    view.addSubview(selectLocationView)
    imagePicker.delegate = self
  }
  
  private func setupConstraints() {
    writeTableView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.bottom.equalTo(selectLocationView.snp.top)
    }
    selectLocationView.snp.makeConstraints {
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.08)
    }
  }
  
  private func setupNotification() {
    NotificationCenter
      .default
      .addObserver(
        self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil
    )
    NotificationCenter
      .default
      .addObserver(
        self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil
    )
  }
  
  // MARK: Actions
  @objc private func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
      let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
      let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
    
    let height = self.view.frame.maxY
    let keyboard = frame.minY
    let safeLayout = view.safeAreaInsets.bottom
    let diff = height - keyboard - safeLayout
    
    UIView.animate(withDuration: duration) {
      self.selectLocationView.snp.updateConstraints {
        $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-diff)
      }
      self.writeTableView.snp.updateConstraints {
        $0.bottom.equalTo(self.selectLocationView.snp.top)
      }
      self.view.layoutIfNeeded()
    }
    
    NotificationCenter.default.post(name: .keyboardWillShow, object: nil)
  }
  
  @objc private func keyboardWillHide(_ notification: NSNotification) {
    guard let userInfo = notification.userInfo,
      let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
    
    UIView.animate(withDuration: duration) {
      self.selectLocationView.snp.updateConstraints {
        $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
      }
      self.view.layoutIfNeeded()
    }
  }
  
  @objc private func dismissVC() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func didTapCreateButton() {
    guard let locate = AuthorizationManager.shared.firstTown?.locate.id,
      let distance = AuthorizationManager.shared.firstTown?.distance else { return }
    let imgDatas = self.uploadImages.map { $0.jpegData(compressionQuality: 0.2) }
    guard let titleCell = self.writeTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? WriteTableTitleCell else { return }
    let title = titleCell.cellData
    guard let priceCell = self.writeTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? WriteTablePriceCell else { return }
    let price = priceCell.cellData
    guard let bodyCell = self.writeTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? WriteTableDescriptionCell else { return }
    let content = bodyCell.cellData
    
    if title.isEmpty || currentCategory == "카테고리 선택" || content.isEmpty {
      alert(title: title, body: content, category: currentCategory)
    } else {
      let parameters: [String: Any] = [
        "title": title,
        "content": content,
        "category": categoryFilter(currentCategory),
        "price": String(price),
        "photos": imgDatas,
        "locate": String(locate),
        "distance": String(distance)
      ]
      request(parameters, [header]) { result in
        switch result {
        case .success:
          self.dismiss(animated: true)
        case .failure(let err):
          print(err.localizedDescription)
        }
      }
    }
  }
  
  // MARK: Methods
  private func request(_ parameters: [String: Any], _ headers: HTTPHeaders, completion: @escaping (Result<Post, AFError>) -> Void) {
    AF.upload(
      multipartFormData: { (multiFormData) in
        for (key, value) in parameters {
          if let data = value as? [Data] {
            data.forEach {
              let num = data.firstIndex(of: $0)
              multiFormData.append($0, withName: key, fileName: "image\(num).jpeg", mimeType: "image/jpeg")
            }
          } else {
            multiFormData.append("\(value)".data(using: .utf8)!, withName: key)
          }
        }
    }, to: "http://13.125.217.34/post/",
       method: .post,
       headers: headers
    )
      .validate()
      .responseDecodable { (resonse: DataResponse<Post, AFError>) in
        switch resonse.result {
        case .success(let data):
          completion(.success(data))
        case .failure(let error):
          completion(.failure(error))
        }
    }
  }
  
  private func alert(title: String, body: String, category: String) {
    var message: String = ""
    if title.isEmpty {
      message.append(contentsOf: "- 글 제목은 필수 입력 항목입니당. \n")
    }
    if body.isEmpty {
      message.append(contentsOf: "- 내용은 필수 입력 항목입니당. \n")
    }
    if category == "카테고리 선택" {
      message.append(contentsOf: "- 카테고리는 필수 입력 항목입니당.")
    }
    let alert = DGAlertController(title: message)
    let okAction = DGAlertAction(title: "확인", style: .orange) {
      alert.dismiss(animated: false)
    }
    alert.addAction(okAction)
    alert.modalPresentationStyle = .overFullScreen
    present(alert, animated: false)
  }
  
  private func categoryFilter(_ currrentCategory: String) -> String {
    DGCategory.allCases
      .filter { $0.korean == currentCategory }
      .map { $0.rawValue }
      .first ?? "other"
  }
}

// MARK: - Extension Level
extension WriteUsedViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: WriteTableAlbumCell.cellID, for: indexPath)
      cell.selectionStyle = .none
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: WriteTableTitleCell.cellID, for: indexPath)
      cell.selectionStyle = .none
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      cell.selectionStyle = .none
      cell.textLabel?.text = currentCategory
      cell.tintColor = .black
      cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
      return cell
    case 3:
      let cell = tableView.dequeueReusableCell(withIdentifier: WriteTablePriceCell.cellID, for: indexPath)
      cell.selectionStyle = .none
      return cell
    case 4:
      let cell = tableView.dequeueReusableCell(withIdentifier: WriteTableDescriptionCell.cellID, for: indexPath)
      cell.selectionStyle = .none
      return cell
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      cell.selectionStyle = .none
      cell.textLabel?.text = "개발중..."
      cell.textLabel?.textColor = .lightGray
      return cell
    }
  }
}

extension WriteUsedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 2 {
      let selectCategoryVC = SelectCategoryViewController(category: currentCategory)
      selectCategoryVC.modalPresentationStyle = .overFullScreen
      view.endEditing(true)
      navigationController?.pushViewController(selectCategoryVC, animated: true)
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.row {
    case 0:
      return CGFloat(90)
    case 2:
      return CGFloat(70)
    default:
      return UITableView.automaticDimension
    }
  }
}

extension WriteUsedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    guard let mediaType = info[.mediaType] as? NSString else {
      print("typecasting fail : NSString")
      return
    }
    if UTTypeEqual(mediaType, kUTTypeImage) {
      guard let originalImage = info[.originalImage] as? UIImage else { return }
      let editedImage = info[.editedImage] as? UIImage
      let selectedImage = editedImage ?? originalImage
      delegate?.selectImage(image: selectedImage)
      
      if picker.sourceType == .camera {
        UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil)
      }
    } else if UTTypeEqual(mediaType, kUTTypeMovie) {
      if let mediaPath = (info[.mediaURL] as? NSURL)?.path, UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(mediaPath) {
        UISaveVideoAtPathToSavedPhotosAlbum(mediaPath, nil, nil, nil)
      }
    }
    picker.dismiss(animated: true)
  }
}

extension WriteUsedViewController: AddImageViewDelegate {
  func openAlbum() {
    imagePicker.sourceType = .photoLibrary
    present(imagePicker, animated: false)
  }
  
  func openCamera() {
    imagePicker.sourceType = .camera
    present(imagePicker, animated: false)
  }
  
  func presentAlert(alert: UIAlertController) {
    present(alert, animated: true)
  }
}

extension WriteUsedViewController: SelectLocationButtonDelegate {
  func selectLocationButton(_ sender: UIButton) {
    let chooseTownController = ChooseTownToShowViewController()
    self.navigationController?.pushViewController(chooseTownController, animated: true)
  }
}
