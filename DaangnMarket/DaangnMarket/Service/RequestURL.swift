//
//  RequestURL.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/24.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation
import Alamofire

enum RequestType {
  case address(Parameters)
  case gps(Parameters)
  case distance(Parameters)
  
  var request: DataRequest {
    let host = "http://54.180.114.238/"
    
    switch self {
    case .address(let parameters):
      return AF.request(host + "location/locate/search/", parameters: parameters)
    case .gps(let parameters):
      return AF.request(host + "location/locate/gps/", parameters: parameters)
    case .distance(let parameters):
      return AF.request(host + "location/locate/", parameters: parameters)
    }
  }
}
