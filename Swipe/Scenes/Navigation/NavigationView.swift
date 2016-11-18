//
//  NavigationView.swift
//  Swipe
//
//  Created by Guowei Mo on 29/10/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

protocol NavigationViewDelegate {
  func present(withViewController viewController: UIViewController)
}

class NavigationView: UIView {

  @IBOutlet weak var buttonsContainerView: UIView!
  
  var delegate: NavigationViewDelegate?
  
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
    closeBtnDidTap(sender)
    if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home") as? HomeViewController {
      delegate?.present(withViewController: vc)
    }
  }
  
  @IBAction func myContactsBtnDidTap(_ sender: Any) {
    closeBtnDidTap(sender)
    if let vc = mainStoryBoard.instantiateViewController(withIdentifier: "contacts") as? ContactsViewController {
      delegate?.present(withViewController: vc)
    }
  }
  
  @IBAction func searchBtnDidTap(_ sender: Any) {
    closeBtnDidTap(sender)

  }
  
  @IBAction func settingBtnDidTap(_ sender: Any) {
    closeBtnDidTap(sender)

  }
  
}
