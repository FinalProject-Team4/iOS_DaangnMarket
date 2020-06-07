//
//  LikeListTableViewCell.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/23.
//  Copyright © 2020 Jisng. All rights reserved.
//
import UIKit
import Alamofire

protocol LikeListTVCDelegate: class {
  func likeButton(postId: Int)
}

class LikeListTableViewCell: UITableViewCell {
  weak var delegate: LikeListTVCDelegate?
  
  let itemImageView = UIImageView().then {
    $0.layer.cornerRadius = 5
    $0.contentMode = .scaleAspectFit
    $0.clipsToBounds = true
  }
  let completedMark = UILabel().then {
    $0.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
    $0.textColor = .white
    $0.text = "거래완료"
    $0.textAlignment = .center
    $0.font = UIFont.boldSystemFont(ofSize: 13)
    $0.layer.cornerRadius = 12
    $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    $0.clipsToBounds = true
  }
  let contentLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 15)
    $0.textColor = .black
    $0.numberOfLines = 2
  }
  var heartButton = UIButton().then {
    $0.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
    $0.tintColor = UIColor(named: ColorReference.daangnMain.rawValue)
  }
  let addrTimeLabel = UILabel().then {
    $0.textColor = UIColor(named: ColorReference.subText.rawValue)
    $0.font = UIFont.systemFont(ofSize: 13)
  }
  let priceLabel = UILabel().then {
    $0.textColor = UIColor(named: ColorReference.daangnMain.rawValue)
    $0.font = UIFont.boldSystemFont(ofSize: 15)
  }
  let chatLikeView = PageChatLikeView()
  
  var isFullHeart = true
  var postID = 0
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupUI() {
    setupAttributes()
    setupConstraints()
  }
  
  func setupAttributes() {
    self.contentView.backgroundColor = .white
    self.heartButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
  }
  
  func setupConstraints() {
    let spacing: CGFloat = 16
    let imageSize: CGFloat = 120
    let markSize: CGFloat = 23
    self.itemImageView.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading.equalToSuperview().offset(spacing)
        $0.width.height.equalTo(imageSize)
        $0.bottom.equalToSuperview().offset(-spacing).priority(999)
    }
    self.completedMark.then { itemImageView.addSubview($0) }
      .snp.makeConstraints {
        $0.width.equalTo(76)
        $0.height.equalTo(24)
        $0.top.equalTo(itemImageView).offset(spacing / 2)
        $0.leading.equalTo(itemImageView)
    }
    self.heartButton.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalToSuperview().offset(20)
        $0.trailing.equalToSuperview().offset(-spacing)
        $0.width.height.equalTo(markSize)
    }
    self.chatLikeView.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.trailing.equalToSuperview().offset(-spacing)
        $0.bottom.equalTo(itemImageView)
    }
    self.contentLabel.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(itemImageView.snp.trailing).offset(spacing)
        $0.top.equalTo(itemImageView).offset(spacing / 2)
        $0.trailing.equalTo(heartButton.snp.leading).offset(-spacing * 2)
    }
    self.addrTimeLabel.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.trailing.equalTo(contentLabel)
        $0.top.equalTo(contentLabel.snp.bottom).offset(spacing / 2)
    }
    self.priceLabel.then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.equalTo(addrTimeLabel)
        $0.top.equalTo(addrTimeLabel.snp.bottom).offset(spacing / 2)
    }
  }
  
  let numberFormatter = NumberFormatter()
  
  func configure(likeData: Post) {
    self.postID = likeData.postId
    if likeData.photos.isEmpty {
      self.itemImageView.image = UIImage(named: "DaangnDefaultItem")
    } else {
      self.itemImageView.kf.setImage(with: URL(string: likeData.photos[0]))
    }
    self.contentLabel.text = likeData.title + likeData.content
    self.addrTimeLabel.text = "\(likeData.address) ･ \(PostData.shared.calculateDifferentTime(updated: likeData.created))"
    self.numberFormatter.numberStyle = .decimal
    self.priceLabel.text = "\(numberFormatter.string(from: NSNumber(value: likeData.price))!)원"
    if likeData.state == "sales" {
      self.completedMark.isHidden = true
    }
    self.chatLikeView.configure(chat: 0, like: likeData.likes)
  }
  
  @objc func didTapButton(_ sender: UIButton) {
    self.isFullHeart.toggle()
    if !isFullHeart {
      self.heartButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
    } else {
      self.heartButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
    }
    delegate?.likeButton(postId: self.postID)
    print(self.postID)
  }
}
