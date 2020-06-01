//
//  HomeFeedTableViewCell.swift
//  DaangnMarket
//
//  Created by Demian on 2020/03/25.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class HomeFeedTableViewCell: UITableViewCell {
  // MARK: Properties
  
  var userUpdateTimes = [DateComponents]()
  
  // MARK: Views
  
  private let goodsImageView = UIImageView().then {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 5
    $0.contentMode = .scaleToFill
  }
  private let goodsName = UILabel().then {
    $0.font = .systemFont(ofSize: 16)
    $0.textAlignment = .left
    $0.numberOfLines = 0
  }
  private let sellerLoctionAndTime = UILabel().then {
    $0.font = .systemFont(ofSize: 12)
    $0.textAlignment = .center
    $0.textColor = .lightGray
  }
  private let goodsPrice = UILabel().then {
    $0.font = .systemFont(ofSize: 15)
    $0.textAlignment = .center
  }
  private let likesMark = UIImageView().then {
    $0.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
    $0.image = UIImage(systemName: "heart")
    $0.tintColor = .lightGray
  }
  private let likesCount = UILabel().then {
    $0.frame = CGRect(x: 0, y: 0, width: 0, height: 16)
    $0.font = .systemFont(ofSize: 14)
    $0.textColor = .lightGray
    $0.textAlignment = .center
  }
  private let separateBar = UIView().then {
    $0.backgroundColor = .lightGray
  }
  
  // MARK: Initialize
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    setupContentUI()
  }
  
  private func setupContentUI() {
    setupConstraints()
  }
  private func setupConstraints() {
    [
      goodsImageView, goodsName, sellerLoctionAndTime,
      goodsPrice, likesMark, likesCount, separateBar
    ].forEach { self.contentView.addSubview($0) }
    goodsImageView.snp.makeConstraints {
      $0.centerY.equalTo(self.contentView.snp.centerY)
      $0.leading.equalTo(self.contentView.snp.leading).offset(16)
      $0.width.height.equalTo(104)
    }
    goodsName.snp.makeConstraints {
      $0.top.equalTo(goodsImageView)
      $0.leading.equalTo(goodsImageView.snp.trailing).offset(16)
      $0.trailing.equalToSuperview().offset(-5)
    }
    sellerLoctionAndTime.snp.makeConstraints {
      $0.top.equalTo(goodsName.snp.bottom).offset(5)
      $0.leading.equalTo(goodsName)
    }
    goodsPrice.snp.makeConstraints {
      $0.top.equalTo(sellerLoctionAndTime.snp.bottom).offset(7)
      $0.leading.equalTo(goodsName)
    }
    likesMark.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-30)
      $0.bottom.equalToSuperview().offset(-18)
    }
    likesCount.snp.makeConstraints {
      $0.centerY.equalTo(likesMark.snp.centerY)
      $0.leading.equalTo(likesMark.snp.trailing)
    }
    separateBar.snp.makeConstraints {
      $0.leading.equalTo(self.contentView.snp.leading).offset(16)
      $0.trailing.equalTo(self.contentView.snp.trailing).offset(-16)
      $0.bottom.equalToSuperview()
      $0.height.equalTo(0.3)
      $0.centerX.equalToSuperview()
    }
  }
  
  // MARK: Method
  private func removeNotNeededTimeUnit(_ address: String, _ userUpdateTimes: DateComponents) -> String {    
    var updateTime = String()
    var filteredAddress = String()
    if address != "None" {
      filteredAddress = address.components(separatedBy: "구 ")[1]
      print()
    } else {
      filteredAddress = "패캠동"
    }
    
    if userUpdateTimes.day != 0 {
      if userUpdateTimes.day == 1 {
        updateTime += "\(filteredAddress) ・ 어제"
      } else {
        updateTime += "\(filteredAddress) ・ \(userUpdateTimes.day!)일 전"
      }
    } else if userUpdateTimes.hour != 0 {
      updateTime += "\(filteredAddress) ・ \(userUpdateTimes.hour!)시간 전"
    } else if userUpdateTimes.minute != 0 {
      updateTime += "\(filteredAddress) ・ \(userUpdateTimes.minute!)분 전"
    } else if userUpdateTimes.second != 0 {
      updateTime += "\(filteredAddress) ・ \(userUpdateTimes.second!)초 전"
    }
    return updateTime
  }
  
  private func calculateDifferentTime(_ posts: [Post]) {
    let currentTime = Date()
    for idx in 0..<posts.count {
      let tempTime = posts[idx].updated.replacingOccurrences(of: "T", with: " ").components(separatedBy: ".")[0]
//      let tempTime = posts[idx].created.replacingOccurrences(of: "T", with: " ").components(separatedBy: ".")[0]
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      let updatedTime: Date = dateFormatter.date(from: tempTime) ?? currentTime
      let calculrate = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
      guard let compareTime = calculrate?.components(
        [.day, .hour, .minute, .second],
        from: updatedTime,
        to: currentTime,
        options: []
      )
      else { fatalError("castin error") }
      userUpdateTimes.append(compareTime)
    }
  }
  
  func setupHomeFeedCell(posts: [Post], indexPath: IndexPath) {
    setFeedImage(posts, indexPath)
    setLikes(posts, indexPath)
    calculateDifferentTime(posts)
    goodsName.text = "\(posts[indexPath.row].title)"
    goodsPrice.text = self.inputTheThousandsOfCommas(posts, indexPath)
    sellerLoctionAndTime.text = removeNotNeededTimeUnit(posts[indexPath.row].address, userUpdateTimes[indexPath.row])
  }
  
  private func setFeedImage(_ posts: [Post], _ indexPath: IndexPath) {
    if posts[indexPath.row].photos.isEmpty {
      goodsImageView.image = UIImage(named: "DaanggnMascot")
    } else {
      goodsImageView.kf.setImage(with: URL(string: posts[indexPath.row].photos[0]))
    }
  }
  
  private func setLikes(_ posts: [Post], _ indexPath: IndexPath) {
    if posts[indexPath.row].likes == 0 {
      likesMark.isHidden = true
      likesCount.text = ""
    } else {
      likesMark.isHidden = false
      likesCount.text = "\(posts[indexPath.row].likes)"
    }
  }
  
  private func inputTheThousandsOfCommas(_ posts: [Post], _ indexPath: IndexPath) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let price = numberFormatter.string(from: NSNumber(value: posts[indexPath.row].price))! + "원"
    return price
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
