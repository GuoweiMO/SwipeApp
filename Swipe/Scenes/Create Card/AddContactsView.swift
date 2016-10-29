//
//  AddUserInfoView.swift
//  Swipe
//
//  Created by Guowei Mo on 21/10/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

protocol AddContactsOutput {
  func didConfirmNavigateToHomeViewController()
  func didCancelNavigateBackToAddUserInfoView()
}

class AddContactsView: UIView, UITextFieldDelegate {
  
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var phoneField: UITextField!
  @IBOutlet weak var websiteLabel: UILabel!
  @IBOutlet weak var websiteField: UITextField!
  
  @IBOutlet weak var confirmBtn: SWButton!
  
  @IBOutlet weak var closeBtnTopConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var stepIndicatorTopConstraint: NSLayoutConstraint!
  
  var output: AddContactsOutput?
  
  class func viewFromNib() -> AddContactsView?
  {
    return Bundle.main.loadNibNamed("AddContactsView", owner: self, options: nil)?.first as? AddContactsView
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    confirmBtn.clearStyleWhiteBorder()
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    setLabel(of: textField, hide: false)
    stepIndicatorTopConstraint.constant = 20
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    setLabel(of: textField, hide: true)
    return true
  }
  
  func setLabel(of textField: UITextField, hide: Bool)
  {
    if textField == emailField
    {
      emailLabel.isHidden = hide
    }
    else if textField == phoneField
    {
      phoneLabel.isHidden = hide
    }
    else if textField == websiteField
    {
      websiteLabel.isHidden = hide
    }
  }
  
  @IBAction func infoTextChange(_ sender: UITextField) {
    guard let fText = emailField.text,
          let jText = phoneField.text,
          let cText = websiteField.text
    else {
      someFieldsNotFill()
      return
    }
    
    if !fText.isEmpty &&
       !jText.isEmpty &&
       !cText.isEmpty
    {
      allFieldsDidFill()
    }
    else {
      someFieldsNotFill()
    }
    
    if sender.text!.isEmpty
    {
      setLabel(of: sender, hide: true)
    }

  }
  
  func allFieldsDidFill() {
    confirmBtn.isHidden = false
    closeBtnTopConstraint.constant = 80
  }
  
  func someFieldsNotFill(){
    confirmBtn.isHidden = true
    closeBtnTopConstraint.constant = 20
  }
  
  @IBAction func closeBtnDidTap(_ sender: AnyObject) {
    output?.didCancelNavigateBackToAddUserInfoView()
    hideKeyboard()
  }
  
  @IBAction func confirmBtnDidTap(_ sender: AnyObject) {
    output?.didConfirmNavigateToHomeViewController()
    hideKeyboard()
  }
  
  func hideKeyboard() {
    if emailField.isFirstResponder
    {
      emailField.resignFirstResponder()
    }
    else if phoneField.isFirstResponder
    {
      phoneField.resignFirstResponder()
    }
    else if websiteField.isFirstResponder
    {
      websiteField.resignFirstResponder()
    }
  }

}
