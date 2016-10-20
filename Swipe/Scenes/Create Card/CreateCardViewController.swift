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

class CreateCardViewController: UIViewController, AddProfilePicOutput, ChangeProfilePicOutput {
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  var addProfilePicView: AddProfilePicView?
  var changeProfilePicView: ChangeProfilePicView?
  override func viewDidLoad() {
    super.viewDidLoad()
    addProfilePicView = AddProfilePicView.viewFromNib()
    addProfilePicView?.output = self
    
    changeProfilePicView = ChangeProfilePicView.viewFromNib()
    changeProfilePicView?.output = self
    
    changeProfilePicView?.isHidden = true
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    addProfilePicView!.frame = view.bounds
    view.addSubview(addProfilePicView!)
    
    changeProfilePicView?.frame = CGRect(x: (view.bounds.width - 190.0) / 2, y: view.bounds.height - 145.0, width: 190.0, height: 120.0)
    view.addSubview(changeProfilePicView!)
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
  }
  
  func createCardDidSucceed() {
    if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home") as? HomeViewController
    {
      present(vc, animated: true) {}
    }
  }
}
