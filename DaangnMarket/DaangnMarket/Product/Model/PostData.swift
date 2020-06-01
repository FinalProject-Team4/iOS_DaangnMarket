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
  
  let numberFormatter = NumberFormatter()
  
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
  
  func addressFilter(address: String) -> String {
    var result = String()
   if address != "None" {
     result = address.components(separatedBy: "구 ")[1]
     print()
   } else {
     result = "패캠동"
   }
   return result
  }
}
  
