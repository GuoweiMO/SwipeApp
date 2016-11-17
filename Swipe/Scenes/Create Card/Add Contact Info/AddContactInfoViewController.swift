//
//  AddUserInfoViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 17/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class AddContactInfoViewController: UIViewController {
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var phone1Field: UITextField!
  @IBOutlet weak var phone2Field: UITextField!
  @IBOutlet weak var websiteField: UITextField!
  
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var phone1Label: UILabel!
  @IBOutlet weak var websiteLabel: UILabel!
  
  @IBOutlet weak var infoInputView: InfoInputView!

  @IBOutlet weak var phone2BaseLine: UIView!
  
  @IBOutlet weak var websiteLabelTopConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    backgroundImageView.image = SWCard.myCard.largeProfileImage
    websiteLabelTopConstraint.constant = 8
    setupInfoView()
  }
  
  func setupInfoView(){
    infoInputView.textFields = [emailField, phone1Field, websiteField]
    infoInputView.labels = [emailLabel, phone1Label,websiteLabel]
  }
  
  @IBAction func addPhoneButtonDidTap(_ sender: UIButton) {
    if sender.currentTitle == "+" {
      sender.setTitle("-", for: .normal)
      websiteLabelTopConstraint.constant = 50
      phone2Field.isHidden = false
      phone2BaseLine.isHidden = false
    } else {
      sender.setTitle("+", for: .normal)
      websiteLabelTopConstraint.constant = 8
      phone2Field.isHidden = true
      phone2BaseLine.isHidden = true
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    SWCard.myCard.email = emailField.text ?? ""
    SWCard.myCard.phone1 = phone1Field.text ?? ""
    SWCard.myCard.phone2 = phone2Field.text ?? ""
    SWCard.myCard.website = websiteField.text ?? ""
  }
  
  @IBAction func prevStepButtonDidTap(_ sender: Any) {
    _ = navigationController?.popViewController(animated: true)
  }
  
}
