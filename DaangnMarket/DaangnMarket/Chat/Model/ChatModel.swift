//
//  ChatModel.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/19.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

struct ChatInfo {
  let username: String
  let profileImage: String?
  let address: String
  let updated: String
  let content: String
  let badge: Int
  let productImage: String?
  var isBookmarked: Bool
}

struct Message: Codable {
  let user: String
  let message: String
  let date: String
}

class ChatModel {
  var chatList = [
    ChatInfo(
      username: "당근이",
      profileImage: ImageReference.daangni.rawValue,
      address: "서울특별시 강남구",
      updated: "하루 전",
      content: "비움을 실천하고 계신 cskim님, 정말 멋져요! 따뜻함이 배가 되는 당근마켓의 거래매너를 확인해보세요:)",
      badge: 0,
      productImage: nil,
      isBookmarked: false
    ),
    ChatInfo(
      username: "user1",
      profileImage: "sellerImage",
      address: "서울특별시 성동구",
      updated: "1시간 전",
      content: "넵 팔렸어요 ㅠㅠ",
      badge: 0,
      productImage: "image1",
      isBookmarked: false
    ),
    ChatInfo(
      username: "user2",
      profileImage: "sellerImage1",
      address: "서울특별시 관악구",
      updated: "3시간 전",
      content: "조금만 깎아주시면 안되나요?",
      badge: 3,
      productImage: nil,
      isBookmarked: false
    ),
    ChatInfo(
      username: "user3",
      profileImage: nil,
      address: "서울특별시 강동구",
      updated: "1주 전",
      content: "내일 거래 가능하세요?",
      badge: 10,
      productImage: "image3",
      isBookmarked: false
    )
  ]
}
