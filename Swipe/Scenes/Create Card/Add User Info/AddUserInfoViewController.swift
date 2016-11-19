//
//  AddUserInfoViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 17/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class AddUserInfoViewController: UIViewController {
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  @IBOutlet weak var fullNameField: UITextField!
  @IBOutlet weak var jobTitleField: UITextField!
  @IBOutlet weak var companyField: UITextField!
  
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var jobTitleLabel: UILabel!
  @IBOutlet weak var companyLabel: UILabel!
  
  @IBOutlet weak var infoInputView: InfoInputView!
  
  @IBOutlet weak var labelVerticalCenterConstraint: NSLayoutConstraint!
  @IBOutlet weak var stepButtonBottomConstraint: NSLayoutConstraint!

  
  override func viewDidLoad() {
    super.viewDidLoad()
    backgroundImageView.image = SWCard.myCard.largeProfileImage
    setupInfoView()
    NotificationCenter.default.addObserver(self, selector: #selector(AddUserInfoViewController.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    SWCard.myCard.fullName = fullNameField.text ?? ""
    SWCard.myCard.jobTitle = jobTitleField.text ?? ""
    SWCard.myCard.employer = companyField.text ?? ""
  }
  
  func setupInfoView(){
    infoInputView.textFields = [fullNameField, jobTitleField, companyField]
    infoInputView.labels = [fullNameLabel, jobTitleLabel,companyLabel]
  }
  
  func keyboardWillShow(notification:NSNotification){
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        let keyboardHeight = keyboardSize.height
        labelVerticalCenterConstraint.constant = -100
        stepButtonBottomConstraint.constant = keyboardHeight + 10
    }
  }
  
  @IBAction func previousButtonDidTap(_ sender: Any) {
    _ = navigationController?.popViewController(animated: true)
  }
}
