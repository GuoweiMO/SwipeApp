//
//  SendingView.swift
//  Swipe
//
//  Created by Guowei Mo on 19/09/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

protocol ReceivingViewOutput:class {
  func userDidConfirmSending()
  func cardSentNavigateToHome()
}

class ReceivingView: UIView {
  
  @IBOutlet weak var senderLabel: UILabel!
  
  @IBOutlet weak var receivingMessageLabel: UILabel!
  
  @IBOutlet weak var receiverImageView: UIImageView!
  
  @IBOutlet weak var contactsButton: SWButton!
  @IBOutlet weak var myCardButton: SWButton!
  @IBOutlet weak var navBar: UINavigationBar!
  
  weak var output: ReceivingViewOutput?
  
  class func viewfromNib() -> ReceivingView?
  {
    return Bundle.main.loadNibNamed("ReceivingView", owner: self, options: nil)?.first as? ReceivingView
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    navBar.items?.first?.titleView = UIImageView(image: UIImage(named: "text-logo-white"))
    navBar.setBackgroundImage(UIImage(), for:.default)
    navBar.shadowImage = UIImage()
    navBar.backgroundColor = UIColor.clear
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    contactsButton.whiteStyle()
    myCardButton.redStyle()
    receiverImageView.layer.cornerRadius = 75
  }
  
  func resetView() {
    receivingMessageLabel.text = "is sending you a card"
    contactsButton.isHidden = true
    myCardButton.isHidden = true
  }
  
  func updateViewWhenReceived() {
    receivingMessageLabel.text = "sent you a card"
    contactsButton.isHidden = false
    myCardButton.isHidden = false
  }
}
