//
//  HomeViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 18/09/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var jobTitleLabel: UILabel!
  @IBOutlet weak var workPlaceLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    db.child("cards").child(uid!).observe(.value, with: { (snapshot) in
      if let dataDict = snapshot.value as? [String : AnyObject]
      {
        self.fullNameLabel.text = dataDict["fullName"] as? String
        self.jobTitleLabel.text = dataDict["jobTitle"] as? String
        self.workPlaceLabel.text = dataDict["employer"] as? String
      }
      }) { (err) in }
  }
}
