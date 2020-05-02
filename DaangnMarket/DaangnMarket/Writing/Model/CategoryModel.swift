//
//  CategoryModel.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/05.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

enum DGCategory: String, CaseIterable {
  case digital, furniture, baby, life
  case womanWear = "woman_wear"
  case womanGoods = "woman_goods"
  case beauty, male, sports, game, book, pet, other, buy
  
  var korean: String {
    switch self {
    case .digital:
      return "디지털/가전"
    case .furniture:
      return "가구/인테리어"
    case .baby:
      return "유아동/유아도서"
    case .life:
      return "생활/가공식품"
    case .womanWear:
      return "여성의류"
    case .womanGoods:
      return "여상잡화"
    case .beauty:
      return "뷰티/미용"
    case .male:
      return "남성패션/잡화"
    case .sports:
      return "스포츠/레저"
    case .game:
      return "게임/취미"
    case .book:
      return "도서/티켓/음반"
    case .pet:
      return "반려동물용품"
    case .other:
      return "기타 중고물품"
    case .buy:
      return "삽니다"
    }
  }
}
