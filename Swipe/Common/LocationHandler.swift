//
//  LocationManager.swift
//  Swipe
//
//  Created by Guowei Mo on 23/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationHandlerOutput {
  func locationUpdated(to location: Location)
}

class LocationHandler: NSObject, CLLocationManagerDelegate {
  
  var manager: CLLocationManager?
  var latestLocation: Location?
  var lastUpdatedTime: Date?
  var output: LocationHandlerOutput?
  
  static let shared = LocationHandler()
  
  override init() {
    super.init()
    manager = CLLocationManager()
    manager?.delegate = self
    manager?.desiredAccuracy = kCLLocationAccuracyBest
    manager?.pausesLocationUpdatesAutomatically = false
  }
  
  func startUpdatingLocation() {
    let status = CLLocationManager.authorizationStatus()
    if status == .denied {
      return
    }
    else {
      manager?.requestAlwaysAuthorization()
    }
    manager?.startUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let lastLocation = locations.last {
      let latestLocation = Location(longitude: lastLocation.coordinate.longitude, latitude: lastLocation.coordinate.latitude)
      output?.locationUpdated(to: latestLocation)
    }
  }
  
  func currentLocation() -> Location? {
    guard let loc = manager!.location else { return nil }
    return Location(longitude: loc.coordinate.longitude, latitude: loc.coordinate.latitude)
  }
}

