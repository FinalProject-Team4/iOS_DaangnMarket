//
//  NotificationModel.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/12.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

class NotificationModel {
  // MARK: Notification
  
  static let didResponseActivityNotification = Notification.Name(rawValue: "didResponseActivityNotification")
  
  // MARK: Data
  
  var notifications = [ActivityNoti]() {
    didSet {
      NotificationCenter.default.post(
        name: NotificationModel.didResponseActivityNotification,
        object: nil,
        userInfo: nil
      )
    }
  }
  
  var userInfo: UserInfo
  var nextURL: String?
  
  // MARK: Life Cycle
  
  init(userInfo: UserInfo) {
    self.userInfo = userInfo
    self.requestActivityNoti()
  }
  
  func requestActivityNoti(completion: (() -> Void)? = nil) {
    API.default.requestActivityNoti(token: self.userInfo.authorization) { (result) in
      switch result {
      case .success(let notiInfo):
        self.nextURL = notiInfo.next
        self.notifications = notiInfo.results.map { self.parseCreatedDate(from: $0) }
      case .failure(let error):
        self.notifications = []
        print(error)
      }
      completion?()
    }
  }
  
  private func parseCreatedDate(from noti: ActivityNoti) -> ActivityNoti {
    let dateAndTime = noti.created.components(separatedBy: ".").first ?? ""
    let formmedDate = dateAndTime.replacingOccurrences(of: "T", with: " ")
    let newNoti = ActivityNoti(sender: noti.sender, receiver: noti.receiver, title: noti.title, body: noti.body, created: formmedDate)
    return newNoti
  }
  
  func requestNextActivityNoti() {
    guard let nextURL = self.nextURL else { return }
    API.default.requestNextActivityNoti(nextURL: nextURL, token: self.userInfo.authorization) { (result) in
      switch result {
      case .success(let notiInfo):
        self.nextURL = notiInfo.next
        self.notifications += notiInfo.results
      case .failure(let error):
        return print(error.localizedDescription)
      }
    }
  }
  
  var contents = [
    "👀 낙성대동 이웃을 사로잡은 금주의 인기매물, 지금 만 나보세요!하하하하하하하하하",
    "💌 2020년 4월 당근 가계부가 도착했습니다!",
    "내가 관심을 보인 \"맥북프로 16인치 팝니다\" 가격이 4,000,000원에서 4,000원으로 내려갔습니다.",
    "cskim님, 낙성대동 근처에서 최근 일주일 동안 29454.0개의 물품이 올라왔어요. 지금 앱을 켜서 확인해보세요!"
  ]
  
  var thumbnails: [ImageReference.Notification] = [
    .daangnLogo,
    .daangnLogo,
    .priceDown,
    .daangni
  ]
  
  var keywordContents = [
    "[기타 키워드 알림] 방배본동 - \"Taylor rlxk ahepff 712\"",
    "[기타 키워드 알림] 서초3동 - \"Dame 입문용기타+부속품\"",
    "[기타 키워드 알림] 노량진동 - \"(가격인하) 스윙 서태지 밴드 탑 시그니처 일렉기타\"",
    "[기타 키워드 알릶] 서초3동 - \"입문용 기타 Damee 기타 릴리즈70+부속품 A급\""
  ]
  
  func removeContent(at index: Int) {
//    self.contents.remove(at: index)
    self.notifications.remove(at: index)
    self.thumbnails.remove(at: index)
  }
}
