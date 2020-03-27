//
//  LocationManager.swift
//  DaangnMarket
//
//  Created by cskim on 2020/03/25.
//  Copyright © 2020 Jisng. All rights reserved.
//

import CoreLocation

protocol LocationManagerDelegate: class {
  typealias Location = CLLocation
  func locationManager(_ manager: LocationManager, didReceiveLocation location: Location)
}

class LocationManager: NSObject {
  // MARK: Properties
  private let manager = CLLocationManager()
  private var latestUpdateDate = Date(timeIntervalSinceNow: -10)
  weak var delegate: LocationManagerDelegate?
  
  // MARK: Initialize
  
  override init() {
    super.init()
    self.manager.delegate = self
    self.checkAuthorization()
  }
  
  private func checkAuthorization() {
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined:
      self.manager.requestWhenInUseAuthorization()
    default:
      return
    }
  }
  
  // MARK: Interface
  
  func startUpdatingLocation() {
    self.manager.startUpdatingLocation()
  }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      self.manager.startUpdatingLocation()
    default:
      return
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    self.manager.stopUpdatingLocation()
    
    if abs(self.latestUpdateDate.timeIntervalSince(location.timestamp)) > 2 {
      self.delegate?.locationManager(self, didReceiveLocation: location)
      self.latestUpdateDate = location.timestamp
    }
  }
}
