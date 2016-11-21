//
//  Locations.swift
//  Swipe
//
//  Created by Guowei Mo on 20/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit
import CoreLocation

class Locations: NSObject {
  static let shared = Locations()
  func isMyLocationInRange(withLocation location: Location) -> Bool {
    var inRange = false
    let loc1 = CLLocation(latitude: location.latitude, longitude: location.longitude)
    if let myLat = SWCard.myCard.location?.latitude,
      let myLong = SWCard.myCard.location?.longitude {
      let myLoc = CLLocation(latitude: myLat, longitude: myLong)
      let distance = myLoc.distance(from: loc1) // in meters
      if distance <= 50.0 {
        inRange = true
      }
    }
    return inRange
  }
}
