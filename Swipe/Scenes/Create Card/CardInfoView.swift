//
//  CardInfoView.swift
//  Swipe
//
//  Created by Guowei Mo on 16/09/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class CardInfoView: UIView {
  
  @IBOutlet weak var firstNameField: UITextField!
  @IBOutlet weak var lastNameField: UITextField!
  @IBOutlet weak var jobTitleField: UITextField!
  @IBOutlet weak var workPlaceField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var mobileField: UITextField!
  @IBOutlet weak var websiteField: UITextField!
  
  var delegate: CreateCardDelegate?
  
  class func viewFromNib() -> UIView?
  {
    return Bundle.main.loadNibNamed("CardInfoView", owner: self, options: nil)?.first as? UIView
  }
  
  @IBAction func createCardBtnDidTap(_ sender: AnyObject) {
    //verify the form filling
    let newCard = [
      "fullName": "\(firstNameField.text!) \(lastNameField.text!)",
      "jobTitle": jobTitleField.text!,
      "employer" : workPlaceField.text!,
      "email"   : emailField.text!,
      "mobile"  : mobileField.text!,
      "website" : websiteField.text!
    ] as [String : String]
    //db.child("cards").child(uid!).setValue(newCard)
    
    delegate?.createCardDidSucceed()
  }
}
