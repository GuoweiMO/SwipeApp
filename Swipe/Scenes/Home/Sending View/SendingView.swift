//
//  SendingView.swift
//  Swipe
//
//  Created by Guowei Mo on 19/09/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

protocol SendingViewOutput:class {
  func userDidConfirmSending()
  func cardSentNavigateToHome()
}

class SendingView: UIView {
  
//  @IBOutlet weak var receiversView: UIView!
  @IBOutlet weak var receiverLabel: UILabel!
  
  @IBOutlet weak var sendingMessageLabel: UILabel!
  
  @IBOutlet weak var receiverImageView: UIImageView!
  @IBOutlet weak var yesButton: SWButton!
  @IBOutlet weak var noButton: SWButton!
  @IBOutlet weak var contactsButton: SWButton!
  @IBOutlet weak var myCardButton: SWButton!
  
  @IBOutlet weak var finishedView: UIImageView!
  
  weak var output: SendingViewOutput?
    
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    yesButton.whiteStyle()
    noButton.redStyle()
    contactsButton.whiteStyle()
    myCardButton.redStyle()
    receiverImageView.layer.cornerRadius = 75
    resetView()
  }
  
  func resetView()
  {
    yesButton.isHidden = false
    noButton.isHidden = false
    
    receiverImageView.isHidden = true
    contactsButton.isHidden = true
    myCardButton.isHidden = true
    sendingMessageLabel.text = "Sending your card to"
    finishedView.isHidden = true
    receiverLabel.text = "waiting receiver..."
  }
  
  func updateView(withSender sender: String) {
    receiverLabel.text = sender
  }
  
  func updateView(withImage image: UIImage) {
    receiverImageView.isHidden = false
    receiverImageView.image = image
  }
  
  @IBAction func noButtonDidTap(_ sender: AnyObject) {
    
  }
  
  @IBAction func yesButtonDidTap(_ sender: AnyObject) {
    output?.userDidConfirmSending()
  }
  
  func updateViewAtSending() {
    yesButton.isHidden = true
    noButton.isHidden = true
  }
  
  func updateViewWhenSent(){
    sendingMessageLabel.text = "Your card has been sent to"
    
    contactsButton.isHidden = false
    myCardButton.isHidden = false
    finishedView.isHidden = false
  }
  
  @IBAction func myCardButtonDidTap(_ sender: AnyObject) {
    output?.cardSentNavigateToHome()
  }
  
  @IBAction func myContactsButtonDidTap(_ sender: AnyObject) {
    //TODO: go to contacts view
    
  }
}
