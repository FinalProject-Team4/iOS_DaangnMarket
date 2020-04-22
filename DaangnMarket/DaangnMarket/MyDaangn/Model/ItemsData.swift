//
//  Data.swift
//  DaangnMarket
//
//  Created by Mac mini on 2020/04/13.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

struct DummyItemsData {
  let postId: Int
  let username: String
  let title: String
  let content: String
  let category: String
  let updated: String
  let address: String
  let price: Int
  let state: String
  let postImageSet: [String]
}

let dummyItemsData: [DummyItemsData] = [
  DummyItemsData(postId: 1, username: "라이언", title: "옷옷 옷사세요", content: "간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)", category: "여성의류", updated: "1일 전", address: "강서구 화곡동", price: 10_000, state: "sales", postImageSet: ["image1", "image2", "image3"]),
  DummyItemsData(postId: 40, username: "라이언", title: "가방가방 가방사세요", content: "사놓고 한번도 착용하지 않은 새 상품 입니다~ \n저렴하게 드릴께요 \n편하게 문의 주세요!!! \n신당 근처는 직거래 가능합니다 :)", category: "여성의류", updated: "일주일 전", address: "강서구 화곡동", price: 20_000, state: "sales", postImageSet: ["others3", "others4"]),
  DummyItemsData(postId: 45, username: "라이언", title: "벙거지모자 사세요", content: "딱 한번 착용한 새상품 입니다\n예뻐서 샀는데 안어울려서 내놓아요ㅜㅜ \n직거래 가능합니다 \n ", category: "여성의류", updated: "10일 전", address: "강서구 화곡동", price: 5_000, state: "done", postImageSet: ["others1", "others2", "image4"])
]
