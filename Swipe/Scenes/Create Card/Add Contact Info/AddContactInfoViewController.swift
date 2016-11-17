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
  
  var bgImage: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    backgroundImageView.image = bgImage
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? AddUserInfoViewController,
      segue.identifier == "add social media" {
      vc.bgImage = bgImage
    }
    
  }

}
