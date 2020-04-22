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
  //var postImageSet: [String] = []
  
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
  
  func calculateDifferentTime(updated: String) -> String {
    let currentTime = Date()
    var updateTime = String()
    
    let tempTime = updated.replacingOccurrences(of: "T", with: " ").components(separatedBy: ".")[0]
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let updatedTime: Date = dateFormatter.date(from: tempTime) ?? currentTime
    let calculrate = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
    guard let compareTime = calculrate?.components([.day, .hour, .minute, .second], from: updatedTime, to: currentTime, options: [])
      else { fatalError("castin error") }

    if compareTime.day != 0 {
      if compareTime.day == 1 {
        updateTime += "어제"
      } else {
        updateTime += "\(compareTime.day!)일 전"
      }
    } else if compareTime.hour != 0 {
      updateTime += "\(compareTime.hour!)시간 전"
    } else if compareTime.minute != 0 {
      updateTime += "\(compareTime.minute!)분 전"
    } else if compareTime.second != 0 {
      updateTime += "\(compareTime.second!)초 전"
    }
    return updateTime
  }
  
  // LikeList Dummy Data
  var dummyData: [Post] = [
    Post(postId: 0, username: "모모", title: "선글라스 옷사세요", content: "심플하게 착용할 수 있는 \n선글라스 입니다~ \n편하게 문의 주세요:)", category: "여성의류", viewCount: 0, updated: "1일 전", address: "강서구 화곡동", price: 100_000, state: "sales", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
    Post(postId: 1, username: "휘타", title: "향초 팔아요~", content: "사놓고 한번도 착용하지 않은 새 상품 입니다~ \n저렴하게 드릴께요 \n편하게 문의 주세요!!! \n신당 근처는 직거래 가능합니다 :)", category: "여성의류", viewCount: 0, updated: "일주일 전", address: "강서구 화곡동", price: 20_000, state: "sales", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
    Post(postId: 2, username: "런런", title: "키체인 사세요", content: "딱 한번 착용한 새상품 입니다\n예뻐서 샀는데 안어울려서 내놓아요ㅜㅜ \n직거래 가능합니다 \n ", category: "여성의류", viewCount: 0, updated: "10일 전", address: "강서구 화곡동", price: 5_000, state: "done", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
    Post(postId: 3, username: "문문성", title: "선글라스 옷사세요", content: "심플하게 착용할 수 있는 \n선글라스 입니다~ \n편하게 문의 주세요:)", category: "여성의류", viewCount: 0, updated: "1일 전", address: "강서구 화곡동", price: 100_000, state: "sales", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
    Post(postId: 4, username: "자은석", title: "향초 팔아요~", content: "사놓고 한번도 착용하지 않은 새 상품 입니다~ \n저렴하게 드릴께요 \n편하게 문의 주세요!!! \n신당 근처는 직거래 가능합니다 :)", category: "여성의류", viewCount: 0, updated: "일주일 전", address: "강서구 화곡동", price: 20_000, state: "sales", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
    Post(postId: 5, username: "부쵸", title: "모니터 사세요", content: "딱 한번 착용한 새상품 입니다\n예뻐서 샀는데 안어울려서 내놓아요ㅜㅜ \n직거래 가능합니다 \n ", category: "여성의류", viewCount: 0, updated: "10일 전", address: "강서구 화곡동", price: 5_000, state: "done", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)])
  ]
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

var sellerItemsData1: [Post] = [
  Post(postId: 1, username: "모모", title: "선글라스 옷사세요", content: "심플하게 착용할 수 있는 \n선글라스 입니다~ \n편하게 문의 주세요:)", category: "여성의류", viewCount: 1, updated: "1일 전", address: "강서구 화곡동", price: 100_000, state: "sales", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),

  Post(postId: 2, username: "모모", title: "향초 팔아요~", content: "사놓고 한번도 착용하지 않은 새 상품 입니다~ \n저렴하게 드릴께요 \n편하게 문의 주세요!!! \n신당 근처는 직거래 가능합니다 :)", category: "여성의류", viewCount: 2, updated: "일주일 전", address: "강서구 화곡동", price: 20_000, state: "done", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
  Post(postId: 3, username: "모모", title: "키체인 사세요", content: "딱 한번 착용한 새상품 입니다\n예뻐서 샀는데 안어울려서 내놓아요ㅜㅜ \n직거래 가능합니다 \n ", category: "여성의류", viewCount: 3, updated: "10일 전", address: "강서구 화곡동", price: 5_000, state: "done", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
  Post(postId: 4, username: "모모", title: "선글라스 옷사세요", content: "심플하게 착용할 수 있는 \n선글라스 입니다~ \n편하게 문의 주세요:)", category: "여성의류", viewCount: 1, updated: "1일 전", address: "강서구 화곡동", price: 100_000, state: "reserved", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
  Post(postId: 5, username: "모모", title: "향초 팔아요~", content: "사놓고 한번도 착용하지 않은 새 상품 입니다~ \n저렴하게 드릴께요 \n편하게 문의 주세요!!! \n신당 근처는 직거래 가능합니다 :)", category: "여성의류", viewCount: 1, updated: "일주일 전", address: "강서구 화곡동", price: 20_000, state: "sales", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
  Post(postId: 6, username: "모모", title: "모니터 사세요", content: "딱 한번 착용한 새상품 입니다\n예뻐서 샀는데 안어울려서 내놓아요ㅜㅜ \n직거래 가능합니다 \n ", category: "여성의류", viewCount: 6, updated: "10일 전", address: "강서구 화곡동", price: 5_000, state: "done", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)])
]

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
