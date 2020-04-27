//
//  User.swift
//  DaangnMarket
//
//  Created by Demian on 2020/03/26.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation
// MARK: PostInfo

struct PostInfo: Codable {
  let count: Int
  let next: String?
  let previous: String?
  let results: [Post]
  
  init() {
    self.count = 0
    self.next = nil
    self.previous = nil
    self.results = []
  }
}

// MARK: Post

struct Post: Codable {
  let postId: Int
  let username: String
  let title: String
  let content: String
  let category: String
  let viewCount: Int
  let updated: String
  let address: String
  let price: Int
  let state: String
  let photos: [String]
}

// MARK: Extention Post

extension Post {
  enum CodingKeys: String, CodingKey {
    case postId = "id"
    case username, title, content, category
    case viewCount = "view_count"
//    case updated, price, state
    case updated, address, price, state
    case photos
  }
}

//// MARK: PostImage
//
//struct PostImage: Codable {
//  let imageId: Int
//  let photo: String
//  let postId: Int
//}

// MARK: Extention Post

//extension PostImage {
//  enum CodingKeys: String, CodingKey {
//    case imageId = "id"
//    case photo
//    case postId = "post"
//  }
//}
