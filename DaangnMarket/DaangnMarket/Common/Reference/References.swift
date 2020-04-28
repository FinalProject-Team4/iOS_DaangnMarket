//
//  References.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

enum ImageReference: String {
  case daangnMain = "DaangnImage_Main"
  case daangnAuth = "DaangnImage_Auth"
  case daangnLogo = "DaangnLogo"
  case arrowLeft = "arrow.left"
  case search = "magnifyingglass"
  case arrowChevronRight = "chevron.right"
  case searchNoResult = "doc.text.magnifyingglass"
  case xmark
  case keyboardDown = "keyboard.chevron.compact.down"
  case camera = "camera.fill"
  case profileDefault = "ProfileImage-Default"
  case trash
  case checkmark
  case noImage
  case pencil
  case daangni = "DaangnLogo-Noti-Daangni"
  case badge = "Badge"
  
  enum Notification: String {
    case daangnLogo = "DaangnLogo-Noti"
    case daangni = "DaangnLogo-Noti-Daangni"
    case priceDown = "DaangnLogo-Noti-Down"
  }
}

enum ColorReference: String {
  case daangnMain = "DaangnColor_Main"
  case item
  case borderLine = "BorderLine"
  case toastAlert = "ToastAlert"
  case upperAlert = "UpperAlert"
  case noResultImage = "NoResultImage"
  case navigationShadow = "NavigationShadow"
  case auth = "Auth"
  case inputText = "InputText"
  case subText = "SubText"
  case mannerTemperature = "MannerTemperature"
  case notiBackground = "NotiBackground"
  case lightBackground = "LightBackground"
  case backGray = "BackGray"
  case backLightGray = "BackLighGray"
  case reservedMark = "ReservedMark"
}

enum UserReference: String {
  case userInfo
  case firstTown
  case secondTown
  case firstTownByDistance
  case secondTownByDistance
}
