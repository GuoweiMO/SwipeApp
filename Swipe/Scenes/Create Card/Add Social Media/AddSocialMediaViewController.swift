//
//  AddUserInfoViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 17/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class AddSocialMediaViewController: UIViewController {
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  var bgImage: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    backgroundImageView.image = bgImage
  }
  
  @IBAction func doneButtonDidTap(_ sender: Any) {
    initHomeController()
    navigationController?.popToRootViewController(animated: false)
  }
  
  func initHomeController() {
    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as? HomeViewController
    {
      let userDefault = UserDefaults.standard
      userDefault.setValue(true, forKey: "hasCard")
      
      vc.profilePicView.image = bgImage
      present(vc, animated: false, completion: nil)
    }
  }
}
