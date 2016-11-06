//
//  ContactsViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 05/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

  @IBOutlet weak var navBar: UINavigationBar!
  @IBOutlet weak var listButton: ViewButton!
  @IBOutlet weak var gridButton: ViewButton!
  @IBOutlet weak var slideButton: ViewButton!
  
  override func viewDidLoad() {
      super.viewDidLoad()
  }
  
  override func viewDidLayoutSubviews() {
    updateNavBarTitleImage(named: "text-logo-white")
    navBar.setBackgroundImage(UIImage(), for:.default)
    navBar.shadowImage = UIImage()
    navBar.backgroundColor = UIColor.clear
    
  }
  
  func updateNavBarTitleImage(named name: String)
  {
    navBar.items?.first?.titleView = UIImageView(image: UIImage(named: name))
  }

  
}

extension ContactsViewController: NavigationViewDelegate {
  
  @IBAction func navigationBtnDidTap(_ sender: Any) {
    Common.createNavigationIn(viewController: self)
  }
  
  func present(withViewController viewController: UIViewController) {
    if !(viewController is ContactsViewController) {
      present(viewController, animated: false, completion: {
      
      })
    }
  }
}

class ViewButton: UIButton {
  override func draw(_ rect: CGRect) {
    layer.borderColor = UIColor.white.cgColor
    layer.borderWidth = 0
    layer.cornerRadius = frame.height / 2.0
  }
}

