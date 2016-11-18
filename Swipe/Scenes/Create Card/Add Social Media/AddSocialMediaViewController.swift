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
    saveMyCardInfo()
    initHomeController()
  }
  
  func saveMyCardInfo() {
    Common.saveImage(image: SWCard.myCard.largeProfileImage!, toKeyPath: "largeImage")
    SWActions.createCard(withInfo: SWCard.myCard.dictInfo(), andCompletion: {
      error, dbRef in
      if error == nil {
        print("create my card succeeds")
        UserDefaults.standard.setValue(true, forKey: "hasCard")
      } else {
        
      }
    })
  }
  
  func initHomeController() {
    if let vc = mainStoryBoard.instantiateViewController(withIdentifier: "home") as? HomeViewController
    {
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  @IBAction func prevStepButtonDidTap(_ sender: Any) {
    _ = navigationController?.popViewController(animated: true)
  }

}
