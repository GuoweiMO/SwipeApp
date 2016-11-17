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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    backgroundImageView.image = SWCard.myCard.largeProfileImage
  }
  
  @IBAction func doneButtonDidTap(_ sender: Any) {
    
    initHomeController()
  }
  
  func initHomeController() {
    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as? HomeViewController
    {
      let userDefault = UserDefaults.standard
      userDefault.setValue(true, forKey: "hasCard")
      
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  @IBAction func prevStepButtonDidTap(_ sender: Any) {
    _ = navigationController?.popViewController(animated: true)
  }

}
