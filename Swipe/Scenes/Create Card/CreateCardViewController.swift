//
//  CreateCardViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 16/09/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

protocol CreateCardDelegate {
  func createCardDidSucceed()
}

class CreateCardViewController: UIViewController,
                                AddProfilePicOutput,
                                ChangeProfilePicOutput,
                                AddUserInfoOutput,
                                AddContactsOutput {
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  var addProfilePicView: AddProfilePicView?
  var changeProfilePicView: ChangeProfilePicView?
  var addUserInfoView: AddUserInfoView?
  var addContactsView: AddContactsView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addProfilePicView = AddProfilePicView.viewFromNib()
    addProfilePicView?.output = self
    view.addSubview(addProfilePicView!)

    changeProfilePicView = ChangeProfilePicView.viewFromNib()
    changeProfilePicView?.output = self
    changeProfilePicView?.isHidden = true
    view.addSubview(changeProfilePicView!)
    
    addUserInfoView = AddUserInfoView.viewFromNib()
    addUserInfoView?.output = self
    addUserInfoView?.isHidden = true
    view.addSubview(addUserInfoView!)
    
    addContactsView = AddContactsView.viewFromNib()
    addContactsView?.output = self
    addContactsView?.isHidden = true
    view.addSubview(addContactsView!)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    addProfilePicView?.frame = view.bounds
    
    changeProfilePicView?.frame = CGRect(x: (view.bounds.width - 190.0) / 2, y: view.bounds.height - 145.0, width: 190.0, height: 120.0)
    
    addUserInfoView?.frame = view.bounds
    
    addContactsView?.frame = view.bounds
  }
  
  func present(imagePicker: UIImagePickerController) {
    present(imagePicker, animated: true, completion: nil)
  }
  
  func imagePicker(imagePicker: UIImagePickerController, didSelectImage image: UIImage) {
    backgroundImageView.contentMode = .scaleAspectFill
    backgroundImageView.image = image
    imagePicker.dismiss(animated: true, completion: nil)
    
    changeProfilePicView?.isHidden = false
    addProfilePicView?.isHidden = true
  }
  
  func navigateBackToAddProfileView() {
    addProfilePicView?.isHidden = false
    
    changeProfilePicView?.isHidden = true
    backgroundImageView.image = nil
    addUserInfoView?.isHidden = true
  }
  
  func navigateToUserInfoView() {
    addUserInfoView?.isHidden = false
    
    addProfilePicView?.isHidden = true
    changeProfilePicView?.isHidden = true
  }
  
  func navigateToChangeProfilePic() {
    changeProfilePicView?.isHidden = false

    addUserInfoView?.isHidden = true
    addProfilePicView?.isHidden = true
  }
  
  func navigateToAddContacts() {
    addContactsView?.isHidden = false
    
    changeProfilePicView?.isHidden = true
    addUserInfoView?.isHidden = true
    addProfilePicView?.isHidden = true
  }

  func navigateBackToAddUserInfoView() {
    addUserInfoView?.isHidden = false

    addContactsView?.isHidden = true
    changeProfilePicView?.isHidden = true
    addProfilePicView?.isHidden = true
  }
  
  func navigateToHomeViewController() {
    if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home") as? HomeViewController
    {
      present(vc, animated: false) {
        vc.profilePicView.image = self.backgroundImageView.image
        vc.fullNameLabel.text = self.addUserInfoView?.fullNameField.text
        vc.jobTitleLabel.text = self.addUserInfoView?.jobTitleField.text
        vc.workPlaceLabel.text = self.addUserInfoView?.companyField.text
      }
    }
  }
  
  func createCardDidSucceed() {
    if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home") as? HomeViewController
    {
      present(vc, animated: true) {}
    }
  }
}
