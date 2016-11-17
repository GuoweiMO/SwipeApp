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

  static let myCard = SWCard()
  
  var largeProfileImage: UIImage?
  
  var fullName: String!
  var jobTitle: String!
  var employer: String!
  var email: String!
  var phone1: String!
  var phone2: String?
  var website: String?
  var status: CardStatus = .Normal
  var contacts = [String]()
  
  func dictInfo() -> [String: Any] {
    return [
            "fullName" : fullName,
            "jobTitle" : jobTitle,
            "employer" : employer,
            "email"    : email,
            "phone1"   : phone1,
            "phone2"   : phone2 ?? "",
            "website"  : website ?? "",
            "contacts" : contacts,
            "status"   : status.rawValue
    ]
    
  }
}
