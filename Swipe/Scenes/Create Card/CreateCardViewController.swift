//
//  CreateCardViewController.swift
//  Swipe
//
//  Created by Guowei Mo on 16/09/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

protocol CreateCardDelegate {
  func createCardDidSucceed()
}

class CreateCardViewController: UIViewController, CreateCardDelegate {
  
  @IBOutlet weak var cardContainer: UIView!
  var cardView: CardInfoView!
  override func viewDidLoad() {
    super.viewDidLoad()
    cardView = CardInfoView.viewFromNib() as! CardInfoView
    cardContainer.addSubview(cardView)
    cardView.frame = cardContainer.bounds
    cardView.delegate = self
  }
  
  func createCardDidSucceed() {
    if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home") as? HomeViewController
    {
      present(vc, animated: true) {}
    }
  }
}
