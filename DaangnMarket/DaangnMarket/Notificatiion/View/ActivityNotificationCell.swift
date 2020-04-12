//
//  ActivityNotificationCell.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/12.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ActivityNotificationCell: UITableViewCell {
  // MARK: Interface
  
  func configure(content: String, thumbnail: ImageReference.Notification, date: String) {
    self.contentLabel.text = content
    self.thumbnailImageView.image = UIImage(named: thumbnail.rawValue)
    self.dateLabel.text = date
  }
  
  // MARK: Views
  
  private let thumbnailImageView = UIImageView()
  private let contentLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.font = .systemFont(ofSize: 16)
  }
  private let dateLabel = UILabel().then {
    $0.textColor = UIColor(named: ColorReference.item.rawValue)
    $0.font = .systemFont(ofSize: 13)
  }
  
  // MARK: Identifier
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    self.setupConstraints()
  }
  
  private func setupConstraints() {
    let padding: (x: CGFloat, y: CGFloat) = (16, 24)
    let spacing: CGFloat = 8
    let imageSize: CGFloat = 40
    
    self.thumbnailImageView
      .then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.leading
          .equalToSuperview()
          .inset(UIEdgeInsets(top: padding.y, left: padding.x, bottom: 0, right: 0))

        $0.size.equalTo(imageSize)
    }
    
    self.contentLabel
      .then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self.thumbnailImageView)
        $0.leading
          .equalTo(self.thumbnailImageView.snp.trailing)
          .offset(spacing * 2)
        $0.trailing
          .equalToSuperview()
          .offset(-padding.x)
    }
    
    self.dateLabel
      .then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top
          .equalTo(self.contentLabel.snp.bottom)
          .offset(spacing)
        $0.leading.equalTo(self.contentLabel)
        $0.bottom
          .equalToSuperview()
          .offset(-padding.y)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
