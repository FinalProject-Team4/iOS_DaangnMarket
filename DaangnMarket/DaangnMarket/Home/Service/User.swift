//
//  User.swift
//  DaangnMarket
//
//  Created by Demian on 2020/03/26.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

//let jsonData = """
//{
//    "count": 12,
//    "next": null,
//    "previous": "http://13.125.217.34/post/list/",
//    "results": [
//        {
//            "id": 2,
//            "username": "admin",
//            "title": "Hello",
//            "content": "World",
//            "category": "digital",
//            "view_count": 9,
//            "updated": "2020-03-23T18:52:52.603273+09:00",
//            "postimage_set": [
//                {
//                    "id": 3,
//                    "photo": "http://13.125.217.34/media/images/fabinho1.png",
//                    "post": 2
//                },
//                {
//                    "id": 4,
//                    "photo": "http://13.125.217.34/media/images/fabinho2.jpg",
//                    "post": 2
//                },
//                {
//                    "id": 5,
//                    "photo": "http://13.125.217.34/media/images/fabinho1.png",
//                    "post": 2
//                },
//                {
//                    "id": 6,
//                    "photo": "http://13.125.217.34/media/images/fabinho2.jpg",
//                    "post": 2
//                },
//                {
//                    "id": 7,
//                    "photo": "http://13.125.217.34/media/images/fabinho1_qDfgyxE.png",
//                    "post": 2
//                },
//                {
//                    "id": 8,
//                    "photo": "http://13.125.217.34/media/images/fabinho2_ZCvk42i.jpg",
//                    "post": 2
//                }
//            ]
//        }
//    ]
//}
//""".data(using: .utf8)!

let jsonData = """
{
    "count": 5,
    "next": null,
    "previous": null,
    "results": [
        {
            "id": 5,
            "username": "admin",
            "title": "맥북 16인치 사고싶습니",
            "content": "CTO 풀로 땡겨서!!",
            "category": "digital",
            "view_count": 0,
            "updated": "2020-04-02T14:26:46.191134+09:00",
            "address": "상도1동",
            "price": 10000,
            "state": "sales",
            "postimage_set": []
        },
        {
            "id": 4,
            "username": "admin",
            "title": "아이패드 미니5 팔아요",
            "content": "아이패드와 맥이랑 연결했을때 정말 좋아",
            "category": "digital",
            "view_count": 0,
            "updated": "2020-04-02T14:25:58.558771+09:00",
            "address": "상도1동",
            "price": 10000,
            "state": "sales",
            "postimage_set": []
        },
        {
            "id": 3,
            "username": "admin",
            "title": "아이패드 미니5 팔아요",
            "content": "아이패드와 맥이랑 연결했을때 정말 좋아",
            "category": "digital",
            "view_count": 0,
            "updated": "2020-04-02T14:25:36.219894+09:00",
            "address": "상도1동",
            "price": 10000,
            "state": "sales",
            "postimage_set": []
        },
        {
            "id": 2,
            "username": "admin",
            "title": "아이패드 미니5 팔아요",
            "content": "아이패드와 맥이랑 연결했을때 정말 좋아",
            "category": "digital",
            "view_count": 1,
            "updated": "2020-04-02T14:09:47.141388+09:00",
            "address": "상도1동",
            "price": 10000,
            "state": "sales",
            "postimage_set": [
                {
                    "id": 1,
                    "photo": "http://13.125.217.34/media/images/fabinho1.png",
                    "post": 2
                },
                {
                    "id": 2,
                    "photo": "http://13.125.217.34/media/images/fabinho2.jpg",
                    "post": 2
                }
            ]
        },
        {
            "id": 1,
            "username": "admin",
            "title": "아이패드 미니5 팔아요",
            "content": "아이패드와 맥이랑 연결했을때 정말 좋아",
            "category": "digital",
            "view_count": 0,
            "updated": "2020-04-02T14:06:01.168217+09:00",
            "address": "상도1동",
            "price": 10000,
            "state": "sales",
            "postimage_set": []
        }
    ]
}
""".data(using: .utf8)!

struct PostImageSet: Decodable {
  let id: Int
  let photo: String
}

struct PostsInfo: Decodable {
  let results: [Results]
}

struct Results: Decodable {
  let userId: Int
  let username: String
  let title: String
  let viewCount: Int
  let price: Int
  let address: String
  let updated: String
  let postImageSet: [PostImageSet]


private enum CodingKeys: String, CodingKey {
  case userId = "id"
  case username, title, updated, price, address
  case postImageSet = "postimage_set"
  case viewCount = "view_count"
}
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.userId = try container.decode(Int.self, forKey: .userId)
    self.username = try container.decode(String.self, forKey: .username)
    self.title = try container.decode(String.self, forKey: .title)
    self.postImageSet = try container.decode([PostImageSet].self, forKey: .postImageSet)
    self.viewCount = try container.decode(Int.self, forKey: .viewCount)
    self.updated = try container.decode(String.self, forKey: .updated)
    self.price = try container.decode(Int.self, forKey: .price)
    self.address = try container.decode(String.self, forKey: .address)
  }
}

func dummyData() {
  do {
    let temp = try JSONDecoder().decode(PostsInfo.self, from: jsonData)
    dump(temp)
  } catch {
    print(error.localizedDescription)
  }
}
