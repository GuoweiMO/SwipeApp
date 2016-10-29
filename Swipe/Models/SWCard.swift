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

class SWCard {

  var fullName: String!
  var jobTitle: String!
  var employer: String!
  var email: String!
  var mobile: String?
  var website: String?
  var status: CardStatus = .Normal
  
  func dictInfo() -> [String: String] {
    return [
            "fullName" : fullName,
            "jobTitle" : jobTitle,
            "employer" : employer,
            "email"    : email,
            "mobile"   : mobile ?? "",
            "website"  : website ?? "",
            "status"   : status.rawValue
    ]
    
  }
}
