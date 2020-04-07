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

struct WriteData: Then, Encodable {
  let title: String
  let content: String
  let category: String
  let price: Int
  let locate: Int
  let showedLocate: [Int]
  
  enum CodingKeys: String, CodingKey {
    case title, content, category, price, locate
    case showedLocate = "showed_locate"
  }
}

struct WriteResponse: Decodable {
  var postID: Int
  
  enum CodingKeys: String, CodingKey {
    case postID = "id"
  }
}

// MARK: - Class Level
class WriteUsedViewController: UIViewController {
  weak var delegate: WriteUsedViewControllerDelegate?
  
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
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: .keyboardWillShow, object: nil)
  }
  
  // MARK: Initialize
  
  private func setupUI() {
    setupNavigation()
    setupAttributes()
    setupConstraints()
    setupNotification()
  }
  
  private func setupNavigation() {
    self.title = "중고거래 글쓰기"
    self.navigationController?.navigationBar.barTintColor = .white
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationItem.rightBarButtonItem =
      UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(requestCreate))
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
      $0.bottom.equalToSuperview()
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
      .addObserver(self, selector: #selector(keyboardWillShow(_:)),
                   name: UIResponder.keyboardWillShowNotification,
                   object: nil)
    NotificationCenter
      .default
      .addObserver(self, selector: #selector(keyboardWillHide(_:)),
                   name: UIResponder.keyboardWillHideNotification,
                   object: nil)
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
      self.dismiss(animated: false)
    }
    alert.addAction(okAction)
    alert.modalPresentationStyle = .overFullScreen
    present(alert, animated: false)
  }
  
  @objc private func dismissVC() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func requestCreate() {
    // 글쓰기에 필요한 데이터 모으기
    // parameters
    // reqeust
    // response
    // success -> finish(dismiss)
    // success -> nil -> alert
    // failure -> alert
    
    guard let titleCell = self.writeTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? WriteTableTitleCell else { return }
    let title = titleCell.cellData
    guard let priceCell = self.writeTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? WriteTablePriceCell else { return }
    let price = Int(priceCell.cellData) ?? 0
    guard let bodyCell = self.writeTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? WriteTableDescriptionCell else { return }
    let content = bodyCell.cellData
    
    alert(title: title, body: content, category: currentCategory)
    
    
    let params = WriteData(
      title: title.isEmpty ? "알림" : title,
      content: content.isEmpty ? "알림" : content,
      category: currentCategory == "카테고리 선택" ?
        "알림" : DGCategory.allCases.filter{ $0.korean == currentCategory }.map{ $0.rawValue }.first ?? "other",
      price: price == 0 ? 0 : price,
      locate: 6_971,
      showedLocate: [6_971, 8_730, 8_725, 6_921]
    )
    
    AF.request(
      "http://13.125.217.34/post/create/",
      method: .post,
      parameters: params,
      encoder: JSONParameterEncoder.default
    )
      .validate()
      .responseJSON { (response) in
        switch response.result {
        case .success:
          guard let responseData = response.data else { return }
          if var decodedID = try? JSONDecoder().decode(WriteResponse.self, from: responseData) {
            let image = UIImage.init(named: "DaanggnMascot")
            let imgData = image!.jpegData(compressionQuality: 0.2)!
            AF.upload(
              multipartFormData: { (multiPartFormData) in
                multiPartFormData.append(imgData, withName: "test.jpeg")
                multiPartFormData.append(
                  Data(bytes: &decodedID.postID, count: MemoryLayout.size(ofValue: decodedID.postID)),
                  withName: "post_id"
                )
            },
              to: "http://13.125.217.34/post/image/upload/"
            )
              .validate()
              .responseJSON { (response) in
                switch response.result {
                case .success(let data):
                  print(data)
                case .failure(let error):
                  print(error.localizedDescription)
                }
            }
          } else {
            print("WriteResponseResult Decode Fail")
          }
        case .failure(let error):
          print(error.localizedDescription)
        }
    }
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
