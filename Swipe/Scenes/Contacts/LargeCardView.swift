//
//  ContactsSlideView.swift
//  Swipe
//
//  Created by Guowei Mo on 07/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class LargeCardView: UIView {

  @IBOutlet weak var profilePicView: UIImageView!
    
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    profilePicView.layer.cornerRadius = profilePicView.frame.height / 2
  }
}
