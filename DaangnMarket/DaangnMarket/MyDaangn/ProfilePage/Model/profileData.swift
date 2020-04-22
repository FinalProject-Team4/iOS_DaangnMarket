//
//  profileData.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/22.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

let sellerItemsData: [Post] = [
  Post(postId: 1, username: "모모", title: "선글라스 옷사세요", content: "심플하게 착용할 수 있는 \n선글라스 입니다~ \n편하게 문의 주세요:)", category: "여성의류", viewCount: 0, updated: "1일 전", address: "강서구 화곡동", price: 100_000, state: "sales", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),

  Post(postId: 2, username: "모모", title: "향초 팔아요~", content: "사놓고 한번도 착용하지 않은 새 상품 입니다~ \n저렴하게 드릴께요 \n편하게 문의 주세요!!! \n신당 근처는 직거래 가능합니다 :)", category: "여성의류", viewCount: 0, updated: "일주일 전", address: "강서구 화곡동", price: 20_000, state: "sales", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
  Post(postId: 3, username: "모모", title: "키체인 사세요", content: "딱 한번 착용한 새상품 입니다\n예뻐서 샀는데 안어울려서 내놓아요ㅜㅜ \n직거래 가능합니다 \n ", category: "여성의류", viewCount: 0, updated: "10일 전", address: "강서구 화곡동", price: 5_000, state: "done", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
  Post(postId: 4, username: "모모", title: "선글라스 옷사세요", content: "심플하게 착용할 수 있는 \n선글라스 입니다~ \n편하게 문의 주세요:)", category: "여성의류", viewCount: 0, updated: "1일 전", address: "강서구 화곡동", price: 100_000, state: "sales", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
  Post(postId: 5, username: "모모", title: "향초 팔아요~", content: "사놓고 한번도 착용하지 않은 새 상품 입니다~ \n저렴하게 드릴께요 \n편하게 문의 주세요!!! \n신당 근처는 직거래 가능합니다 :)", category: "여성의류", viewCount: 0, updated: "일주일 전", address: "강서구 화곡동", price: 20_000, state: "sales", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
  Post(postId: 6, username: "모모", title: "모니터 사세요", content: "딱 한번 착용한 새상품 입니다\n예뻐서 샀는데 안어울려서 내놓아요ㅜㅜ \n직거래 가능합니다 \n ", category: "여성의류", viewCount: 0, updated: "10일 전", address: "강서구 화곡동", price: 5_000, state: "done", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)])
]

let userItemsData: [Post] = [
  Post(postId: 1, username: "라이언", title: "옷옷 옷사세요", content: "간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)", category: "여성의류", viewCount: 0, updated: "1일 전", address: "강서구 화곡동", price: 10_000, state: "sales", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
  Post(postId: 40, username: "라이언", title: "가방가방 가방사세요", content: "사놓고 한번도 착용하지 않은 새 상품 입니다~ \n저렴하게 드릴께요 \n편하게 문의 주세요!!! \n신당 근처는 직거래 가능합니다 :)", category: "여성의류", viewCount: 0, updated: "일주일 전", address: "강서구 화곡동", price: 20_000, state: "done", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
  Post(postId: 1, username: "라이언", title: "옷옷 옷사세요", content: "간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)", category: "여성의류", viewCount: 0, updated: "1일 전", address: "강서구 화곡동", price: 10_000, state: "sales", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
  Post(postId: 40, username: "라이언", title: "가방가방 가방사세요", content: "사놓고 한번도 착용하지 않은 새 상품 입니다~ \n저렴하게 드릴께요 \n편하게 문의 주세요!!! \n신당 근처는 직거래 가능합니다 :)", category: "여성의류", viewCount: 0, updated: "일주일 전", address: "강서구 화곡동", price: 20_000, state: "sales", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)])
]

let dummyItemData: [Post] = [
  Post(postId: 1, username: "라이언", title: "옷옷 옷사세요", content: "간절기에 가볍고 따뜻하게 입을 수 있는 \n가디건 입니다~ \n편하게 문의 주세요:)", category: "여성의류", viewCount: 0, updated: "1일 전", address: "강서구 화곡동", price: 10_000, state: "sales", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
  Post(postId: 40, username: "라이언", title: "가방가방 가방사세요", content: "사놓고 한번도 착용하지 않은 새 상품 입니다~ \n저렴하게 드릴께요 \n편하게 문의 주세요!!! \n신당 근처는 직거래 가능합니다 :)", category: "여성의류", viewCount: 0, updated: "일주일 전", address: "강서구 화곡동", price: 20_000, state: "sales", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)]),
  Post(postId: 45, username: "라이언", title: "벙거지모자 사세요", content: "딱 한번 착용한 새상품 입니다\n예뻐서 샀는데 안어울려서 내놓아요ㅜㅜ \n직거래 가능합니다 \n ", category: "여성의류", viewCount: 0, updated: "10일 전", address: "강서구 화곡동", price: 5_000, state: "done", postImageSet: [DaangnMarket.PostImage(imageId: 1, photo: "image3", postId: 1), DaangnMarket.PostImage(imageId: 2, photo: "image5", postId: 1), DaangnMarket.PostImage(imageId: 3, photo: "image2", postId: 1)])
]


class UserInform {
  static let shared = UserInform()
  
  private init() {}
  
  var username: String = "라이언"
}

