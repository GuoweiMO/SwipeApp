//
//  AddUserInfoView.swift
//  Swipe
//
//  Created by Guowei Mo on 21/10/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit
protocol AddUserInfoOutput: class {
  func didConfirmNavigateToAddContacts()
  func didCancelNavigateToChangeProfilePic()
}

class AddUserInfoView: UIView, UITextFieldDelegate {
  
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var fullNameField: UITextField!
  @IBOutlet weak var jobTitleLabel: UILabel!
  @IBOutlet weak var jobTitleField: UITextField!
  @IBOutlet weak var companyLabel: UILabel!
  @IBOutlet weak var companyField: UITextField!
  
  @IBOutlet weak var confirmBtn: SWButton!
  
  @IBOutlet weak var closeBtnTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var stepIndicatorTopConstraint: NSLayoutConstraint!
  
  weak var output: AddUserInfoOutput?
  
  class func viewFromNib() -> AddUserInfoView?
  {
    return Bundle.main.loadNibNamed("AddUserInfoView", owner: self, options: nil)?.first as? AddUserInfoView
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    confirmBtn.clearStyleWhiteBorder()
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    setLabel(of: textField, hide: false)
    stepIndicatorTopConstraint.constant = 20
  }
  
  func keyboardWillShow(notification:NSNotification){
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//      let keyboardHeight = keyboardSize.height
//      if UIScreen.main.bounds.height <= 667 {
//        stepIndicatorTopConstraint.constant = 140 - keyboardHeight
//      }
    }

  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    confirmBtnDidTap(textField)
    return true
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    setLabel(of: textField, hide: true)
    return true
  }
  
  func setLabel(of textField: UITextField, hide: Bool)
  {
    if textField == fullNameField
    {
      fullNameLabel.isHidden = hide
    }
    else if textField == jobTitleField
    {
      jobTitleLabel.isHidden = hide
    }
    else if textField == companyField
    {
      companyLabel.isHidden = hide
    }
  }
  
  @IBAction func infoTextChange(_ sender: UITextField) {
    guard let fText = fullNameField.text,
          let jText = jobTitleField.text,
          let cText = companyField.text
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
    output?.didCancelNavigateToChangeProfilePic()
    hideKeyboard()
  }
  
  @IBAction func confirmBtnDidTap(_ sender: AnyObject) {
    output?.didConfirmNavigateToAddContacts()
    hideKeyboard()
  }
  
  func hideKeyboard() {
    if fullNameField.isFirstResponder
    {
      fullNameField.resignFirstResponder()
    }
    else if jobTitleField.isFirstResponder
    {
      jobTitleField.resignFirstResponder()
    }
    else if companyField.isFirstResponder
    {
      companyField.resignFirstResponder()
    }
  }
}
