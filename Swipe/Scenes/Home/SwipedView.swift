//
//  SwipedView.swift
//  Swipe
//
//  Created by Guowei Mo on 27/12/2016.
//  Copyright © 2016 Guowei Mo. All rights reserved.
//

import UIKit

protocol SwipedViewOutput {
  func triggerSwipeAction()
}


class SwipedView: UIView {

  enum ViewState {
    case normal
    case error
  }
  
  @IBOutlet weak var radarContainer: RadarView!
  @IBOutlet weak var counterLabel: UILabel!
  @IBOutlet weak var secondsLabel: UILabel!
  @IBOutlet weak var swipeAgainButton: SWButton!
  @IBOutlet weak var timeoutErrorLabel: UILabel!
  
  var radarView: RadarView!
  var output: SwipedViewOutput?
  var state: ViewState = .normal {
    didSet {
      if state == .normal {
        swipeAgainButton.isHidden = true
        timeoutErrorLabel.isHidden = true
        
        counterLabel.isHidden = false
        secondsLabel.isHidden = false
      }
      else if state == .error {
        swipeAgainButton.isHidden = false
        timeoutErrorLabel.isHidden = false
        
        counterLabel.isHidden = true
        secondsLabel.isHidden = true
      }
    }
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    swipeAgainButton.clearStyleWhiteBorder()
    radarView = RadarView.viewFromNib()
    radarView.frame = radarContainer.bounds
    radarContainer.addSubview(radarView)
    radarView.initViews()
    state = .normal
  }
  
  func startCounter() {
    var start = 30
    radarView.start()
    if #available(iOS 10.0, *) {
      Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
        [unowned self] (timer) in
        start -= 1
        self.counterLabel.text = "\(start)"
        if start == 0 {
          timer.invalidate()
          self.radarView.invalidate()
//          self.output?.swipedTimeout()
          self.state = .error
        }
      }
    } else {
      // Fallback on earlier versions
    }
  }
  
  @IBAction func swipeAgainDidTap(_ sender: Any) {
    state = .normal
    startCounter()
    output?.triggerSwipeAction()
  }
}
