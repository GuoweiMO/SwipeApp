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
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var jobTitleLabel: UILabel!
  @IBOutlet weak var workplaceLabel: UILabel!
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    profilePicView?.layer.cornerRadius = (profilePicView?.frame.height ?? 0) / 2
  }
  
  func updateView(withCard card: SWCard){
    fullNameLabel.text = card.fullName
    jobTitleLabel.text = card.jobTitle
    workplaceLabel.text = card.employer
  }
}
