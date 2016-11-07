//
//  ViewButton.swift
//  Swipe
//
//  Created by Guowei Mo on 06/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class ViewModeButton: UIButton {
  
  override func draw(_ rect: CGRect) {
    layer.borderColor = UIColor.white.cgColor
    layer.borderWidth = 0
    layer.cornerRadius = frame.height / 2.0
  }
  
//  override var isHighlighted: Bool {
//    didSet {
//      if !isHighlighted {
//        layer.borderWidth = 0
//      }
//    }
//  }
}
