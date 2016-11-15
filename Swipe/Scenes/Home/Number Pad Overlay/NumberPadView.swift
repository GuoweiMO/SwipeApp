//
//  NumberPadView.swift
//  Swipe
//
//  Created by Guowei Mo on 13/11/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

class NumberPadView: UIView {
  
  @IBOutlet weak var firstNumberLabel: UILabel!
  @IBOutlet weak var secondNumberLabel: UILabel!
  @IBOutlet weak var thirdNumberLabel: UILabel!
  
  @IBOutlet var numberButtons: [SWButton1]!
  
  var counter: Int = 0
  
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
        if !btn.btnSelected {
          btn.disabledStyle()
        }
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
  
  
  
}
