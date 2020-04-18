//
//  User.swift
//  DaangnMarket
//
//  Created by Demian on 2020/03/26.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

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
  let postImageSet: [PostImage]
}

extension Post {
  enum CodingKeys: String, CodingKey {
    case postId = "id"
    case username, title, content, category
    case viewCount = "view_count"
    case updated, address, price, state
    case postImageSet = "post_images"
  }
}

struct PostImage: Codable {
  let imageId: Int
  let photo: String
  let postId: Int
}

extension PostImage {
  enum CodingKeys: String, CodingKey {
    case imageId = "id"
    case photo
    case postId = "post"
  }
}
