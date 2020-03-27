//
//  User.swift
//  DaangnMarket
//
//  Created by Demian on 2020/03/26.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

let jsonData = """

  {
    "id": 6,
    "username": "admin",
    "title": "Hello",
    "content": "World",
    "category": "digital",
    "view_count": 0,
    "updated": "2020-03-26T12:03:35.543563+09:00",
    "postimage_set": [
        {
          "id": 3,
          "photo": "http://13.125.217.34/media/images/fabinho1.png",
          "post": 2
        },
        {
          "id": 4,
          "photo": "http://13.125.217.34/media/images/fabinho2.jpg",
          "post": 2
        },
        {
          "id": 5,
          "photo": "http://13.125.217.34/media/images/fabinho1.png",
          "post": 2
        },
        {
          "id": 6,
          "photo": "http://13.125.217.34/media/images/fabinho2.jpg",
          "post": 2
        }
    ]
  }

""".data(using: .utf8)!

struct PostImageSet: Decodable {
  let id: Int
  let photo: String
}

struct User: Decodable {
  let id: Int
  let username: String
  let title: String
  let updated: String
  let postImageSet: [PostImageSet]


private enum CodingKeys: String, CodingKey {
  case id, username, title, updated
  case postImageSet = "postimage_set"
}
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int.self, forKey: .id)
    self.username = try container.decode(String.self, forKey: .username)
    self.title = try container.decode(String.self, forKey: .title)
    self.postImageSet = try container.decode([PostImageSet].self, forKey: .postImageSet)
    self.updated = try container.decode(String.self, forKey: .updated)
  }
}

//func dummyData() {
//  do {
//    let temp = try JSONDecoder().decode(User.self, from: jsonData)
//    dump(temp)
//  } catch {
//    print(error.localizedDescription)
//  }
//}
