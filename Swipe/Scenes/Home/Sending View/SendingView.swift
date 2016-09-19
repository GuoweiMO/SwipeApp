//
//  SendingView.swift
//  Swipe
//
//  Created by Guowei Mo on 19/09/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class SendingView: UIView {
  
  @IBOutlet weak var receiversView: UIView!
  @IBOutlet weak var receiverLabel: UILabel!
  
  class func viewfromNib() -> UIView?
  {
    return Bundle.main.loadNibNamed("SendingView", owner: self, options: nil)?.first as? SendingView
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
  }
  
  @IBAction func noButtonDidTap(_ sender: AnyObject) {
    superview?.sendSubview(toBack: self)
  }
}
