//
//  NumberPadView.swift
//  Swipe
//
//  Created by Guowei Mo on 13/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

enum Action {
  case send
  case receive
}

class NumberPadView: UIView {
  
  @IBOutlet weak var firstNumberLabel: UILabel!
  @IBOutlet weak var secondNumberLabel: UILabel!
  @IBOutlet weak var thirdNumberLabel: UILabel!
  
  @IBOutlet var numberButtons: [SWButton1]!
  
  var counter: Int = 0
  var action: Action?
  
  class func viewfromNib() -> NumberPadView? {
    return Bundle.main.loadNibNamed("NumberPadView", owner: self, options: nil)?.first as? NumberPadView
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  @IBAction func numberBtnSelected(_ sender: SWButton1) {
    counter += 1
    if counter > 3 { return }
    sender.selectedStyle()
    switch counter {
    case 1:
      firstNumberLabel.text = sender.currentTitle!
      firstNumberLabel.textColor = Common.appRedColor()
    case 2:
      secondNumberLabel.text = sender.currentTitle!
      secondNumberLabel.textColor = Common.appRedColor()
    case 3:
      thirdNumberLabel.text = sender.currentTitle!
      thirdNumberLabel.textColor = Common.appRedColor()
    default:
      break
    }
    if counter == 3 {
      numberButtons.forEach({ (btn) in
//        if !btn.btnSelected {
          btn.disabledStyle()
//        }
      })
    }
  }
  
  func resetSelectedNumbers() {
    firstNumberLabel.text = "−"
    firstNumberLabel.textColor = UIColor.white

    secondNumberLabel.text = "−"
    secondNumberLabel.textColor = UIColor.white

    thirdNumberLabel.text = "−"
    thirdNumberLabel.textColor = UIColor.white
  }
  
  @IBAction func yesButtonDidTap(_ sender: UIButton) {
    let token = "\(firstNumberLabel.text!)\(secondNumberLabel.text!)\(thirdNumberLabel.text!)"
    guard token.containsNumbersOnly() else { return }
    
    if action == .send {
      SWActions.requestToSendCard(withToken: token, andCompletion: {
        (err, dbRef) -> Void in
        if err == nil {
          self.animateFadeOut()
        }
      })
    } else if action == .receive {
      SWActions.requestToReceiveCard(withToken: token, senderFoundCompletion: { (senderInfo) in
        self.animateFadeOut()
        let senderCard = SWCard()
        senderCard.updateCard(withFullData: senderInfo)
        
//        SWActions.updateContactsWhenCardReceived(fromSender: )
        
      }, andError: { (err) in
        print("sender not found")
      })
    }
    
  }
  
  func animateFadeOut() {
    UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseOut, animations: {
      self.alpha = 0
    }, completion:{
      completed in
      self.isHidden = true
      self.alpha = 1
    })
  }
}
