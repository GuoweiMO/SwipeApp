//
//  SWCircleButton.swift
//  Swipe
//
//  Created by Guowei Mo on 19/09/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class SWCircleButton: UIButton {
  
  override func draw(_ rect: CGRect) {
    clipsToBounds = true
    layer.cornerRadius = bounds.width / 2.0
    layer.borderWidth = 3.0
    layer.borderColor = UIColor.white.cgColor
  }

}
