//
//  SWCircleButton.swift
//  Swipe
//
//  Created by Guowei Mo on 19/09/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class SWButton: UIButton {
  
  override func draw(_ rect: CGRect) {
    clipsToBounds = true
    layer.cornerRadius = bounds.height / 2.0
  }
  
  func whiteStyle()
  {
    backgroundColor = UIColor.white
    layer.borderWidth = 3.0
    layer.borderColor = Common.appRedColor().cgColor
  }
  
  func redStyle()
  {
    backgroundColor = Common.appRedColor()
    layer.borderWidth = 3.0
    layer.borderColor = UIColor.white.cgColor
  }
}
