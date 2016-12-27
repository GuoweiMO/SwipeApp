//
//  AddInfoViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 25/12/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class AddInfoViewController: UIViewController, UIScrollViewDelegate {

  @IBOutlet weak var containerView: UIScrollView!
  
  @IBOutlet weak var profileImageView: UIImageView!
  
  @IBOutlet weak var addUserInfoView: UIScrollView!
  @IBOutlet weak var addContactInfoView: UIScrollView!
  @IBOutlet weak var addSocialMediaView: UIView!
  
  @IBOutlet weak var userInfoView: InfoInputView!
  @IBOutlet weak var fullNameField: UITextField!
  @IBOutlet weak var jobTitleField: UITextField!
  @IBOutlet weak var companyField: UITextField!
  
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var jobTitleLabel: UILabel!
  @IBOutlet weak var companyLabel: UILabel!

  @IBOutlet weak var contactInfoView: InfoInputView!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var phone1Field: UITextField!
  @IBOutlet weak var phone2Field: UITextField!
  @IBOutlet weak var websiteField: UITextField!
  
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var phone1Label: UILabel!
  @IBOutlet weak var websiteLabel: UILabel!

  @IBOutlet weak var stepContainer: UIView!
  var stepBarView: StepBarView!
  
  @IBOutlet weak var fullNamePreviewLabel: UILabel!
  @IBOutlet weak var jobTitlePreviewLabel: UILabel!
  @IBOutlet weak var companyPreviewLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    profileImageView.image = SWCard.myCard.largeProfileImage
    
    setupInfoView()
    
    NotificationCenter.default.addObserver(self, selector: #selector(AddUserInfoViewController.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    
    stepBarView = StepBarView.viewfromNib()
    stepBarView.frame = stepContainer.bounds
    stepContainer.addSubview(stepBarView)
  }
  
  func setupInfoView(){
    userInfoView.textFields = [fullNameField, jobTitleField, companyField]
    userInfoView.labels = [fullNameLabel, jobTitleLabel,companyLabel]
    userInfoView.previewLabels = [fullNamePreviewLabel, jobTitlePreviewLabel, companyPreviewLabel]
    
    contactInfoView.textFields = [emailField, phone1Field, websiteField]
    contactInfoView.labels = [emailLabel, phone1Label,websiteLabel]
  }
  
  func keyboardWillShow(notification: NSNotification){
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      let keyboardHeight = keyboardSize.height
      addUserInfoView.contentSize.height = 568 + keyboardHeight
      addContactInfoView.contentSize.height = 568 + keyboardHeight
    }
  }
  
  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    addUserInfoView.endEditing(true)
    addContactInfoView.endEditing(true)
  }
  
  @IBAction func prevStepButtonDidTap(_ sender: Any) {
    _ = navigationController?.popViewController(animated: true)
  }
  
  @IBAction func doneButtonDidTap(_ sender: Any) {
    saveMyCardInfo()
    initHomeController()
  }
  
  func saveMyCardInfo() {
    Common.saveImage(image: SWCard.myCard.largeProfileImage!, toKeyPath: "largeImage")
    Actions.shared.createCard(withInfo: SWCard.myCard.dictInfo(), andCompletion: {
      error, dbRef in
      if error == nil {
        print("create my card succeeds")
        UserDefaults.standard.setValue(true, forKey: "hasCard")
      } else { }
    })

  }
  
  func initHomeController() {
    if let vc = mainStoryBoard.instantiateViewController(withIdentifier: "home") as? HomeViewController
    {
       present(vc, animated: false, completion: { })
    }
  }
  
}
