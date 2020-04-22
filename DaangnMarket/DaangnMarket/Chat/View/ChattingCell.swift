//
//  ChatCell.swift
//  FirebaseChatSample
//
//  Created by cskim on 2020/04/20.
//  Copyright © 2020 cskim. All rights reserved.
//

import UIKit

class ChattingCell: UITableViewCell {
  
  func configure(message: String, isMe: Bool) {
    self.myChatView.isHidden = !isMe
    self.otherChatView.isHidden = isMe
    self.myChat.text = isMe ? message : ""
    self.otherChat.text = isMe ? "" : message
  }
  
  let myChatView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 12
    view.backgroundColor = UIColor.orange.withAlphaComponent(0.7)
    view.isHidden = true
    return view
  }()
  
  let otherChatView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 12
    view.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
    view.isHidden = true
    return view
  }()
  
  let myChat: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  let otherChat: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    
    self.contentView.addSubview(self.otherChatView)
    self.otherChatView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.otherChatView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
      self.otherChatView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
      self.otherChatView.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -32),
      self.otherChatView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
    ])
    
    self.otherChatView.addSubview(self.otherChat)
    self.otherChat.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.otherChat.topAnchor.constraint(equalTo: self.otherChatView.topAnchor, constant: 4),
      self.otherChat.leadingAnchor.constraint(equalTo: self.otherChatView.leadingAnchor, constant: 4),
      self.otherChat.trailingAnchor.constraint(lessThanOrEqualTo: self.otherChatView.trailingAnchor, constant: -4),
      self.otherChat.bottomAnchor.constraint(equalTo: self.otherChatView.bottomAnchor, constant: -4)
    ])
    
    self.contentView.addSubview(self.myChatView)
    self.myChatView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.myChatView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
      self.myChatView.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: 32),
      self.myChatView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
      self.myChatView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
    ])
    
    self.myChatView.addSubview(self.myChat)
    self.myChat.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.myChat.topAnchor.constraint(equalTo: self.myChatView.topAnchor, constant: 4),
      self.myChat.leadingAnchor.constraint(equalTo: self.myChatView.leadingAnchor, constant: 4),
      self.myChat.trailingAnchor.constraint(lessThanOrEqualTo: self.myChatView.trailingAnchor, constant: -4),
      self.myChat.bottomAnchor.constraint(equalTo: self.myChatView.bottomAnchor, constant: -4)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

