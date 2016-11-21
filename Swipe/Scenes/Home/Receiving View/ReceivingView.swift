//
//  SendingView.swift
//  Swipe
//
//  Created by Guowei Mo on 19/09/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

protocol ReceivingViewOutput:class {
  func cardReceivedNavigateToHome()
}

class ReceivingView: UIView {
  
  @IBOutlet weak var senderLabel: UILabel!
  
  @IBOutlet weak var receivingMessageLabel: UILabel!
  
  @IBOutlet weak var senderImageView: UIImageView!
  
  @IBOutlet weak var contactsButton: SWButton!
  @IBOutlet weak var myCardButton: SWButton!
  
  weak var output: ReceivingViewOutput?
  @IBOutlet weak var finishedView: UIImageView!
  
  class func viewfromNib() -> ReceivingView?
  {
    return Bundle.main.loadNibNamed("ReceivingView", owner: self, options: nil)?.first as? ReceivingView
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    contactsButton.whiteStyle()
    myCardButton.redStyle()
    senderImageView.layer.cornerRadius = 75
  }
  
  func resetView() {
    receivingMessageLabel.text = "is sending you a card"
    contactsButton.isHidden = true
    myCardButton.isHidden = true
    finishedView.isHidden = true
  }
  
  func updateViewWhenReceived() {
    receivingMessageLabel.text = "sent you a card"
    contactsButton.isHidden = false
    myCardButton.isHidden = false
    finishedView.isHidden = false
  }
  
  func updateView(withSender sender: String) {
    senderLabel.text = sender
    contactsButton.setTitle("See \(sender)'s Card", for: .normal)
  }
  
  func updateView(withImage image: UIImage) {
    senderImageView.image = image
  }
  
  @IBAction func myCardBtnDidTap(_ sender: AnyObject) {
    output?.cardReceivedNavigateToHome()
  }
}
