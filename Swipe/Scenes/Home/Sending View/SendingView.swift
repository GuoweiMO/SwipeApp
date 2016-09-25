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
  
  @IBOutlet weak var receiversView: UIView!
  @IBOutlet weak var receiverLabel: UILabel!
  
  @IBOutlet weak var sendingMessageLabel: UILabel!
  
  @IBOutlet weak var receiverImageView: UIImageView!
  @IBOutlet weak var yesButton: SWButton!
  @IBOutlet weak var noButton: SWButton!
  @IBOutlet weak var contactsButton: SWButton!
  @IBOutlet weak var myCardButton: SWButton!
  
  weak var output: SendingViewOutput?
  
  class func viewfromNib() -> UIView?
  {
    return Bundle.main.loadNibNamed("SendingView", owner: self, options: nil)?.first as? SendingView
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    yesButton.whiteStyle()
    noButton.redStyle()
    contactsButton.whiteStyle()
    myCardButton.redStyle()
    receiverImageView.layer.cornerRadius = 75
    resetUI()
  }
  
  func resetUI()
  {
    yesButton.isHidden = false
    noButton.isHidden = false
    receiversView.isHidden = false
    
    receiverImageView.isHidden = true
    contactsButton.isHidden = true
    myCardButton.isHidden = true
    sendingMessageLabel.text = "Sending your card to"
  }
  
  @IBAction func noButtonDidTap(_ sender: AnyObject) {
    moveViewToBack()
  }
  
  @IBAction func yesButtonDidTap(_ sender: AnyObject) {
    output?.userDidConfirmSending()
  }
  
  func updateViewUIAtSending() {
    yesButton.isHidden = true
    noButton.isHidden = true
    receiversView.isHidden = true
    
    receiverImageView.isHidden = false
  }
  
  func updateUIWhenSent(){
    sendingMessageLabel.text = "Your card has been sent to"
    //TODO: update receiver image UI
    
    contactsButton.isHidden = false
    myCardButton.isHidden = false
  }
  
  @IBAction func myCardButtonDidTap(_ sender: AnyObject) {
    output?.cardSentNavigateToHome()
  }
  
  @IBAction func myContactsButtonDidTap(_ sender: AnyObject) {
    //TODO: go to contacts view
    
  }
  
  func moveViewToBack()
  {
    UIView.animate(withDuration: 0.5) { 
      self.superview?.sendSubview(toBack: self)
    }
  }
}
