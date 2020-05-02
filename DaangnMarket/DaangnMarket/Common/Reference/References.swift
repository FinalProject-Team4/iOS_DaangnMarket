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
  case scope = "Scope-1"
  
  enum Notification: String {
    case daangnLogo = "DaangnLogo-Noti"
    case daangni = "DaangnLogo-Noti-Daangni"
    case priceDown = "DaangnLogo-Noti-Down"
  }
  
  enum Chatting: String {
    case more = "plus"
    case menu = "menu"
    case calendar = "calendar"
    case enabledSend = "send_enabled"
    case disabledSend = "send_disabled"
    case emoticon = "emoticon"
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
  case lightBackground = "LightBackGround"
  case backGray = "BackGray"
  case backLightGray = "BackLighGray"
  case reservedMark = "ReservedMark"
  case warning = "Warning"
  
  enum Chatting: String {
    case inputFieldBackground = "InputFieldBackground"
    case borderLine = "ChatBorder"
    case otherMessageBackground = "MessageBackground_Other"
  }
}

enum UserReference: String {
  case userInfo
  case firstTown
  case secondTown
  case firstTownByDistance
  case secondTownByDistance
}
