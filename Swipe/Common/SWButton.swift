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
    style(with: UIColor.white , border: Common.appRedColor().cgColor)

  }
  
  func redStyle()
  {
    style(with: Common.appRedColor(), border: UIColor.white.cgColor)
  }
  
  func whiteStyleNoBorder()
  {
    style(with: UIColor.white, border: UIColor.clear.cgColor)
  }
  
  func clearStyleWhiteBorder()
  {
    style(with: UIColor.clear, border: UIColor.white.cgColor)
  }
  
  func style(with bgColor: UIColor, border: CGColor)
  {
    backgroundColor = bgColor
    layer.borderWidth = 2.0
    layer.borderColor = border
  }
}
