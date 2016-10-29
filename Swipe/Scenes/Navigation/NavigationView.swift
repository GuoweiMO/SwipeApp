//
//  NavigationView.swift
//  Swipe
//
//  Created by Guowei Mo on 29/10/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class NavigationView: UIView {

  @IBOutlet weak var buttonsContainerView: UIView!
  
  class func viewFromNib() -> NavigationView?
  {
    return Bundle.main.loadNibNamed("NavigationView", owner: self, options: nil)?.first as? NavigationView
  }
  
  @IBAction func virtualBtnDidTap(_ sender: Any) {
      closeBtnDidTap(sender)
  }
  
  @IBAction func closeBtnDidTap(_ sender: Any) {
    UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseInOut, animations: {
      () -> Void in
      self.buttonsContainerView.frame.origin.y -= self.frame.height - 60
    }, completion: {
      finished in
      self.removeFromSuperview()
    })
  }

  @IBAction func myCardBtnDidTap(_ sender: Any) {
  }
  
  @IBAction func myContactsBtnDidTap(_ sender: Any) {
    
  }
  
  @IBAction func searchBtnDidTap(_ sender: Any) {
    
  }
  
  @IBAction func settingBtnDidTap(_ sender: Any) {
    
  }
  
}
