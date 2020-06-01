//
//  ActivityNotificationCell.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/12.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ActivityNotificationCell: NotificationCell {
  // MARK: Interface
  
  override var indexPath: IndexPath {
    get { return IndexPath(row: self.editButton.tag, section: 0) }
    set { self.editButton.tag = newValue.row }
  }
  
  override func configure(thumbnail: UIImage?, content: String, date: String) -> Self {
    self.contentLabel.text = content
    self.thumbnailImageView.image = thumbnail
    self.dateLabel.text = self.updatedTime(from: date)
    return self
  }
  
  private func updatedTime(from date: String) -> String {
    let current = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let created: Date = dateFormatter.date(from: date) ?? current
    let calendar = NSCalendar(calendarIdentifier: .gregorian)
    guard let interval = calendar?.components(
      [.day, .hour, .minute, .second],
      from: created,
      to: current,
      options: []
    )
    else { fatalError("calendar components error") }
    
    if interval.day != 0 {
      return interval.day == 1 ? "어제" : "\(interval.day!)일 전"
    } else if interval.hour != 0 {
      return "\(interval.hour!)시간 전"
    } else if interval.minute != 0 {
      return "\(interval.minute!)분 전"
    } else if interval.second != 0 {
      return "\(interval.second!)초 전"
    } else {
      return "지금"
    }
  }
  
  func setEditMode(_ editMode: Bool) {
    self.editButton
      .snp.updateConstraints {
        $0.size.equalTo(editMode ? 10 : .zero)
        $0.leading
          .equalTo(self.contentLabel.snp.trailing)
          .offset(editMode ? 24 : 0)
    }
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
  private lazy var editButton = UIButton().then {
    $0.setImage(UIImage(systemName: ImageReference.xmark.rawValue), for: .normal)
    $0.addTarget(self, action: #selector(didTapEditButton(_:)), for: .touchUpInside)
    $0.tintColor = .black
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
    }
    
    self.editButton
      .then { self.contentView.addSubview($0) }
      .snp.makeConstraints {
        $0.top.equalTo(self.contentLabel)
        $0.leading
          .equalTo(self.contentLabel.snp.trailing)
          .offset(0)
        $0.trailing
          .equalToSuperview()
          .offset(-padding.x)
        $0.size.equalTo(0)
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
  
  // MARK: Actions
  
  @objc private func didTapEditButton(_ sender: UIButton) {
    self.delegate?.notificationCell(self, didSelectDeleteAt: sender.tag)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
