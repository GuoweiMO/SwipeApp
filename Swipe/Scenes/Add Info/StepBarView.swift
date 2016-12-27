//
//  StepBarView.swift
//  Swipe
//
//  Created by Guowei Mo on 27/12/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class StepBarView: UIView {

  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  class func viewfromNib() -> StepBarView?
  {
    return Bundle.main.loadNibNamed("StepBarView", owner: self, options: nil)?.first as? StepBarView
  }
  
}
