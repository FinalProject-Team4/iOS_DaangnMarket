//
//  File.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/05.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

class PostData {
  static let shared = PostData()
  
  private init() {}
  
  var username: String = ""
  var price: String = ""
  var title: String = ""
  var content: String = ""
  var category: String = ""
  var address: String = ""
  var updated: String = ""
  var postImageSet: [String] = ["image1", "image2", "image3", "image4", "image5"]
  
  let numberFormatter = NumberFormatter()
 
  func saveData(_ datas: Post) {
    self.username = datas.username
    self.numberFormatter.numberStyle = .decimal
    self.price = "\(numberFormatter.string(from: NSNumber(value: datas.price))!)원"
    self.title = datas.title
    self.content = datas.content
    self.category = datas.category
    self.address = datas.address
  }
}

struct DummyPostData {
  let seller: [String]
  let price: String
  let isNegociable: Bool
  let isImage: Bool
  let images: [String]
  let contents: [String]
  let otherItems: [[String]]
}

let dummyData1 = DummyPostData(
  seller: ["sellerImage1", "라이언", "성북구 성북동"],
  price: "20,000원",
  isNegociable: false,
  isImage: true,
  images: ["image1", "image2", "image3", "image4", "image5"],
  contents: ["[새제품] 환절기 가디건", "여성의류", "2시간 전", "간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)", "3", "102"],
  otherItems: [["others1", "미니 스트랩백", "20,000원"], ["others2", "수박 에어팟케이스", "5,000원"], ["others3", "벙거지모자", "10,000원"], ["others4", "데님 원피스", "20,000원"]]
)

let dummyData2 = DummyPostData(
  seller: ["sellerImage", "모모", "중구 흥인동"],
  price: "10,000원",
  isNegociable: true,
  isImage: true,
  images: ["item1", "item2", "item3"],
  contents: ["가방 구두 처분해요~", "여성의류", "1시간 전", "사놓고 한번도 착용하지 않은 새 상품 입니다~ \n한번에 구매하시면 저렴하게 드릴께요 \n편하게 문의 주세요!!! \n따로도 구매 가능합니다 \n신당 근처는 직거래 가능합니다 :)", "10", "250"],
  otherItems: [["others3", "벙거지모자", "10,000원"], ["others4", "데님 원피스", "20,000원"]]
)

let dummyData3 = DummyPostData(
  seller: ["sellerImage", "나나", "종로구 혜화동"],
  price: "17,000원",
  isNegociable: true,
  isImage: true,
  images: ["item4", "others1", "others2", "item1", "item2", "item3"],
  contents: ["가방 구두 처분해요~", "여성의류", "1시간 전", "사놓고 한번도 착용하지 않은 새 상품 입니다~ \n한번에 구매하시면 저렴하게 드릴께요 \n편하게 문의 주세요!!! \n따로도 구매 가능합니다 \n신당 근처는 직거래 가능합니다 :)", "10", "250"],
  otherItems: []
)

let dummyData4 = DummyPostData(
  seller: ["sellerImage", "나나", "종로구 혜화동"],
  price: "17,000원",
  isNegociable: true,
  isImage: false,
  images: [],
  contents: ["가방 구두 처분해요~", "여성의류", "1시간 전", "사놓고 한번도 착용하지 않은 새 상품 입니다~ \n한번에 구매하시면 저렴하게 드릴께요 \n편하게 문의 주세요!!! \n따로도 구매 가능합니다 \n신당 근처는 직거래 가능합니다 :)", "10", "250"],
  otherItems: [["image1", "환절기 니트", "20,000원"], ["item2", "가방 처분해요~", "5,000원"], ["others4", "데님 원피스", "20,000원"]]
)






