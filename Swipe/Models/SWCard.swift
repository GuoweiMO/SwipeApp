//
//  SWCard.swift
//  Swipe
//
//  Created by Guowei Mo on 16/09/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

enum CardStatus: String {
  case Normal
  case Sending
  case Receiving
  case Error
}

class SWCard: NSObject {

  static let myCard = SWCard()
  
  var largeProfileImage: UIImage?
  var smallProfileImage: UIImage?
  
  var uid: String?
  var fullName: String!
  var jobTitle: String!
  var employer: String!
  var email: String!
  var phone1: String!
  var phone2: String?
  var website: String?
  var status: CardStatus = .Normal
  var contacts = [String]()
  var location: Location?
  var likes = [String]()
  
  func dictInfo() -> [String: Any] {
    var dict: [String: Any] = [:]
    dict["fullName"] = fullName
    dict["jobTitle"] = jobTitle
    dict["employer"] = employer
    dict["email"]    = email
    dict["phone1"]   = phone1
    dict["phone2"]   = phone2 ?? ""
    dict["website"]  = website ?? ""
    dict["contacts"] = contacts
    dict["status"]   = status.rawValue
    dict["likes"] = likes
    return dict
  }
  
  func updateCard(withFullData data: [String: Any]) {
    fullName = data["fullName"] as? String
    jobTitle = data["jobTitle"] as? String
    employer = data["employer"] as? String
    email    = data["email"] as? String
    phone1   = data["phone1"] as? String
    phone2   = data["phone2"] as? String
    website  = data["website"] as? String
    contacts = data["contacts"] as? [String] ?? []
    likes    = data["likes"] as? [String] ?? []
    if let loc = data["location"] as? String {
      let locStrs = loc.components(separatedBy: ",")
      if locStrs.count == 2 {
        location = Location(longitude: Double(locStrs[0])!, latitude: Double(locStrs[1])!)
      }
    }
  }
}

struct Location {
  var longitude: Double
  var latitude: Double
  func toString() -> String {
    return "\(longitude),\(latitude)"
  }
}
