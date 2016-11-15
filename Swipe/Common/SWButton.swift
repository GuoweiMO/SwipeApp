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
  
  func whiteStyle() {
    style(withBGColor: UIColor.white , borderColor: Common.appRedColor().cgColor)
  }
  
  func redStyle() {
    style(withBGColor: Common.appRedColor(), borderColor: UIColor.white.cgColor)
  }
  
  func whiteStyleNoBorder() {
    style(withBGColor: UIColor.white, borderColor: UIColor.clear.cgColor)
  }
  
  func clearStyleWhiteBorder() {
    style(withBGColor: UIColor.clear, borderColor: UIColor.white.cgColor)
  }
  
  func style(withBGColor bgColor: UIColor, borderColor: CGColor) {
    backgroundColor = bgColor
    layer.borderWidth = 2.0
    layer.borderColor = borderColor
  }
}

class SWButton1: SWButton {
  var btnSelected = false
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    btnSelected = false
    clearStyleWhiteBorder()
  }
  
  func selectedStyle() {
    btnSelected = true
    setTitleColor(Common.appRedColor(), for: .normal)
    layer.borderColor = Common.appRedColor().cgColor
  }
  
  func defaultStyle() {
    btnSelected = false
    clearStyleWhiteBorder()
  }
  
  func disabledStyle() {
    isEnabled = false
    alpha = 0.5
  }
}
